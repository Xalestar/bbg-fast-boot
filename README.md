# BBG Wireless Fast Boot

Buildroot external tree (`BR2_EXTERNAL`) for BeagleBone Green Wireless.
Boots to AP-ENABLED in **4.05 seconds** from power-on.

## Environment

- Host: Ubuntu 24.04 LTS
- Buildroot: 2026.02.1
- Linux kernel: 7.0.5
- Target: BeagleBone Green Wireless (AM335x, Cortex-A8)

## Project Structure

```
├── board/bbg/
│   ├── linux.config            # Trimmed kernel config
│   ├── uboot.config            # U-Boot config
│   ├── busybox.config          # BusyBox config
│   ├── busybox-minimal.config  # BusyBox minimal config
│   ├── cleanup-init.sh         # Post-build cleanup script
│   ├── patches/linux/
│   │   └── 0001-disable-emmc.patch
│   └── rootfs-overlay/
│       ├── etc/
│       │   ├── init.d/S00ap        # Init script: AP → dnsmasq → eth0
│       │   ├── hostapd.conf
│       │   ├── dnsmasq-ap.conf
│       │   ├── nftables.conf
│       │   └── wpa_supplicant.conf
│       └── www/                    # Web dashboard (served by httpd)
├── configs/
│   └── bbg_fast_boot_defconfig # Buildroot defconfig
├── Config.in
├── external.desc
├── external.mk
└── wl18xx-conf.bin             # TI WiLink8 firmware config
```

## Reproducing the Build

```bash
# 1. Clone Buildroot 2026.02.1
git clone --branch 2026.02.1 https://github.com/buildroot/buildroot.git
cd buildroot

# 2. Load defconfig with external tree
make BR2_EXTERNAL=/path/to/bbg-fast-boot bbg_fast_boot_defconfig

# 3. Build
make
```

The kernel config (`linux.config`) bakes Wi-Fi firmware into the kernel image
via `EXTRA_FIRMWARE` to avoid userspace firmware loading at runtime:

```
CONFIG_EXTRA_FIRMWARE="regulatory.db regulatory.db.p7s ti-connectivity/wl18xx-conf.bin"
CONFIG_EXTRA_FIRMWARE_DIR="firmware"
```

`external.mk` defines a `LINUX_PRE_BUILD_HOOKS` that copies all firmware blobs
into `$(LINUX_DIR)/firmware/` before the kernel build: `regulatory.db` and
`regulatory.db.p7s` from the host's `/lib/firmware/`, `wl18xx-conf.bin` from
this external tree. The host must have the `wireless-regdb` package installed.

## Boot Sequence

`S00ap` is the only init script (all others are removed by `cleanup-init.sh`):

1. Wait for `wlan0` (up to 3s)
2. Start `hostapd` on `192.168.50.1/24`
3. Wait for AP-ENABLED (up to 8s)
4. Background deferred services: `dnsmasq`, `httpd`, `eth0` DHCP, `nftables`

`eth0` is deferred because it shares the musb USB controller with `wl18xx`
and would compete for bus bandwidth during wlcore firmware load.

## Status

Working. BusyBox init with `S00ap` brings up AP and web dashboard automatically on boot.
