%{
#include "global.h"
#include <stdlib.h> /* For malloc in symbol table */
#include <string.h> /* For strcmp in symbol table */
#include <stdio.h> /* For error messages */
#define YYDEBUG 1 /* For debugging */

int errors;

%}

%union { /* SEMANTIC RECORD */
    char * id; /* For returning identifiers */
}

%token <id> T_IDENT /* Simple identifier */

%token T_IF_STATEMENT
%token T_IF_THEN_STATEMENT

%token T_ANY_STRING;
%token T_ANY_DIGIT;

%start R_If_Statement

%%

R_If_Statement:
    T_IF_STATEMENT R_Expression T_IF_THEN_STATEMENT {
        printf("if ");
        printf("(%s)", $<id>2);
        printf(" {\n");
        printf("}");
    }
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
