CFLAGS=-g
BISON=bison
FLEX=flex
RM=rm
DEL_FILE= sintatico.tab.c sintatico.tab.h lex.yy.c topilador symbolTable.o sintatico.tab.o teste.c

all: sintatico.tab.c lex.yy.c symbolTable.o
	$(CC) -o topilador lex.yy.c sintatico.tab.c symbolTable.o -lfl

	@echo "\nPara executar: ./topilador <file.pas> ..."

sintatico.tab.c: sintatico.y
	$(BISON) -d sintatico.y

lex.yy.c: lexico.l
	$(FLEX) lexico.l

symbolTable.o: symbolTable.c symbolTable.h
	gcc -c symbolTable.c -o symbolTable.o

clean:
	$(RM) -f $(DEL_FILE)
