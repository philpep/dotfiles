all:
	git clone https://github.com/dylex/dzen.git
	patch -p0 < config__mk.patch
	make -C dzen
	install dzen/dzen2 ~/bin/
