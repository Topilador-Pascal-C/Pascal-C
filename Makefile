CFLAGS=-g
BISON=bison
FLEX=flex
RM=rm
DEL_FILE= sintatico.tab.c sintatico.tab.h lex.yy.c topilador symTable.o sintatico.tab.o

all: sintatico.tab.c lex.yy.c symTable.o
	$(CC) -o topilador lex.yy.c sintatico.tab.c symTable.o -lfl

	@echo "\nPara executar: ./topilador <file.pas> ..."

sintatico.tab.c: sintatico.y
	$(BISON) -d sintatico.y

lex.yy.c: lexico.l
	$(FLEX) lexico.l

symTable.o: symTable.c symTable.h
	gcc -c symTable.c -o symTable.o

clean:
	$(RM) -f $(DEL_FILE)
