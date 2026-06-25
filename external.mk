define BBG_FAST_BOOT_COPY_FW
	mkdir -p $(LINUX_DIR)/firmware/ti-connectivity
	cp /lib/firmware/regulatory.db $(LINUX_DIR)/firmware/
	cp /lib/firmware/regulatory.db.p7s $(LINUX_DIR)/firmware/
	cp $(BR2_EXTERNAL_BBG_FAST_BOOT_PATH)/wl18xx-conf.bin \
		$(LINUX_DIR)/firmware/ti-connectivity/
endef
LINUX_PRE_BUILD_HOOKS += BBG_FAST_BOOT_COPY_FW
