all: clean
	hg clone http://hg.suckless.org/dwm
	patch -p1 -d dwm < dwm_selbar.patch
	make -C dwm

install: clean all
	install dwm/dwm ~/bin/

clean:
	rm -rf dwm

.PHONY: all install clean
