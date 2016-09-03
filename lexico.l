%{
#include "global.h"
#include "sintatico.h"
}%

/* DEFINITIONS */
strings [a-z][a-z0-9]*
withespace [ \n\r\t]+
digits [0-9]+
any_char .

%%
/* RULES */

{whitespace} /* Ignore */ ;

/* conditions tokens */
"if" return T_IF_STATEMENT;
"then" return T_IF_THEN_STATEMENT;

/* other tokens */
{strings} return T_ANY_STRING;
{digits} return T_ANY_DIGIT;

{any_char} {
	printf("Unexpected character in input: '%c' (ASCII=%d)\n", yytext[0], yytext[0]);
}

%%