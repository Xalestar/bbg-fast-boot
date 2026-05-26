#!/bin/sh
echo "Content-Type: application/json"
echo "Cache-Control: no-cache"
echo ""

# `iw dev wlan0 info` has a stable output format; extract fields with awk
info=$(iw dev wlan0 info 2>/dev/null)

ssid=$(echo "$info"     | awk '/ssid/    {print $2}')
channel=$(echo "$info"  | awk '/channel/ {print $2}')
freq=$(echo "$info"     | awk '/channel/ {gsub(/[()]/,""); print $3}')
type=$(echo "$info"     | awk '/type/    {print $2}')
txpower=$(echo "$info"  | awk '/txpower/ {print $2}')

printf '{'
printf '"ssid":"%s",'        "$ssid"
printf '"channel":%s,'       "${channel:-0}"
printf '"freq_mhz":%s,'      "${freq:-0}"
printf '"type":"%s",'        "$type"
printf '"txpower_dbm":%s'    "${txpower:-0}"
printf '}\n'
