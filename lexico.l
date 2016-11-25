%{
#include <string.h> /* for strdup */
#include "global.h"
#include "sintatico.tab.h"

%}

%option noyywrap nodefault yylineno

/* DEFINITIONS */
word [a-zA-Z_0-9][a-zA-Z_0-9]*
text {word}(" "{word})+
slash \/
one_line_comment {slash}{slash}[ ]*{word}+{text}*
open_brace \{
close_brace \}
asterisk \*
brace_asterisk_comment {open_brace}{asterisk}*[ ]*{word}+{text}*[ ]*{asterisk}*{close_brace}
withespace [ \r\t\n]+
digits [0-9]+
real {digits}("."{digits})
apostrophe "\'"
quotation_marks "\""

some_char .

%% /* RULES */

{withespace} /* Ignore */ ;

"program" {return T_PROGRAM;}
"begin" {return T_BEGIN_STATEMENT;}
"end." {return T_END_PROGRAM;}
"end" {return T_END_STATEMENT;}

":=" {return T_ATTRIBUTION;}
";" {return T_SEMICOLON;}
":" {return T_COLON;}

"=" {return T_EQUAL;}
"<>" {return T_DIFFERENT;}
">" {return T_BIGGER;}
">=" {return T_BIGGER_OR_EQUAL;}
"<" {return T_MINOR;}
"<=" {return T_MINOR_OR_EQUAL;}

"(" {return T_LEFT_PARENTHESIS;}
")" {return T_RIGHT_PARENTHESIS;}

"var" {return T_VAR_STATEMENT;}
"if" {return T_IF_STATEMENT;}
"then" {return T_IF_THEN_STATEMENT;}
"while" {return T_WHILE_STATEMENT;}
"do" {return T_DO_STATEMENT;}
"const" {return T_CONST_STATEMENT;}
"and" {return T_AND_STATEMENT;}
"or" {return T_OR_STATEMENT;}
"for" return(T_FOR_STATEMENT);
"to" return(T_TO_STATEMENT);
"downto" return(T_DOWNTO_STATEMENT);
"repeat" return(T_REPEAT_STATEMENT);
"until" return(T_UNTIL_STATEMENT);

"write" {return T_WRITE;}
"writeln" {return T_WRITELN;}
"read" {return T_READ;}
"readln" {return T_READLN;}

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

{apostrophe} {return T_APOSTROPHE;}

{quotation_marks} {return T_QUOTATION_MARKS;}

{digits} {
	yylval.all = (type_values*) malloc(sizeof(type_values));
	yylval.all->type = TYPE_INT;

	int * value = malloc(sizeof(int));
	* value = atoi(yytext);
	yylval.all->value = (int*) value;

	return T_INT_NUMBER;
}

{real} {
	yylval.all = (type_values*) malloc(sizeof(type_values));
	yylval.all->type = TYPE_DOUBLE;

	double * value = malloc(sizeof(double));
	* value = atof(yytext);
	yylval.all->value = (double*) value;

	return T_DOUBLE_NUMBER;
}

{one_line_comment} {
	yylval.all = (type_values*) malloc(sizeof(type_values));
	yylval.all->type = TYPE_STRING;

	yylval.all->value = malloc(sizeof(strlen(yytext)));
	strcpy(yylval.all->value, yytext);

	return T_SLASH_COMMENT;
}

{brace_asterisk_comment} {
	yylval.all = (type_values*) malloc(sizeof(type_values));
	yylval.all->type = TYPE_STRING;
	
	yytext = yytext + 1;
	yylval.all->value = malloc(sizeof(strlen(yytext) - 1));
	strncpy(yylval.all->value, yytext, strlen(yytext) - 1);

	return T_BRACE_COMMENT;
}

{apostrophe}{text}{apostrophe} {
	yylval.all = (type_values*) malloc(sizeof(type_values));
	yylval.all->type = TYPE_STRING;
	
	yytext = yytext + 1;
	yylval.all->value = malloc(sizeof(strlen(yytext) - 1));
	strncpy(yylval.all->value, yytext, strlen(yytext) - 1);

	return T_SOME_TEXT;
}

{word} {
	yylval.all = (type_values*) malloc(sizeof(type_values));
	yylval.all->type = TYPE_STRING;

	yylval.all->value = malloc(sizeof(strlen(yytext)));
	strcpy(yylval.all->value, yytext);
	
	return T_SOME_WORD;
}

{some_char} {
	printf("%s:%d: Mystery character '%s'\n", curfilename, yylineno, yytext);
}
