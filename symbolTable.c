#include "symbolTable.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>


/* Find a symbol or create a new symbol in table */
symbol * searchSymbol(char * word) {

	symbol * sp  = NULL;
	int i;

	for (i = 0; i < size_of_table; i++) {
		if (strcmp(symbol_table[i].name, word) == 0) {
			return &symbol_table[i];
		}
	}

	if (size_of_table < SIZE_TABLE) {
		symbol_table[size_of_table].name = strdup(word);
		symbol_table[size_of_table].reflist = NULL;

		return &symbol_table[size_of_table++];
	} else {
		fputs("Symbol table overflow\n", stderr);
		abort();
	}
	
}

int addNewVariable(char * name, char * type, int line, char * filename) {
	reference * r;
	symbol * sp = searchSymbol(name);

	int return_validate = 0;

	/* Don't do dups of same line and file */
	if (sp->reflist) {
		return_validate = 0;
	} else {
		sp->type = strdup(type);
		r = malloc(sizeof(reference));
		if (!r) {
			fputs("out of space\n", stderr);
			abort();
		} else {
			r->value = "";
			r->next = sp->reflist;
			r->filename = filename;
			r->line = line;
			sp->reflist = r;
		}
		return_validate = 1;
	}

	return return_validate;
}

int addAttribuition(char * variable, char * value, int line, char * filename) {
	reference * r;
	symbol * sp = searchSymbol(variable);

	int return_validate = 0;

	/* Don't do dups of same line and file */
	if (sp->reflist && sp->reflist->line == line && sp->reflist->filename == filename) {
		return_validate = 0;
	} else {
		r = malloc(sizeof(reference));
		if (!r) {
			fputs("out of space\n", stderr);
			abort();
		} else {
			r->value = strdup(value);
			r->next = sp->reflist;
			r->filename = filename;
			r->line = line;
			sp->reflist = r;
		}

		return_validate = 1;
	}

	return return_validate;
}


// Adding new word in the symbol table
void addSymbol(int line, char * filename, char * word) {
	reference * r;
	symbol * sp = searchSymbol(word);

	/* Don't do dups of same line and file */
	if (sp->reflist && sp->reflist->line == line && sp->reflist->filename == filename) {
		return;
	} else {
		r = malloc(sizeof(reference));
		if (!r) {
			fputs("out of space\n", stderr);
			abort();
		} else {
			r->next = sp->reflist;
			r->filename = filename;
			r->line = line;
			sp->reflist = r;
		}
	}
}

/* Aux function for sorting */
static int symCompare(const void * xa, const void * xb) {
	const symbol * a = xa;
	const symbol * b = xb;

	if (!a->name) {
		if (!b->name) {
			/* Both empty */
			return 0;
		} else {
			/* Put the empties at the end */
			return 1;
		}
	} else {
		if (!b->name) {
			return -1;
		} else {
			return strcmp(a->name, b->name);
		}
	}
}

/* Print the identifiers of the list tree */
void printSymbolTable() {
	symbol * sp;
	int i;

	/* Sort the symbol table in alfabethic order */
	qsort(symbol_table, SIZE_TABLE, sizeof(symbol), symCompare);

	for (i = 0; i < size_of_table; i++) {
		char * prevfn = NULL;

		/* Revert the list of references */
		reference * rp = symbol_table[i].reflist;

		/* Now print the word and its references */
		printf("%20s:%-20s", symbol_table[i].name, symbol_table[i].type);
		while(rp != NULL) {
			if (rp->filename == prevfn) {
				printf(", %d", rp->line);
			} else {
				printf(" %s:%d", rp->filename, rp->line);
				prevfn = rp->filename;
			}
			if (strcmp(rp->value, "") != 0) {
				printf(":%s", rp->value);
			}
			rp = rp->next;
		}
		printf("\n");
	}
}

int printDebugText(int debugValue) {
	printf("Debug %d \n", debugValue);
	return debugValue + 1;
}