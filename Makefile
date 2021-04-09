DESTDIR=/
INSTALL_PATH=$(DESTDIR)/usr/xiringuito
WRAPPER_PATH=$(DESTDIR)/usr/bin

help:
	@cat INSTALL-HELP.txt

install:
	mkdir -p $(WRAPPER_PATH) || true
	rsync -a ./ $(INSTALL_PATH)/
	install -o root -g `id -g root` -m 0755 wrapper $(WRAPPER_PATH)/xiringuito
	install -o root -g `id -g root` -m 0755 wrapper $(WRAPPER_PATH)/xaval
	sed -i -r "s|__INSTALL_PATH__|$(INSTALL_PATH)|g" $(WRAPPER_PATH)/xiringuito $(WRAPPER_PATH)/xaval

uninstall:
	rm $(WRAPPER_PATH)/xiringuito $(WRAPPER_PATH)/xaval
	rm -r $(INSTALL_PATH)
