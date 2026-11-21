#!/usr/bin/env bash
# Re-encode the Apple Intermediate Codec (AIC) clips of the family clips library to HEVC, in place.
#
#   ssh beelink 'bash -s' < scripts/convert-aic.sh                  # start, runs detached on the server
#   ssh beelink docker logs -f aic-convert                          # follow (Ctrl-C only stops following)
#   ssh beelink 'QUALITY=22 bash -s' < scripts/convert-aic.sh       # other quality (lower = better)
#
# Encodes on the Intel GPU (Quick Sync) with at most 2 CPU cores. Only AIC clips are touched, so a rerun
# resumes where it stopped. Each clip is written to a hidden ._aic-* temp file (excluded by Immich), checked
# (frames, duration, capture date tag) and only then moved over the original. Same name, so the Immich asset,
# albums and faces stay; mtime is the original's + 1 s so the library scan picks up the new file.
set -euo pipefail

LIBRARY=${LIBRARY:-/srv/originals/family/clips}
LOG_DIR=${LOG_DIR:-/home/timon/aic-convert}
QUALITY=${QUALITY:-19}
IMG=$(docker inspect -f '{{.Config.Image}}' immich_server)

mkdir -p "$LOG_DIR"
docker rm -f aic-convert >/dev/null 2>&1 || true
docker run -d --name aic-convert --network none --cpus 2 --device /dev/dri \
  --user "$(id -u):$(getent group family | cut -d: -f3)" --group-add "$(getent group render | cut -d: -f3)" \
  -e QUALITY="$QUALITY" -v "$LIBRARY":/clips -v "$LOG_DIR":/log \
  --entrypoint bash "$IMG" -c '
probe() { ffprobe -v error -of csv=p=0 "$@" </dev/null; }
log() { echo "[$(date "+%F %T")] $*" | tee -a /log/convert.log; }

log "start, quality $QUALITY"
converted=0; failed=0; before=0; after=0; start=$(date +%s)
while IFS= read -r -d "" f; do
  read -r codec field < <(probe -select_streams v:0 -show_entries stream=codec_name,field_order "$f" | tr , " ")
  [ "$codec" = aic ] || continue
  dir=$(dirname "$f"); name=$(basename "$f"); tmp="$dir/._aic-$name"; rel=${f#/clips/}

  # the camera stored left and right as two mono tracks: merge them back into one stereo track
  if [ "$(probe -select_streams a -show_entries stream=channels "$f" | tr "\n" " ")" = "1 1 " ]; then
    audio=(-filter_complex "[0:a:0][0:a:1]amerge=inputs=2[a]" -map "[a]")
  else
    audio=(-map "0:a?")
  fi
  video=()
  case "$field" in tt|bb|tb|bt) video=(-vf bwdif=mode=send_frame) ;; esac

  rm -f "$tmp"
  if ! nice -n 10 ffmpeg -nostdin -hide_banner -loglevel error -i "$f" \
      -map 0:v:0 "${video[@]}" "${audio[@]}" -fps_mode:v passthrough -enc_time_base:v demux \
      -c:v hevc_qsv -preset slow -global_quality "$QUALITY" -pix_fmt nv12 -tag:v hvc1 \
      -c:a aac -b:a 160k \
      -map_metadata 0 -movflags +use_metadata_tags+faststart \
      "$tmp"; then
    log "FAILED encode: $rel"; rm -f "$tmp"; failed=$((failed + 1)); continue
  fi

  # same frames at the same timestamps (some clips have irregular frame timing, which must survive)
  frames_in=$(probe -select_streams v:0 -show_entries packet=pts_time "$f" | sort -n | md5sum | cut -c1-12)
  frames_out=$(probe -select_streams v:0 -show_entries packet=pts_time "$tmp" | sort -n | md5sum | cut -c1-12)
  date_in=$(probe -show_entries format_tags=com.apple.quicktime.creationdate "$f")
  date_out=$(probe -show_entries format_tags=com.apple.quicktime.creationdate "$tmp")
  dur_in=$(probe -show_entries format=duration "$f")
  dur_out=$(probe -show_entries format=duration "$tmp")
  if [ "$frames_in" != "$frames_out" ] || [ "$date_in" != "$date_out" ] ||
     ! awk -v a="$dur_in" -v b="$dur_out" "BEGIN { exit !(a - b < 0.2 && b - a < 0.2) }"; then
    log "FAILED check: $rel (frames $frames_in/$frames_out, date $date_in/$date_out, duration $dur_in/$dur_out)"
    rm -f "$tmp"; failed=$((failed + 1)); continue
  fi

  size_in=$(stat -c %s "$f"); size_out=$(stat -c %s "$tmp")
  touch -d "@$(( $(stat -c %Y "$f") + 1 ))" "$tmp"
  mv -f "$tmp" "$f"
  converted=$((converted + 1)); before=$((before + size_in)); after=$((after + size_out))
  log "ok $rel $((size_in / 1048576)) -> $((size_out / 1048576)) MiB${video:+ (deinterlaced)}"
done < <(find /clips -type f -iname "*.mov" ! -name "._*" -print0 | sort -z)

log "finished: $converted converted, $failed failed, $((before / 1073741824)) GiB -> $((after / 1073741824)) GiB in $(( ($(date +%s) - start) / 60 )) min"'
echo "started aic-convert, follow with: ssh beelink docker logs -f aic-convert"
