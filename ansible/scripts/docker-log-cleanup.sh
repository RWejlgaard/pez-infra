#!/bin/bash
# Truncate large Docker container log files
# Deployed on: nuremberg-a
# Cron: 0 3 1 * * /usr/local/bin/docker-log-cleanup.sh

LOG_DIR=/var/lib/docker/containers
MAX_SIZE_MB=100

find "$LOG_DIR" -name '*-json.log' | while read -r logfile; do
    size_mb=$(du -m "$logfile" | cut -f1)
    if [ "$size_mb" -gt "$MAX_SIZE_MB" ]; then
        echo "$(date): Truncating $logfile (${size_mb}MB)" >> /var/log/docker-log-cleanup.log
        truncate -s 0 "$logfile"
    fi
done
