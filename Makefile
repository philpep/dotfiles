all:
	./install.sh

dzen2:
	make -C dzen2 install

dwm: dzen2
	make -C dwm install

.PHONY: dwm dzen2
