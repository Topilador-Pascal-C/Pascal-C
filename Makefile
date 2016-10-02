CFLAGS=-g
BISON=bison
FLEX=flex
RM=rm
 
topilador: sintatico.o lexico.o symTable.o
	$(CC) -o topilador lexico.o sintatico.o symTable.o -I/
 
sintatico.o: sintatico.y 
	$(BISON) -d sintatico.y

lexico.o: lexico.l
	$(FLEX) -c lexico.l

symTable.o: symTable.c symTable.h
	$(CC) -c symTable.c -I/
 
clean:
	$(RM) -f lexico.c lexico.o sintatico.c sintatico.o sintatico.h lex.yy.c sintatico.tab.c sintatico.tab.h topilador
