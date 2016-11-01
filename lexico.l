%{
#include <string.h> /* for strdup */
#include "global.h"
#include "sintatico.tab.h"

%}

%option noyywrap nodefault yylineno

/* DEFINITIONS */
word [a-zA-Z_][a-zA-Z_]*
variables {word}[0-9]+
text {word}[[ ]+{word}]+
withespace [ \r\t]+
digits [0-9]+

some_char .

%% /* RULES */

{withespace} /* Ignore */ ;

"program" {return T_PROGRAM;}
"begin" {return T_BEGIN_PROGRAM;}
"end." {return T_END_PROGRAM;}

"\n" {return T_END_LINE;}
":=" {return T_ATTRIBUTION;}
";" {return T_SEMICOLON;}
":" {return T_COLON;}
"\"" {return T_QUOTATION_MARKS;}
"\'" {return T_APOSTROPHE;}

"var" {return T_VAR_STATEMENT;}
"if" {return T_IF_STATEMENT;}
"then" {return T_IF_THEN_STATEMENT;}
"const" {return T_CONST_STATEMENT;}

"string" {return T_TYPE_STRING;}
"char" {return T_TYPE_CHAR;}
"boolean" {return T_TYPE_BOOLEAN;}
"byte" {return T_TYPE_BYTE;}
"integer" {return T_TYPE_INTEGER;}
"shortint" {return T_TYPE_SHORTINT;}
"smallint" {return T_TYPE_SMALLINT;}
"word" {return T_TYPE_WORD;}
"cardinal" {return T_TYPE_CARDINAL;}
"longint" {return T_TYPE_LONGINT;}
"longword" {return T_TYPE_LONGWORD;}
"int64" {return T_TYPE_INT64;}
"qword" {return T_TYPE_QWORD;}
"real" {return T_TYPE_REAL;}
"double" {return T_TYPE_DOUBLE;}
"single" {return T_TYPE_SINGLE;}
"comp" {return T_TYPE_COMP;}
"currency" {return T_TYPE_CURRENCY;}
"extended" {return T_TYPE_EXTENDED;}

"=" {return T_EQUAL;}
"<>" {return T_DIFFERENT;}
">" {return T_BIGGER;}
">=" {return T_BIGGER_OR_EQUAL;}
"<" {return T_MINOR;}
"<=" {return T_MINOR_OR_EQUAL;}

{text} {
	yylval.strval = malloc(sizeof(strlen(yytext)));
	strcpy(yylval.strval, yytext);
	return T_SOME_TEXT;
}

{variables} {
	yylval.strval = malloc(sizeof(strlen(yytext)));
	strcpy(yylval.strval, yytext);
	return T_SOME_VARIABLES;
}

{word} {
	yylval.strval = malloc(sizeof(strlen(yytext)));
	strcpy(yylval.strval, yytext);
	return T_SOME_WORD;
}

{digits} return T_SOME_DIGIT;

{some_char} {
	printf("%s:%d: Mystery character '%s'\n", curfilename, yylineno, yytext);
}
