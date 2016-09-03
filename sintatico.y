%{
#include "global.h"
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
%}

%token NUMBER 
%token PLUS
%token MINUS 
%token TIMES
%token DIVIDE_REAL
%token DIVIDE_INTEGER
%token POWER

%token LEFT_PARENTHESIS 
%token RIGHT_PARENTHESIS
%token ATTRIBUTION
%token SEMICOLON
%token COLON
%token COMMA
%token EQUAL
%token DIFFERENT
%token BIGGER
%token BIGGER_OR_EQUAL
%token MINOR
%token MINOR_OR_EQUAL 
%token MOD 
%token AND_STATEMENT
%token OR_STATEMENT
%token XOR 
%token END
%token END_PROGRAM

%token PROGRAM_STATEMENT
%token UNIT_STATEMENT
%token IMPORT_LIBRARIES
%token BEGIN
%token VAR_STATEMENT
%token NEW_STATEMENT
%token BREAK CONST
%token CONTINUE
%token IMPLEMENTATION
%token INHERITED
%token INLINE
%token INTERFACE
%token NULL_STATEMENT
%token NOT  
 
%token FILE_DECLARATION
%token RESET
%token REWRITE
%token ASSIGN
%token CLOSE

%token STRING_STATEMENT
%token FALSE
%token TRUE
%token ARRAY
%token BOOLEAN
%token CHAR
%token OBJECT
%token RECORD

%token INTEGER_STATEMENT
%token BYTE
%token SHORTINT
%token SMALLINT
%token WORD
%token CARDINAL
%token LONGINT
%token LONGWORD
%token INT64
%token QWORD

%token REAL
%token DOUBLE
%token SINGLE
%token EXTENDED
%token COMP
%token CURRENCY 

%token FUNCTION
%token PROCEDURE
%token CONSTRUCTOR
%token DESTRUCTOR

%token IN
%token ON
%token OF
%token WITH

%token IF_STATEMENT
%token IF_THEN_STATEMENT
%token ELSE_STATEMENT
%token SWITCH_CASE

%token FOR
%token TO
%token DOWNTO
%token FOR_DO_STATEMENT 
%token WHILE 
%token REPEAT
%token UNTIL
%token GOTO

%token ASM
%token LABEL
%token OPERATOR
%token PACKED
%token REINTRODUCE
%token SELF
%token SET
%token SHL
%token SHR 


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
	| Expression DIVIDE_REAL Expression { $$=$1/$3; }
	| Expression POWER Expression { $$=pow($1,$3); }
	| LEFT_PARENTHESIS Expression RIGHT_PARENTHESIS { $$=$2; }
	;
 
%%
 
void yyerror(const char* errmsg)
{
   printf("\n*** Erro: %s\n", errmsg);
}
 
int yywrap(void) { return 1; }
 
int main(int argc, char** argv)
{
     yyparse();
     return 0;
}
