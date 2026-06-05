#!/usr/bin/env bash

set -euo pipefail

BUCKET="b2:london-b-hdd"
DIRS=(archive backups stash syncthing ftp)
EMAIL="pez@pez.sh"
SUBJECT="HDD Backup Report - $(date '+%Y-%m-%d %H:%M')"

# Versioning: a plain `rclone sync` permanently deletes/overwrites objects at
# the destination, so a deletion or ransomware encryption on /hdd would
# propagate to the backup on the next run. Instead, move every superseded
# version into a dated folder under $VERSIONS so it can be recovered, then
# prune anything older than $RETENTION_DAYS to cap storage.
STAMP="$(date '+%Y-%m-%d_%H%M%S')"
VERSIONS="$BUCKET/_versions"
RETENTION_DAYS=30

failures=()
report=""
size_error=""

for dir in "${DIRS[@]}"; do
    src="/hdd/$dir"
    dst="$BUCKET/$dir"
    echo "Syncing $src -> $dst"

    if output=$(rclone sync "$src" "$dst" --backup-dir "$VERSIONS/$STAMP/$dir" -v 2>&1); then
        rc=0
    else
        rc=$?
    fi

    output=$(grep -v "Can't follow symlink without -L/--copy-links" <<< "$output")
    [[ $rc -ne 0 ]] && failures+=("$dir")

    report+="=== $dir ===\n$output\n\n"
done

# Prune versioned copies older than the retention window.
if prune_output=$(rclone delete "$VERSIONS" --min-age "${RETENTION_DAYS}d" -v 2>&1); then
    :
else
    failures+=("version-prune")
    report+="=== Version Prune Error ===\n$prune_output\n\n"
fi

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
