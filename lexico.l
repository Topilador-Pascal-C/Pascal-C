%{
#include <string.h> /* for strdup */
#include "global.h"
#include "sintatico.tab.h"
#include "symTable.h"


/* Name of current input file */
char * curfilename;

/* Defining the symbol table */
symbol symtab[NHASH];

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
