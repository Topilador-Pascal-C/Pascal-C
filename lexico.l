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
char *curfilename;

static unsigned symhash(char * sym) {
	unsigned int hash = 0;
	unsigned c;

	while (c =  * sym++) {
		hash = hash * 9 ^ c;
	}
	return hash;
}

struct symbol * lookup(char * sym) {
	struct symbol * sp  = &symtab[symhash(sym)%NHASH];
	int scount = NHASH;

	while(--scount >= 0){
		if(sp->name && strcmp(sp->name, sym )){
			return sp;
		}
		if(!sp->name){
			sp->name = strdup(sym);
			sp->reflist = 0;
			return sp;
		}
		if(++sp >= symtab+NHASH){
			sp = symtab;
		}
	}
	fputs("symbol table overflow\n", stderr);
	abort();
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


{digits} return T_ANY_DIGIT;


{strings} {
	addref(yylineno, curfilename, yytext, 0);
	; yylval.id = (char *) strdup(yytext);
	return T_ANY_STRING;
}

{any_char} {
	printf("Unexpected character in input: '%c' (ASCII=%d)\n", yytext[0], yytext[0]);
}

%%

main (int argc, char ** argv) {
	int i;

	if (argc < 2) {
		curfilename = "(stdin)";
		yylineno = 1;
		yylex();
	} else {
		for (i = 1; i < argc; i++) {
			FILE * f = fopen(argv[i], "r");

			if (!f) {
				perror(argv[1]);
				return (1);
			} else {
				curfilename = argv[i];

				yyrestart(f);
				yylineno = 1;
				yylex();
				fclose(f);
			}

		}

		printrefs();
	}
}
