#!/bin/sh
echo "Content-Type: application/json"
echo "Cache-Control: no-cache"
echo ""

# Collect data
uptime_sec=$(awk '{print int($1)}' /proc/uptime)
kernel=$(uname -r)
mem_total=$(awk '/MemTotal/ {print $2}' /proc/meminfo)
mem_free=$(awk '/MemAvailable/ {print $2}' /proc/meminfo)
load=$(awk '{print $1}' /proc/loadavg)

# Output JSON
printf '{'
printf '"uptime":%s,' "$uptime_sec"
printf '"kernel":"%s",' "$kernel"
printf '"mem_total_kb":%s,' "$mem_total"
printf '"mem_free_kb":%s,' "$mem_free"
printf '"loadavg":%s' "$load"
printf '}\n'
