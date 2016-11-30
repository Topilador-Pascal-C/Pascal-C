CFLAGS=-g
BISON=bison
FLEX=flex
RM=rm
DEL_FILE= sintatico.tab.c sintatico.tab.h lex.yy.c topilador symbolTable.o auxFunctions.o validations.o sintatico.tab.o *.cpp

all: sintatico.tab.c lex.yy.c symbolTable.o auxFunctions.o validations.o
	$(CC) -o topilador lex.yy.c sintatico.tab.c symbolTable.o auxFunctions.o validations.o -lfl

	@echo "\nPara executar: ./topilador <file.pas> ..."

sintatico.tab.c: sintatico.y
	$(BISON) -d sintatico.y

lex.yy.c: lexico.l
	$(FLEX) lexico.l

symbolTable.o: symbolTable.c symbolTable.h
	gcc -c symbolTable.c -o symbolTable.o

auxFunctions.o: auxFunctions.c auxFunctions.h
	gcc -c auxFunctions.c -o auxFunctions.o

validations.o: validations.c validations.h
	gcc -c validations.c -o validations.o

clean:
	$(RM) -f $(DEL_FILE)
