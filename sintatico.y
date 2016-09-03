%{
#include "global.h"
#include <stdio.h>
%}

%token T_IF_STATEMENT
%token T_IF_THEN_STATEMENT

%token T_ANY_STRING;
%token T_ANY_DIGIT;

%start R_If_Statement

%%
 
R_If_Statement:
    T_IF_STATEMENT R_Expression T_IF_THEN_STATEMENT
;

R_Expression:
    T_ANY_STRING
;

%%
 
void yyerror(const char* errmsg) {
    printf("\n*** Erro: %s\n", errmsg);
}

int yywrap(void) {
    return 0;
}
 
int main(int argc, char** argv) {
    yyparse();
    return 0;
}
