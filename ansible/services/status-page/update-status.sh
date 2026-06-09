#!/bin/bash
# update-status.sh — Fetch Prometheus metrics and write /srv/status/status.json + history
set -euo pipefail

PROMETHEUS="http://100.122.219.41:9090"
OUTPUT="/srv/status/status.json"
HISTORY_LOG="/srv/status/history.log"
HISTORY_JSON="/srv/status/history.json"
QUERY="caddy_reverse_proxy_upstreams_healthy"

# Service map: upstream address → display name
declare -A SERVICE_MAP
SERVICE_MAP["localhost:8443"]="Bitwarden"
SERVICE_MAP["100.122.219.41:3000"]="Grafana"
SERVICE_MAP["100.84.65.101:32400"]="Plex"
SERVICE_MAP["100.84.65.101:4533"]="Navidrome"
SERVICE_MAP["100.84.65.101:5030"]="Soulseek"
SERVICE_MAP["100.84.65.101:5055"]="Overseerr"
SERVICE_MAP["100.84.65.101:5056"]="Jellyfin Requests"
SERVICE_MAP["100.84.65.101:7878"]="Radarr"
SERVICE_MAP["100.84.65.101:8096"]="Jellyfin"
SERVICE_MAP["100.84.65.101:8686"]="Lidarr"
SERVICE_MAP["100.84.65.101:8787"]="Readarr"
SERVICE_MAP["100.84.65.101:8989"]="Sonarr"
SERVICE_MAP["100.84.65.101:9091"]="Transmission"
SERVICE_MAP["100.84.65.101:9696"]="Prowlarr"
SERVICE_MAP["localhost:9091"]="Authelia"
SERVICE_MAP["localhost:3000"]="Forgejo"

# Desired display order
DISPLAY_ORDER=(
  "localhost:8443"
  "localhost:9091"
  "100.84.65.101:11000"
  "100.122.219.41:3000"
  "100.84.65.101:32400"
  "100.84.65.101:8096"
  "100.84.65.101:5056"
  "100.84.65.101:4533"
  "100.84.65.101:5030"
  "100.84.65.101:5055"
  "100.84.65.101:7878"
  "100.84.65.101:8989"
  "100.84.65.101:8686"
  "100.84.65.101:8787"
  "100.84.65.101:9696"
  "100.84.65.101:9091"
  "localhost:3000"
)

# Fetch from Prometheus
RESPONSE=$(curl -sf --max-time 10 \
  "${PROMETHEUS}/api/v1/query?query=${QUERY}" 2>/dev/null) || {
  echo "ERROR: Failed to fetch Prometheus metrics" >&2
  exit 1
}

# Parse with jq — build a lookup of upstream→value
UPSTREAM_DATA=$(echo "$RESPONSE" | jq -r '
  .data.result[] |
  .metric.upstream + " " + .value[1]
' 2>/dev/null) || {
  echo "ERROR: Failed to parse Prometheus response" >&2
  exit 1
}

# Build services JSON array
UPDATED=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
HAS_DOWN=0
HAS_UP=0

SERVICES_JSON=""
HISTORY_SERVICES=""

for upstream in "${DISPLAY_ORDER[@]}"; do
  name="${SERVICE_MAP[$upstream]:-}"
  [ -z "$name" ] && continue

  # Look up health value for this upstream
  value=$(echo "$UPSTREAM_DATA" | grep -F "$upstream " | awk '{print $NF}' | head -1)

  if [ "$value" = "1" ]; then
    status="operational"
    hist_val=1
    HAS_UP=1
  elif [ "$value" = "0" ]; then
    status="degraded"
    hist_val=0
    HAS_DOWN=1
  else
    status="degraded"
    hist_val=0
    HAS_DOWN=1
  fi

  if [ -n "$SERVICES_JSON" ]; then
    SERVICES_JSON="${SERVICES_JSON},"
  fi
  SERVICES_JSON="${SERVICES_JSON}{\"name\":\"${name}\",\"status\":\"${status}\"}"

  if [ -n "$HISTORY_SERVICES" ]; then
    HISTORY_SERVICES="${HISTORY_SERVICES},"
  fi
  HISTORY_SERVICES="${HISTORY_SERVICES}\"${name}\":${hist_val}"
done

# Determine overall status
if [ $HAS_DOWN -eq 0 ]; then
  OVERALL="operational"
elif [ $HAS_UP -eq 0 ]; then
  OVERALL="outage"
else
  OVERALL="degraded"
fi

# Write status.json
mkdir -p "$(dirname "$OUTPUT")"
cat > "$OUTPUT" <<EOF
{
  "updated": "${UPDATED}",
  "overall": "${OVERALL}",
  "services": [${SERVICES_JSON}]
}
EOF

echo "[$UPDATED] Status written to $OUTPUT (overall: $OVERALL)"

# ===== History tracking =====

# Append current check to history.log
echo "{\"ts\":\"${UPDATED}\",\"services\":{${HISTORY_SERVICES}}}" >> "$HISTORY_LOG"

# Trim history.log to last 129600 lines (90 days × 24h × 60min)
MAX_LINES=129600
LINE_COUNT=$(wc -l < "$HISTORY_LOG")
if [ "$LINE_COUNT" -gt "$MAX_LINES" ]; then
  tail -n "$MAX_LINES" "$HISTORY_LOG" > "${HISTORY_LOG}.tmp" && mv "${HISTORY_LOG}.tmp" "$HISTORY_LOG"
fi

# Regenerate history.json from history.log
python3 - "$HISTORY_LOG" "$HISTORY_JSON" <<'PYEOF'
import sys, json
from datetime import datetime, timezone, timedelta
from collections import defaultdict

history_log = sys.argv[1]
history_json_path = sys.argv[2]

# Parse all log lines, group by hour key
hour_data = defaultdict(lambda: defaultdict(list))

try:
    with open(history_log) as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            try:
                entry = json.loads(line)
                ts = entry['ts']
                hour_key = ts[:13]  # e.g. "2026-03-03T19"
                for svc, val in entry['services'].items():
                    hour_data[hour_key][svc].append(val)
            except Exception:
                continue
except FileNotFoundError:
    pass

# Generate exactly 2160 hour slots (90 days), oldest first, ending at current hour
now = datetime.now(timezone.utc)
current_hour = now.replace(minute=0, second=0, microsecond=0)
slots = [(current_hour - timedelta(hours=2159 - i)) for i in range(2160)]
slot_keys = [h.strftime('%Y-%m-%dT%H') for h in slots]

# Collect all service names from log data
service_names = set()
for hour_vals in hour_data.values():
    service_names.update(hour_vals.keys())

result = {
    'days': 90,
    'generated': now.strftime('%Y-%m-%dT%H:%M:%SZ'),
    'services': {}
}

for svc in sorted(service_names):
    hours_list = []
    for slot_key in slot_keys:
        checks = hour_data.get(slot_key, {}).get(svc, [])
        if not checks:
            hours_list.append(None)
        else:
            # Majority vote: >50% up → 1, otherwise 0
            hours_list.append(1 if sum(checks) > len(checks) / 2 else 0)

    valid = [h for h in hours_list if h is not None]
    uptime_pct = round(sum(valid) / len(valid) * 100, 2) if valid else None

    result['services'][svc] = {
        'uptime_percent': uptime_pct,
        'hours': hours_list
    }

with open(history_json_path, 'w') as f:
    json.dump(result, f, separators=(',', ':'))

print(f"[history] Wrote {history_json_path} ({len(service_names)} services, {len(slot_keys)} hour slots)")
PYEOF
