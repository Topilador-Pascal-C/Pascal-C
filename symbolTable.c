#include "symbolTable.h"
#include "auxFunctions.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>


symbol * searchIdentifier(char * identifier) {

	symbol * sp  = NULL;
	int i;

	for (i = 0; i < size_of_table; i++) {
		if (strcmp(symbol_table[i].name, identifier) == 0) {
			sp = &symbol_table[i];
			break;
		}
	}
	return sp;
}

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

int addNewVariable(type_values * all, char * type, int line, char * filename) {
	reference * r;
	symbol * sp = searchSymbol(all->value);

	int return_validate = 0;

	/* Don't do dups of same line and file */
	if (sp->reflist) {
		return_validate = 0;
	} else {
		sp->type = convertTypeStringToTypeInt(type);
		r = malloc(sizeof(reference));
		if (!r) {
			fputs("out of space\n", stderr);
			abort();
		} else {
			r->value = NULL;
			r->next = sp->reflist;
			r->filename = filename;
			r->line = line;
			sp->reflist = r;
		}
		return_validate = 1;

	}

	return return_validate;
}

int addAttribuition(char * variable, type_values * new_value, int line, char * filename) {
	reference * r;
	symbol * sp = searchIdentifier(variable);

	int return_validate = 0;

	/* Don't do dups of same line and file */
	if (sp->reflist == NULL) {
		return_validate = 0;
	} else {
		r = malloc(sizeof(reference));
		if (!r) {
			fputs("out of space\n", stderr);
			abort();
		} else {

			r->value = new_value;
			r->next = sp->reflist;
			r->filename = filename;
			r->line = line;
			sp->reflist = r;
		}

		return_validate = 1;
	}

	return return_validate;
}

void printSymbolTable() {
	char * prevfn = NULL;

	qsort(symbol_table, SIZE_TABLE, sizeof(symbol), symCompare);

	for (int i = 0; i < size_of_table; i++) {
		prevfn = NULL;

		reference * ref = symbol_table[i].reflist;

		/* Now print the word and its references */
		printf("%20s:%-20s", symbol_table[i].name, convertTypeIntToTypeString(symbol_table[i].type));
		while(ref != NULL) {
			if (ref->filename == prevfn) {
				printf(", %d", ref->line);
			} else {
				printf(" %s:%d", ref->filename, ref->line);
				prevfn = ref->filename;
			}
			if (ref->value != NULL) {
				printf(":");
				printTypeValues1(ref->value);
			}
			ref = ref->next;
		}
		printf("\n");
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

int printDebugText(int debugValue) {
	printf("Debug %d \n", debugValue);
	return debugValue + 1;
}