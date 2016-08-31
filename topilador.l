%{
// make include
#include <ctype.h>
#include <stdlib.h>
}%

; definitions
white_espace [ \t]+
digit [0-9]
integer {digit}+
letter[A-Za-z]
exponant [eE][+-]?{integer}
real {integer}("."{integer})?{exponant}?

%%

{white} { /* We ignore white characters */ }
{real} {
	yylval=atof(yytext);
	return(NUMBER);
}

; basic symbol
"+" return(PLUS);
"-" return(MINUS);
"*" return(TIMES);
"/" return(DIVIDE_REAL); real division
"div" return (DIVIDE_INTEGER); integer division
"^" return(POWER);
"(" return(LEFT_PARENTHESIS);
")" return(RIGHT_PARENTHESIS);
":=" return(ATTRIBUTION);
";" return (SEMICOLON);
":" return (COLON);
"," return (COMMA);
"=" return (EQUAL);
"<>" return (DIFFERENT);
">" return (BIGGER);
">=" return (BIGGER_OR_EQUAL);
"<" return (MINOR);
"<=" return (MINOR_OR_EQUAL);
"mod" return (MOD);
"and" return (AND_STATEMENT);
"or" return (OR_STATEMENT);
"xor" return (XOR);
"not" return (NOT);

; basic commands
"program" return (PROGRAM_STATEMENT);
"unit" return (UNIT_STATEMENT);
"uses" return (IMPORT_LIBRARIES);
"begin" return (BEGIN);
"end." return (END_PROGRAM);
"end" return (END);
"var" return (VAR_STATEMENT);
"type" return (NEW_STATEMENT);
"break" return (BREAK);
"const" return (CONST);
"continue" return (CONTINUE);
"implementation" return (IMPLEMENTATION);
"inherited" return (INHERITED);
"inline" return (INLINE);
"interface" return (INTERFACE);
"nil" return (NULL_STATEMENT);
"not" return (NOT);

; file manipulation
"file" return (FILE);
"reset" return (RESET);
"rewrite" return (REWRITE);
"assign" return (ASSIGN);
"close" return (CLOSE);

; variable types
"string" return (STRING_STATEMENT);
"false" return (FALSE);
"true" return (TRUE);
"array" return (ARRAY);
"boolean" return (BOOLEAN);
"char" retrun (CHAR);
"object" return (OBJECT);
"record" return (RECORD);

; ordinal types
"integer" return (INTEGER_STATEMENT);
"byte" return (BYTE);
"shortint" return (SHORTINT);
"smallint" return (SMALLINT);
"word" return (WORD);
"cardinal" return (CARDINAL);
"longint" return (LONGINT);
"longword" return (LONGWORD);
"int64" return (INT64);
"qword" return (QWORD);

; real types
"real" return (REAL);
"double" return (DOUBLE);
"single" return (SINGLE);
"extended" return (EXTENDED);
"comp" return (COMP);
"currency" return (CURRENCY);

; function statement
"function" return (FUNCTION);
"procedure" return (PROCEDURE);
"constructor" return (CONSTRUCTOR);
"destructor" return (DESTRUCTOR);

;  other things
"in" return (IN);
"of" return (OF);
"on" return (ON);
"with" return (WITH);

; conditions
"if" return (IF_STATEMENT);
"then" return (IF_THEN_STATEMENT);
"else" return (ELSE_STATEMENT);
"case" return (SWITCH_CASE);

; io statements
"read" return (READ);
"readln" return (READLN);
"write" return (WRITE);
"writeln" return (WRITELN);

; repeating statements
"for" return (FOR);
"to" return (TO);
"downto" return (DOWNTO);
"do" return (FOR_DO_STATEMENT); used in for
"while" return (WHILE);
"repeat" return (REPEAT);
"until" return (UNTIL);
"goto" return (GOTO);

; don't know
"asm" return (ASM);
"label" return (LABEL);
"operator" return (OPERATOR);
"packed" return (PACKED);
"reintroduce" return (REINTRODUCE);
"self" return (SELF);
"set" return (SET);
"shl" return (SHL);
"shr" return (SHR);
