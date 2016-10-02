CC = cc
CFLAGS = -I/
BISON = bison
FLEX = flex
RM = rm -f
ARQ_DEL = lex.yy.c sintatico.tab.c sintatico.tab.h symTable.o topilador
TARGET = topilador
 
$(TARGET): sintatico.tab.c lex.yy.c symTable.o
	$(CC) -o $(TARGET) symTable.o sintatico.tab.c lex.yy.c -lfl
 
sintatico.tab.c: sintatico.y 
	$(BISON) -d sintatico.y

lex.yy.c: lexico.l
	$(FLEX) -c lexico.l

symTable.o: symTable.c symTable.h
	gcc -o symTable.c
 
clean:
	$(RM) $(ARQ_DEL)
