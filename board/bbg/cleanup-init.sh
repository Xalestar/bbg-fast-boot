#!/bin/sh
# Buildroot automatically passes the current target directory path as the first argument ($1)
TARGET_DIR="$1"
INIT_D="${TARGET_DIR}/etc/init.d"

if [ -z "${TARGET_DIR}" ] || [ ! -d "${INIT_D}" ]; then
    echo "Error: invalid target directory '${TARGET_DIR}'" >&2
    exit 1
fi

echo "=== Running custom boot script cleanup ==="
# Option A: completely delete the unused files
rm -f "${INIT_D}/S01seedrng"
rm -f "${INIT_D}/S01syslogd"
rm -f "${INIT_D}/S02sysctl"
rm -f "${INIT_D}/S02klogd"
rm -f "${INIT_D}/S11modules"
rm -f "${INIT_D}/S35nftables"
rm -f "${INIT_D}/S40network"
rm -f "${INIT_D}/S50crond"
rm -f "${INIT_D}/S50dropbear"
rm -f "${INIT_D}/S80dnsmasq"
# Option B: if you want to keep the files but just disable them (strip the S prefix)
# mv "${INIT_D}/S01seedrng" "${INIT_D}/01seedrng" 2>/dev/null
echo "=== Cleanup complete ==="
