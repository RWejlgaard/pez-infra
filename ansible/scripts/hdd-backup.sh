#!/usr/bin/env bash

set -euo pipefail

BUCKET="b2:london-b-hdd"
DIRS=(archive backups stash syncthing ftp)
EMAIL="pez@pez.sh"
SUBJECT="HDD Backup Report - $(date '+%Y-%m-%d %H:%M')"

failures=()
report=""
size_error=""

for dir in "${DIRS[@]}"; do
    src="/hdd/$dir"
    dst="$BUCKET/$dir"
    echo "Syncing $src -> $dst"

    if output=$(rclone sync "$src" "$dst" -v 2>&1); then
        rc=0
    else
        rc=$?
    fi

    output=$(grep -v "Can't follow symlink without -L/--copy-links" <<< "$output")
    [[ $rc -ne 0 ]] && failures+=("$dir")

    report+="=== $dir ===\n$output\n\n"
done

# Get bucket storage usage
if bucket_usage=$(rclone size "$BUCKET" 2>&1); then
    :
else
    size_error="failed to retrieve bucket size"
    report+="=== Bucket Usage Error ===\n$bucket_usage\n\n"
    bucket_usage="($size_error)"
fi

if [[ ${#failures[@]} -gt 0 ]]; then
    failure_summary="FAILURES: ${failures[*]}"
else
    failure_summary="All syncs completed successfully."
fi

if [[ ${#failures[@]} -gt 0 || -n "$size_error" ]]; then
    {
        echo -e "Backup completed: $(date '+%Y-%m-%d %H:%M:%S')"
        echo -e "$failure_summary\n"
        echo -e "=== Bucket Usage ===\n$bucket_usage\n"
        echo -e "=== Sync Output ===\n$report"
    } | mutt -s "$SUBJECT" "$EMAIL"
fi
