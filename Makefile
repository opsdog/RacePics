#
#  Makefile for the Racepics program suite
#

CC= gcc

CFLAGS= -fno-common
INCLUDEDIRS= -I/usr/local/mysql/include
LINKOPTS= -L/usr/local/mysql/lib
LIBS= -lmysqlclient -lz -lm

.c.o:
	$(CC) -c ${CFLAGS} ${COPTS} ${INCLUDEDIRS} $<

Targets= ImageByDateBySection ImageByHuman Human VehicleNum Query \
	NewQuery URLEncode EscapeSpace CSVQuery SVSQuery SVCQuery

all: ${Targets}

ImageByDateBySection:  ImageByDateBySection.o
	$(CC) -o ImageByDateBySection ImageByDateBySection.o ${LINKOPTS} ${LIBS}
	chmod 0755 ImageByDateBySection && echo " "

ImageByHuman:  ImageByHuman.o
	$(CC) -o ImageByHuman ImageByHuman.o ${LINKOPTS} ${LIBS}
	chmod 0755 ImageByHuman && echo " "

Human:  Human.o RemoveSpaces.o
	$(CC) -o Human Human.o RemoveSpaces.o ${LINKOPTS} ${LIBS}
	chmod 0755 Human && echo " "

Query:  Query.o /tmp/DBvip
	$(CC) -o Query Query.o ${LINKOPTS} ${LIBS}
	chmod 0755 Query 
	cp -p Query ~/bin && echo " "

NewQuery:  NewQuery.o /tmp/DBvip
	$(CC) -o NewQuery NewQuery.o ${LINKOPTS} ${LIBS}
	chmod 0755 NewQuery
	cp -p NewQuery ~/bin  && echo " "

SVSQuery:  SVSQuery.o /tmp/DBvip
	$(CC) -o SVSQuery SVSQuery.o ${LINKOPTS} ${LIBS}
	chmod 0755 SVSQuery
	cp -p SVSQuery ~/bin  && echo " "

SVCQuery:  SVCQuery.o /tmp/DBvip
	$(CC) -o SVCQuery SVCQuery.o ${LINKOPTS} ${LIBS}
	chmod 0755 SVCQuery
	cp -p SVCQuery ~/bin  && echo " "

CSVQuery:  CSVQuery.o /tmp/DBvip
	$(CC) -o CSVQuery CSVQuery.o ${LINKOPTS} ${LIBS}
	chmod 0755 CSVQuery
	cp -p CSVQuery ~/bin  && echo " "

VehicleNum:  VehicleNum.o RemoveSpaces.o
	$(CC) -o VehicleNum VehicleNum.o RemoveSpaces.o ${LINKOPTS} ${LIBS}
	chmod 0755 VehicleNum && echo " "

URLEncode: URLEncode.o
	$(CC) -o URLEncode URLEncode.o
	chmod 0755 URLEncode && echo " "

EscapeSpace: EscapeSpace.o
	$(CC) -o EscapeSpace EscapeSpace.o
	chmod 0755 EscapeSpace && echo " "

clean:
	/bin/rm -f *.o *~ core
	/bin/rm -f ${Targets}
	/bin/rm -f Human.[0-9]* VehicleNum.[0-9]*
	/bin/rm -f Section-*
	/bin/rm -f tmp_*
	/bin/rm -f dougee.?  && echo 

backup: clean
	rm -f  ../RacePics.tar.gz
	tar cf ../RacePics.tar *.c *.ksh CreateDB CreatePHTML* Makefile *.css
	gzip   ../RacePics.tar  && echo

#
#  depend relationships
#

ImageByDateBySection.o: ImageByDateBySection.c
ImageByHuman.o: ImageByHuman.c
Human.o: Human.c
VehicleNum.o: VehicleNum.c
Query.o: Query.c
RemoveSpaces.o: RemoveSpaces.c
URLEncode.o: URLEncode.c
EscapeSpace.o: EscapeSpace.c
NewQuery.o: NewQuery.c /tmp/DBvip
SVSQuery.o: SVSQuery.c /tmp/DBvip
SVCQuery.o: SVCQuery.c /tmp/DBvip
CSVQuery.o: CSVQuery.c /tmp/DBvip
Query.o: Query.c /tmp/DBvip
