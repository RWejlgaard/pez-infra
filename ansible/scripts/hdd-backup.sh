#!/usr/bin/env bash

set -euo pipefail

BUCKET="b2:london-b-hdd"
DIRS=(archive backups stash syncthing ftp)
EMAIL="pez@pez.sh"
SUBJECT="HDD Backup Report - $(date '+%Y-%m-%d %H:%M')"

failures=()
report=""

for dir in "${DIRS[@]}"; do
    src="/hdd/$dir"
    dst="$BUCKET/$dir"
    echo "Syncing $src -> $dst"

    output=$(rclone sync "$src" "$dst" -v 2>&1); rc=$?
    output=$(grep -v "Can't follow symlink without -L/--copy-links" <<< "$output")
    [[ $rc -ne 0 ]] && failures+=("$dir")

    report+="=== $dir ===\n$output\n\n"
done

# Get bucket storage usage
bucket_usage=$(rclone size "$BUCKET" 2>&1) || bucket_usage="(failed to retrieve bucket size)"

if [[ ${#failures[@]} -gt 0 ]]; then
    failure_summary="FAILURES: ${failures[*]}"
else
    failure_summary="All syncs completed successfully."
fi

{
    echo -e "Backup completed: $(date '+%Y-%m-%d %H:%M:%S')"
    echo -e "$failure_summary\n"
    echo -e "=== Bucket Usage ===\n$bucket_usage\n"
    #echo -e "=== Sync Output ===\n$report"
} | mutt -s "$SUBJECT" "$EMAIL"
