include config.mk

SRC = Drw.c IQ-WM.c Util.c
OBJ = ${SRC:.c=.o}

all: options IQ-WM

options:
	@echo IQ-WM build options:
	@echo "CFLAGS   = ${CFLAGS}"
	@echo "LDFLAGS  = ${LDFLAGS}"
	@echo "CC       = ${CC}"

.c.o:
	${CC} -c ${CFLAGS} $<

${OBJ}: Config.h config.mk

IQ-WM: ${OBJ}
	${CC} -o $@ ${OBJ} ${LDFLAGS}

clean:
	rm -f IQ-WM ${OBJ} IQ-WM-${VERSION}.tar.gz *.orig *.rej

dist: clean
	mkdir -p IQ-WM-${VERSION}
	cp -R Makefile config.mk\
		IQ-WM.1 Drw.h Util.h ${SRC} Transient.c IQ-WM-${VERSION}
	tar -cf IQ-WM-${VERSION}.tar IQ-WM-${VERSION}
	gzip IQ-WM-${VERSION}.tar
	rm -rf IQ-WM-${VERSION}

install: all
	mkdir -p ${DESTDIR}${PREFIX}/bin
	cp -f IQ-WM ${DESTDIR}${PREFIX}/bin
	chmod 755 ${DESTDIR}${PREFIX}/bin/IQ-WM
	mkdir -p ${DESTDIR}${MANPREFIX}/man1
	sed "s/VERSION/${VERSION}/g" < IQ-WM.1 > ${DESTDIR}${MANPREFIX}/man1/IQ-WM.1
	chmod 644 ${DESTDIR}${MANPREFIX}/man1/IQ-WM.1
	mkdir -p ${DESTDIR}${PREFIX}/share/IQ-WM
	cp -f IQ-IS.mom ${DESTDIR}${PREFIX}/share/IQ-WM
	chmod 644 ${DESTDIR}${PREFIX}/share/IQ-WM/IQ-IS.mom

uninstall:
	rm -f ${DESTDIR}${PREFIX}/bin/IQ-WM\
		${DESTDIR}${PREFIX}/share/IQ-WM/IQ-IS.mom\
		${DESTDIR}${MANPREFIX}/man1/IQ-WM.1

.PHONY: all options clean dist install uninstall
