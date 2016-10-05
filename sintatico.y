%{
#include "global.h"
#include "symTable.h"
#include <stdlib.h> /* For malloc in symbol table */
#include <string.h> /* For strcmp in symbol table */
#include <stdio.h> /* For error messages */
#define YYDEBUG 1 /* For debugging */

/* interface to the lexer */
extern int yylineno;
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
%token T_END_LINE;

%start R_If_Statement

%%

R_If_Statement:
    T_IF_STATEMENT R_Expression T_IF_THEN_STATEMENT {
        printf("if ");
        printf("(%s)", $<id>2);
        printf(" {\n");
        printf("}\n");
    }
;

R_Expression:
    T_ANY_STRING
;

%%

int main(int argc, char ** argv){
    int i;

    if (argc < 2) {
        curfilename = "(stdin)";
        yylineno = 1;

        // Start the analisis lexical
        yyparse();
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
                yyparse();
                fclose(f);
            }
        }
    }
    printrefs();
    return 1;
}

void yyerror(const char* errmsg) {
    printf("\n*** Erro: %s\n", errmsg);
}
