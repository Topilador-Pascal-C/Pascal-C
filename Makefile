CFLAGS=-g
BISON=bison
FLEX=flex
 
topilador: topilador.o topiladorFlex.o
	$(CC) -o topilador topiladorFlex.o topilador.o
 
topilador.c: topilador.y
	$(BISON) -d -o topilador.c topilador.y
 
topiladorFlex.c: topilador.l
	$(FLEX) -o topiladorFlex.c topilador.l
 
clean:
	rm -f topiladorFlex.c topiladorFlex.o topilador.c topilador.o topilador.h topilador
