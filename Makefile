INSTALL_PATH=/usr/local/xiringuito
WRAPPER_PATH=/usr/local/bin

help:
	@cat INSTALL-HELP.txt

install:
	rsync -a ./ $(INSTALL_PATH)/
	install -o root -g root -m 0755 wrapper $(WRAPPER_PATH)/xiringuito
	install -o root -g root -m 0755 wrapper $(WRAPPER_PATH)/xaval
	sed -i "s|__INSTALL_PATH__|$(INSTALL_PATH)|g" $(WRAPPER_PATH)/xiringuito $(WRAPPER_PATH)/xaval

uninstall:
	rm $(WRAPPER_PATH)/xiringuito $(WRAPPER_PATH)/xaval
	rm -r $(INSTALL_PATH)
