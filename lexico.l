%{
#include <string.h> /* for strdup */
#include "global.h"
#include "sintatico.h"
#define NHASH 9997

/* struct of symbol table */
typedef struct symbol {
	char * name;
	struct ref * reflist;
} symbol;

/* struct of contents of symbol table */
typedef struct ref {
	struct ref * next;
	char * filename;
	int flags;
	int lineno;
} ref;

/* Defining the symbol table */
symbol symtab[NHASH];

/* Function to lookup a string in table symbol */
symbol * lookup(char *);

/* Function to add new ref in a symbol table */
void addref(int, char *, char *, int);

/* Name of current input file */
char * curfilename;

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

%}

%option noyywrap nodefault yylineno

/* DEFINITIONS */
strings [a-z][a-z0-9]*
withespace [ \n\r\t]+
digits [0-9]+
any_char .

%% /* RULES */

{withespace} /* Ignore */ ;

"if" return T_IF_STATEMENT;
"then" return T_IF_THEN_STATEMENT;

{strings} {
	addref(yylineno, curfilename, yytext, 0);
	return T_ANY_STRING;
}

{digits} return T_ANY_DIGIT;

{any_char} {
	printf("%s:%d: Mystery character '%s'\n", curfilename, yylineno, yytext);
}

%%

int main (int argc, char ** argv) {
	int i;

	if (argc < 2) {
		curfilename = "(stdin)";
		yylineno = 1;

		// Start the analisis lexical
		yylex();
	} else {
		for (i = 1; i < argc; i++) {
			FILE * f = fopen(argv[i], "r");

			// Verified if the file is openned
			if (!f) {
				perror(argv[1]);
				return (1);
			} else {
				curfilename = argv[i];

				yyrestart(f);
				yylineno = 1;

				// Start the analisis lexical
				yylex();
				fclose(f);
			}
		}
	}
	printrefs();
	return 1;
}
