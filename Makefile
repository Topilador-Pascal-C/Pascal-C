CFLAGS=-g
BISON=bison
FLEX=flex
RM=rm
DEL_FILE= sintatico.tab.c sintatico.tab.h lex.yy.c topilador symbolTable.o auxFunctions.o sintatico.tab.o teste.cpp

all: sintatico.tab.c lex.yy.c symbolTable.o auxFunctions.o
	$(CC) -o topilador lex.yy.c sintatico.tab.c symbolTable.o auxFunctions.o -lfl

	@echo "\nPara executar: ./topilador <file.pas> ..."

sintatico.tab.c: sintatico.y
	$(BISON) -d sintatico.y

lex.yy.c: lexico.l
	$(FLEX) lexico.l

symbolTable.o: symbolTable.c symbolTable.h
	gcc -c symbolTable.c -o symbolTable.o

auxFunctions.o: auxFunctions.c auxFunctions.h
	gcc -c auxFunctions.c -o auxFunctions.o

clean:
	$(RM) -f $(DEL_FILE)
