CFLAGS=-g
BISON=bison
FLEX=flex
RM=rm
 
topilador: sintatico.o lexico.o
	$(CC) -o topilador lexico.o sintatico.o
 
sintatico.c: sintatico.y
	$(BISON) -d -o sintatico.c sintatico.y
 
lexico.c: lexico.l
	$(FLEX) -o lexico.c lexico.l
 
clean:
	$(RM) -f lexico.c lexico.o sintatico.c sintatico.o sintatico.h topilador
