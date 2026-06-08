#!/bin/bash
# Truncate large Docker container log files.
#
# Managed by Ansible (docker role) — deployed to /usr/local/bin/ on all
# docker_hosts and run monthly via cron. Do not edit on the host.
#
# Safety net for containers using the json-file log driver; most containers
# ship logs via the Loki driver and never write *-json.log, so on a healthy
# host this is usually a no-op.

LOG_DIR=/var/lib/docker/containers
MAX_SIZE_MB=100

find "$LOG_DIR" -name '*-json.log' | while read -r logfile; do
    size_mb=$(du -m "$logfile" | cut -f1)
    if [ "$size_mb" -gt "$MAX_SIZE_MB" ]; then
        echo "$(date): Truncating $logfile (${size_mb}MB)" >> /var/log/docker-log-cleanup.log
        truncate -s 0 "$logfile"
    fi
done
