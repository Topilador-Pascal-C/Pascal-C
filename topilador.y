%{
#include "global.h"
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
%}

%token NUMBER PLUS MINUS TIMES DIVIDE_REAL DIVIDE_INTEGER POWER
%token LEFT_PARENTHESIS RIGHT_PARENTHESIS
%token ATTRIBUTION SEMICOLON COLON COMMA EQUAL DIFFERENT
%token BIGGER BIGGER_OR_EQUAL MINOR MINOR_OR_EQUAL 
%token MOD AND_STATEMENT OR_STATEMENT XOR NOT 
%token END END_PROGRAM

%token PROGRAM_STATEMENT UNIT_STATEMENT IMPORT_LIBRARIES
%token BEGIN VAR_STATEMENT NEW_STATEMENT BREAK CONST
%token CONTINUE IMPLEMENTATION INHERITED INLINE INTERFACE
%token NULL_STATEMENT NOT  
 
%token FILE RESET REWRITE ASSIGN CLOSE

%token STRING_STATEMENT FALSE TRUE ARRAY BOOLEAN
%token CHAR OBJECT RECORD

%token INTEGER_STATEMENT BYTE SHORTINT SMALLINT WORD
%token CARDINAL LONGINT LONGWORD INT64 QWORD

%token REAL DOUBLE SINGLE EXTENDED COMP CURRENCY 

%token FUNCTION PROCEDURE CONSTRUCTOR DESTRUCTOR

%token IN ON OF WITH

%token IF_STATEMENT IF_THEN_STATEMENT ELSE_STATEMENT SWITCH_CASE

%token FOR TO DOWNTO FOR_DO_STATEMENT 
%token WHILE REPEAT UNTIL GOTO

%token ASM LABEL OPERATOR PACKED REINTRODUCE
%token SELF SET SHL SHR 

%start Input
 
%%
 
Input:
    /* Empty */
    | Input Line
    ;
Line:
    END
    | Expression END { printf("Resultado: %f\n",$1); }
    ;
Expression:
	NUMBER { $$=$1; }
	| Expression PLUS Expression { $$=$1+$3; }
	| Expression MINUS Expression { $$=$1-$3; }
	| Expression TIMES Expression { $$=$1*$3; }
	| Expression DIVIDE Expression { $$=$1/$3; }
	| MINUS Expression %prec NEG { $$=-$2; }
	| Expression POWER Expression { $$=pow($1,$3); }
	| LEFT_PARENTHESIS Expression RIGHT_PARENTHESIS { $$=$2; }
	;
 
%%
 
void yyerror(const char* errmsg) {
	printf("\n*** Erro: %s\n", errmsg);
}
 
int yywrap(void) { 
	return 1; 
}
 
int main() {
    yyparse();
    return 0;
}
