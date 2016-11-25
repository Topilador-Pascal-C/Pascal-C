#ifndef SYMBOLTABLE_H
#define SYMBOLTABLE_H
#include "global.h"

#define SIZE_TABLE 9997

/* struct of symbol table */
typedef struct symbol {
	char * name;
	char * type;
	struct reference * reflist;
} symbol;

/* struct of contents of symbol table */
typedef struct reference {
	char * value;
	char * filename;
	int line;
	struct reference * next;
} reference;

/* simple symtab of fixed size */
symbol symbol_table[SIZE_TABLE];

/* Name of current input file */
char * curfilename;
int size_of_table;

/* Function to lookup a string in table symbol */
symbol * searchSymbol(char * word);

/* Function to add new ref in a symbol table */
int addAttribuition(char * variable, type_values * value, int line, char * filename);
int addNewVariable(type_values * all, char * type, int line, char * filename);
void addSymbol(int line, char * filename, char * word);

static int symCompare(const void * xa, const void * xb);

void printSymbolTable();

int printDebugText(int debugValue);

#endif