include config.mk

SRC = Drw.c IQWM.c Util.c
OBJ = ${SRC:.c=.o}

all: options IQWM

options:
	@echo IQWM build options:
	@echo "CFLAGS   = ${CFLAGS}"
	@echo "LDFLAGS  = ${LDFLAGS}"
	@echo "CC       = ${CC}"

.c.o:
	${CC} -c ${CFLAGS} $<

${OBJ}: Config.h config.mk

IQWM: ${OBJ}
	${CC} -o $@ ${OBJ} ${LDFLAGS}

clean:
	rm -f IQWM ${OBJ} IQWM-${VERSION}.tar.gz *.orig *.rej

dist: clean
	mkdir -p IQWM-${VERSION}
	cp -R Makefile config.mk\
		IQWM.1 Drw.h Util.h ${SRC} Transient.c IQWM-${VERSION}
	tar -cf IQWM-${VERSION}.tar IQWM-${VERSION}
	gzip IQWM-${VERSION}.tar
	rm -rf IQWM-${VERSION}

install: all
	mkdir -p ${DESTDIR}${PREFIX}/bin
	cp -f IQWM ${DESTDIR}${PREFIX}/bin
	chmod 755 ${DESTDIR}${PREFIX}/bin/IQWM
	mkdir -p ${DESTDIR}${MANPREFIX}/man1
	sed "s/VERSION/${VERSION}/g" < IQWM.1 > ${DESTDIR}${MANPREFIX}/man1/IQWM.1
	chmod 644 ${DESTDIR}${MANPREFIX}/man1/IQWM.1
	mkdir -p ${DESTDIR}${PREFIX}/share/IQWM
	cp -f IQScript.mom ${DESTDIR}${PREFIX}/share/IQWM
	chmod 644 ${DESTDIR}${PREFIX}/share/IQWM/IQScript.mom

uninstall:
	rm -f ${DESTDIR}${PREFIX}/bin/IQWM\
		${DESTDIR}${PREFIX}/share/IQWM/IQScript.mom\
		${DESTDIR}${MANPREFIX}/man1/IQWM.1

.PHONY: all options clean dist install uninstall
