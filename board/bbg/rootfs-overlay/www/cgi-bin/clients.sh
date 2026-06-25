#!/bin/sh
echo "Content-Type: application/json"
echo "Cache-Control: no-cache"
echo ""

iw dev wlan0 station dump | awk '
BEGIN {
    printf "[";
    first = 1;
}
/^Station/ {
    if (!first) printf "},";
    else first = 0;
    printf "{\"mac\":\"%s\"", $2;
}
/signal:/ && !/signal avg/ {
    printf ",\"signal_dbm\":%d", $2;
}
/rx bytes:/ {
    printf ",\"rx_bytes\":%d", $3;
}
/tx bytes:/ {
    printf ",\"tx_bytes\":%d", $3;
}
/connected time:/ {
    printf ",\"connected_sec\":%d", $3;
}
END {
    if (!first) printf "}";
    printf "]";
}
'
