#!/usr/bin/env bash
# Re-encode the MPEG-2 camcorder clips (interlaced PAL SD) of the family clips library to HEVC 50p, in place.
#
#   ssh beelink 'bash -s' < scripts/convert-mpeg2.sh                  # start, runs detached on the server
#   ssh beelink docker logs -f mpeg2-convert                          # follow (Ctrl-C only stops following)
#   ssh beelink 'QUALITY=22 bash -s' < scripts/convert-mpeg2.sh       # other quality (lower = better)
#
# Same approach as convert-aic.sh: Quick Sync with at most 2 CPU cores, only MPEG-2 clips are touched so a rerun
# resumes, hidden ._mpeg2-* temp file (excluded by Immich), checks before the original is replaced, same name
# (the .xmp sidecars holding the corrected capture dates stay attached), mtime + 1 s for the library scan.
# Interlaced clips become 50p: every field turns into a full frame, so the output has exactly twice the frames.
set -euo pipefail

LIBRARY=${LIBRARY:-/srv/originals/family/clips}
LOG_DIR=${LOG_DIR:-/home/timon/mpeg2-convert}
QUALITY=${QUALITY:-19}
IMG=$(docker inspect -f '{{.Config.Image}}' immich_server)

mkdir -p "$LOG_DIR"
docker rm -f mpeg2-convert >/dev/null 2>&1 || true
docker run -d --name mpeg2-convert --network none --cpus 2 --device /dev/dri \
  --user "$(id -u):$(getent group family | cut -d: -f3)" --group-add "$(getent group render | cut -d: -f3)" \
  -e QUALITY="$QUALITY" -v "$LIBRARY":/clips -v "$LOG_DIR":/log \
  --entrypoint bash "$IMG" -c '
probe() { ffprobe -v error -of csv=p=0 "$@" </dev/null; }
log() { echo "[$(date "+%F %T")] $*" | tee -a /log/convert.log; }
# frames that are actually shown: iMovie hides a few lead-in frames behind an edit list, packet counts include them
frames() { probe -count_frames -select_streams v:0 -show_entries stream=nb_read_frames "$1" | cut -d, -f1; }

log "start, quality $QUALITY"
converted=0; failed=0; before=0; after=0; start=$(date +%s)
while IFS= read -r -d "" f; do
  read -r codec field _ < <(probe -select_streams v:0 -show_entries stream=codec_name,field_order "$f" | tr , " ")
  [ "$codec" = mpeg2video ] || continue
  dir=$(dirname "$f"); name=$(basename "$f"); tmp="$dir/._mpeg2-$name"; rel=${f#/clips/}

  # the camera stored left and right as two mono tracks: merge them back into one stereo track
  if [ "$(probe -select_streams a -show_entries stream=channels "$f" | tr "\n" " ")" = "1 1 " ]; then
    audio=(-filter_complex "[0:a:0][0:a:1]amerge=inputs=2[a]" -map "[a]")
  else
    audio=(-map "0:a?")
  fi
  video=(); factor=1
  case "$field" in tt|bb|tb|bt) video=(-vf bwdif=mode=send_field:parity=auto); factor=2 ;; esac

  rm -f "$tmp"
  if ! nice -n 10 ffmpeg -nostdin -hide_banner -loglevel error -i "$f" \
      -map 0:v:0 "${video[@]}" "${audio[@]}" \
      -c:v hevc_qsv -preset slow -global_quality "$QUALITY" -pix_fmt nv12 -tag:v hvc1 \
      -c:a aac -b:a 160k \
      -map_metadata 0 -movflags +use_metadata_tags+faststart \
      "$tmp"; then
    log "FAILED encode: $rel"; rm -f "$tmp"; failed=$((failed + 1)); continue
  fi

  frames_in=$(frames "$f"); frames_out=$(frames "$tmp")
  date_in=$(probe -show_entries format_tags=creation_time "$f")
  date_out=$(probe -show_entries format_tags=creation_time "$tmp")
  aspect_in=$(probe -select_streams v:0 -show_entries stream=display_aspect_ratio "$f" | cut -d, -f1)
  aspect_out=$(probe -select_streams v:0 -show_entries stream=display_aspect_ratio "$tmp" | cut -d, -f1)
  dur_in=$(probe -show_entries format=duration "$f")
  dur_out=$(probe -show_entries format=duration "$tmp")
  if [ -z "$frames_in" ] || [ "$frames_out" != "$((frames_in * factor))" ] || [ "$date_in" != "$date_out" ] ||
     [ "$aspect_in" != "$aspect_out" ] ||
     ! awk -v a="$dur_in" -v b="$dur_out" "BEGIN { exit !(a - b < 0.2 && b - a < 0.2) }"; then
    log "FAILED check: $rel (frames $frames_in x$factor/$frames_out, date $date_in/$date_out, aspect $aspect_in/$aspect_out, duration $dur_in/$dur_out)"
    rm -f "$tmp"; failed=$((failed + 1)); continue
  fi

  size_in=$(stat -c %s "$f"); size_out=$(stat -c %s "$tmp")
  touch -d "@$(( $(stat -c %Y "$f") + 1 ))" "$tmp"
  mv -f "$tmp" "$f"
  converted=$((converted + 1)); before=$((before + size_in)); after=$((after + size_out))
  log "ok $rel $((size_in / 1048576)) -> $((size_out / 1048576)) MiB${video:+ (50p)}"
done < <(find /clips -type f -iname "*.mov" ! -name "._*" -print0 | sort -z)

log "finished: $converted converted, $failed failed, $((before / 1073741824)) GiB -> $((after / 1073741824)) GiB in $(( ($(date +%s) - start) / 60 )) min"'
echo "started mpeg2-convert, follow with: ssh beelink docker logs -f mpeg2-convert"
