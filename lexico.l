%{
#include <string.h> /* for strdup */
#include "global.h"
#include "sintatico.h"
%}

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
	yylval.id = (char *) strdup(yytext);
	return T_ANY_STRING; 
}

{any_char} {
	printf("Unexpected character in input: '%c' (ASCII=%d)\n", yytext[0], yytext[0]);
}

%%