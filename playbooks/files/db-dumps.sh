#!/usr/bin/env fish

# Consistent copies of the live databases for the restic backup, collected in one directory.
# restic copies files one by one while the apps keep writing, so a live .db (+ -wal) can be torn.
# The SQLite online backup API takes a consistent snapshot without stopping the container.
# A dump only replaces the previous one once it passed its check, so the last good dump always stays.
# backup.sh reports missing or stale dumps.

set DUMP_DIR /srv/db-dumps
set FAILED 0

for DB in (string match -rv '^\s*(#|$)' < /etc/db-dumps.list)
    set DUMP $DUMP_DIR/(string split / $DB)[4]-(basename $DB)
    set TMP $DB.dump-tmp
    echo "["(date "+%Y-%m-%d %H:%M:%S")"] Dumping $DB…"

    if not test -f $DB
        echo "["(date "+%Y-%m-%d %H:%M:%S")"] Missing $DB"
        set FAILED (math $FAILED + 1)
        continue
    end

    # Run as the file owner: opening a WAL database as root could leave root-owned -wal/-shm
    # files behind that the app can no longer write.
    set RUN setpriv --reuid=(stat -c %u $DB) --regid=(stat -c %g $DB) --clear-groups

    rm -f $TMP
    # The copy inherits WAL mode; switch it to a single self-contained file before checking it.
    if $RUN sqlite3 $DB ".timeout 60000" ".backup '$TMP'"
        and $RUN sqlite3 $TMP "PRAGMA journal_mode=DELETE;" >/dev/null
        and test "$($RUN sqlite3 $TMP 'PRAGMA quick_check;')" = ok
        chown root:restic $TMP
        chmod 0640 $TMP
        mv -f $TMP $DUMP
    else
        echo "["(date "+%Y-%m-%d %H:%M:%S")"] Dump of $DB failed, keeping the previous dump"
        rm -f $TMP
        set FAILED (math $FAILED + 1)
    end
    rm -f $TMP-wal $TMP-shm
end

# Immich dumps Postgres itself (01:57). Hard-link the newest one so backup.sh can check its age;
# a hard link costs no space and keeps the file even after Immich rotates it away.
set IMMICH_DUMP (ls -t /srv/docker/immich/backups/immich-db-backup-*.sql.gz 2>/dev/null)[1]
if test -n "$IMMICH_DUMP"
    ln -f $IMMICH_DUMP $DUMP_DIR/immich.sql.gz
else
    echo "["(date "+%Y-%m-%d %H:%M:%S")"] No Immich dump found"
    set FAILED (math $FAILED + 1)
end

echo "["(date "+%Y-%m-%d %H:%M:%S")"] DB dumps finished, $FAILED failed."
exit $FAILED
