#!/bin/sh
echo "Content-Type: application/json"
echo "Cache-Control: no-cache"
echo ""

get_iface_info() {
    ifname=$1
   
    # Grab the first line and extract flags inside <...>
    flags=$(ip link show "$ifname" 2>/dev/null | head -1 | grep -o '<[^>]*>')
    
    # Determine state: UP requires both UP and LOWER_UP flags
    if echo "$flags" | grep -q 'LOWER_UP'; then
        state="UP"
    elif echo "$flags" | grep -q ',UP,\|<UP,\|,UP>'; then
        state="NO_CARRIER"   # interface is admin-up but has no physical link
    else
        state="DOWN"
    fi
    
    ipaddr=$(ip -4 addr show "$ifname" 2>/dev/null | awk '/inet / {print $2; exit}')
    
    # Strip stray newlines
    state=$(echo "$state" | tr -d '\n\r ')
    ipaddr=$(echo "$ipaddr" | tr -d '\n\r ')
    
    printf '{"name":"%s","state":"%s","ip":"%s"}' "$ifname" "${state:-UNKNOWN}" "${ipaddr:-N/A}"
}

printf '['
get_iface_info wlan0
printf ','
get_iface_info eth0
printf ']'
