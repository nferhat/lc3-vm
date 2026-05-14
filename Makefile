.POSIX:
.SUFFIXES:
HARE=hare
HAREFLAGS=

DESTDIR=
PREFIX=/usr/local
BINDIR=$(PREFIX)/bin

HARE_SOURCES != find . -name '*.ha'

build-dir:
	mkdir -p build

all: lc3

lc3: $(HARE_SOURCES) build-dir
	$(HARE) build $(HAREFLAGS) -o build/$@ cmd/lc3/


run: $(HARE_SOURCES) lc3
	./build/lc3

check:
	$(HARE) test $(HAREFLAGS)

clean:
	rm -f lc3

install:
	install -Dm755 lc3 $(DESTDIR)$(BINDIR)/lc3

uninstall:
	rm -f $(DESTDIR)$(BINDIR)/lc3

.PHONY: all check clean install uninstall
