# BBG Wireless Fast Boot
Reduce boot time to AP-ready state on BeagleBone Green Wireless.
## Environment
- Host: Ubuntu 24.04 LTS
- Buildroot: 2026.02.1
- Linux kernel: 7.0.5
- Target: BeagleBone Green Wireless (AM335x, Cortex-A8)
## Files
- `buildroot_defconfig`: Buildroot configuration
- `linux.config`: Linux kernel configuration
- `busybox.config`: Busybox configuration
- `rootfs-overlay/`: Custom files (hostapd.conf, dnsmasq.conf, nftables.conf, www/, etc.)
- `rootfs-overlay/etc/init.d/S99ap`: Boot script that starts AP mode and httpd automatically
## Reproducing the Build
1. Obtain Buildroot 2026.02.1
2. Copy `buildroot_defconfig` to the Buildroot directory as `.config`,
   or place it at `configs/bbg_fastboot_defconfig` and run `make bbg_fastboot_defconfig`
3. Place `linux.config` at the path referenced by BR2_LINUX_KERNEL_CUSTOM_CONFIG_FILE
4. Set BR2_ROOTFS_OVERLAY to point to this repo's rootfs-overlay
5. Run `make`
## Status
Working baseline with BusyBox as init system.
AP mode and httpd start automatically on boot via `rootfs-overlay/etc/init.d/S99ap`.
