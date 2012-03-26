all: clean
	git clone https://github.com/dylex/dzen.git
	patch -p0 < config__mk.patch
	make -C dzen

install: clean all
	install dzen/dzen2 ~/bin/

clean:
	rm -rf dzen

.PHONY: all install clean
