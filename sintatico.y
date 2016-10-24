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

int debugValue = 1;

// to use debugValues: debugValue = printDebugText(debugValue);

%}

%union { /* SEMANTIC RECORD */
    char * id; /* For returning identifiers */
    char * strval;
}

%token T_IDENT /* Simple identifier */

%token T_ATTRIBUTION;
%token T_SEMICOLON;

// structures
%token T_IF_STATEMENT;
%token T_IF_THEN_STATEMENT;
%token T_VAR_STATEMENT
%token T_CONST_STATEMENT

// variable types
%token <strval> T_TYPE_STRING
%token <strval> T_TYPE_CHAR
%token <strval> T_TYPE_BOOLEAN
%token <strval> T_TYPE_INTEGER
%token <strval> T_TYPE_BYTE
%token <strval> T_TYPE_SHORTINT
%token <strval> T_TYPE_SMALLINT
%token <strval> T_TYPE_WORD
%token <strval> T_TYPE_CARDINAL
%token <strval> T_TYPE_LONGINT
%token <strval> T_TYPE_LONGWORD
%token <strval> T_TYPE_INT64
%token <strval> T_TYPE_QWORD
%token <strval> T_TYPE_REAL
%token <strval> T_TYPE_DOUBLE
%token <strval> T_TYPE_SINGLE
%token <strval> T_TYPE_EXTENDED
%token <strval> T_TYPE_COMP
%token <strval> T_TYPE_CURRENCY

%token T_ANY_STRING
%token T_ANY_DIGIT
%token T_END_LINE

%type <strval> R_Variables

%start Input

%%

Input:
  { /* nothing */ }
  | Input Line
;

Line:
  T_END_LINE
  | R_If_Statement T_END_LINE {printf("Rodando ... \n");}
  | R_Attribuition T_END_LINE
;

R_Expression:
    T_ANY_STRING
;

R_If_Statement:
    T_IF_STATEMENT R_Expression T_IF_THEN_STATEMENT {
        printf("if ");
        printf("(%s)", $<id>2);
        printf(" {\n");
        printf("}\n");
    }
;

R_Attribuition:
    R_Variables R_Expression T_SEMICOLON {
      printf("%s ", $<strval>1);
      printf("%s", $<id>2);
      printf(";\n");
    }
;

R_Variables:
    T_TYPE_STRING {
        $$ = malloc(sizeof(strlen("string")));
        strcpy($$, "string");
    }
    | T_TYPE_CHAR {
        $$ = malloc(sizeof(strlen("char")));
        strcpy($$, "char");
    }
    | T_TYPE_BOOLEAN {
        $$ = malloc(sizeof(strlen("bool")));
        strcpy($$, "bool");
    }
    | T_TYPE_INTEGER {
        $$ = malloc(sizeof(strlen("int")));
        strcpy($$, "int");
    }
    | T_TYPE_BYTE
    | T_TYPE_SHORTINT
    | T_TYPE_WORD
    | T_TYPE_SMALLINT
    | T_TYPE_CARDINAL
    | T_TYPE_LONGINT
    | T_TYPE_LONGWORD
    | T_TYPE_INT64
    | T_TYPE_REAL {
        $$ = malloc(sizeof(strlen("float")));
        strcpy($$, "float");
    }
    | T_TYPE_DOUBLE {
        $$ = malloc(sizeof(strlen("float")));
        strcpy($$, "double");
    }
    | T_TYPE_QWORD
    | T_TYPE_EXTENDED
    | T_TYPE_SINGLE
    | T_TYPE_CURRENCY
    | T_TYPE_COMP
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

                /* yyrestart(f); */
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
