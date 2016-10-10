#include "symTable.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

symbol symtab[NHASH];

/* Hash a symbol */
static unsigned symhash(char * sym) {
	unsigned int hash = 0;
	unsigned c;

	while (c =  * sym++) {
		hash = hash * 9 ^ c;
	}
	return hash;
}

/* Find a symbol or create a new symbol in table */
symbol * lookup(char * sym) {

	symbol * sp  = &symtab[symhash(sym) % NHASH];

	/* How many have we looket at */
	int scount = NHASH;

	while (--scount >= 0) {
		if (sp->name && strcmp(sp->name, sym)) {
			return sp;
		} else {
			// Nothing to do
		}

		/* New symbol */
		if (!sp->name) {
			sp->name = strdup(sym);
			sp->reflist = 0;
			return sp;
		} else {
			// Nothing to do
		}

		/* Try the next entry */
		if (++sp >= symtab+NHASH) {
			sp = symtab;
		}
	}
	fputs("symbol table overflow\n", stderr);
	abort();
}

// Adding new word in the symbol table
void addref(int lineno, char * filename, char * word, int flags) {
	ref * r;
	symbol * sp = lookup(word);

	/* Don't do dups of same line and file */
	if (sp->reflist && sp->reflist->lineno == lineno && sp->reflist->filename == filename) {
		return;
	} else {
		r = malloc(sizeof(ref));
		if (!r) {
			fputs("out of space\n", stderr);
			abort();
		} else {
			r->next = sp->reflist;
			r->filename = filename;
			r->lineno = lineno;
			r->flags = flags;
			sp->reflist = r;
		}
	}
}

/* Aux function for sorting */
static int symcompare(const void * xa, const void * xb) {
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
void printrefs() {
	symbol * sp;

	/* Sort the symbol table in alfabethic order */
	qsort(symtab, NHASH, sizeof(symbol), symcompare);

	for (sp = symtab; sp->name && sp < symtab+NHASH; sp++) {
		char * prevfn = NULL;

		/* Revert the list of references */
		ref * rp = sp->reflist;
		ref * rpp = 0;
		ref * rpn;
		do {
			rpn = rp->next;
			rp->next = rpp;
			rpp = rp;
			rp = rpn;
		} while (rp);

		/* Now print the word and its references */
		printf("%10s", sp->name);
		for (rp = rpp; rp; rp = rp->next) {
			if (rp->filename == prevfn) {
				printf(" %d", rp->lineno);
			} else {
				printf(" %s:%d", rp->filename, rp->lineno);
				prevfn = rp->filename;
			}
		}
		printf("\n");
	}
}
