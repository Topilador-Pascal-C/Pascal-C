#ifndef SYMBOLTABLE_H
#define SYMBOLTABLE_H

#define SIZE_TABLE 9997

/* struct of symbol table */
typedef struct symbol {
	char * name;
	struct reference * reflist;
} symbol;

/* struct of contents of symbol table */
typedef struct reference {
	char * filename;
	int line;
	struct reference * next;
} reference;

/* Function to lookup a string in table symbol */
symbol * searchSymbol(char * word);

/* simple symtab of fixed size */
symbol symbol_table[SIZE_TABLE];

/* Name of current input file */
char * curfilename;
int size_of_table;

/* Function to add new ref in a symbol table */
void addSymbol(int line, char * filename, char * word);

static int symCompare(const void * xa, const void * xb);

void printSymbolTable();

int printDebugText(int debugValue);

#endif