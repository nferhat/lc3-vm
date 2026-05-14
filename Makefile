.POSIX:
.SUFFIXES:
HARE=hare
HAREFLAGS=

DESTDIR=
PREFIX=/usr/local
BINDIR=$(PREFIX)/bin

HARE_SOURCES != find . -name '*.ha'

all: lc3

lc3: $(HARE_SOURCES)
	$(HARE) build $(HAREFLAGS) -o $@ cmd/lc3/


run: $(HARE_SOURCES)
	$(HARE) run $(HAREFLAGS) cmd/lc3 $(ARGS)

check:
	$(HARE) test $(HAREFLAGS)

clean:
	rm -f lc3

install:
	install -Dm755 lc3 $(DESTDIR)$(BINDIR)/lc3

uninstall:
	rm -f $(DESTDIR)$(BINDIR)/lc3

.PHONY: all check clean install uninstall
