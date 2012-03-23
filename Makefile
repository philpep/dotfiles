all:
	./install.sh

dzen2:
	make -C dzen2

dwm: dzen2
	make -C dwm
