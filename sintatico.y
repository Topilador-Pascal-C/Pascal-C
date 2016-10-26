%{
#include "global.h"
#include "symTable.h"
#include <stdlib.h> /* For malloc in symbol table */
#include <string.h> /* For strcmp in symbol table */
#include <stdio.h> /* For error messages */
#define YYDEBUG 1 /* For debugging */

/* interface to the lexer */
extern int yylineno;
extern int yyrestart();
int errors;

int debugValue = 1;

// to use debugValues: 
// debugValue = printDebugText(debugValue);
// {debugValue = printDebugText(debugValue);}

FILE * fileOut;

%}

%union { /* SEMANTIC RECORD */
    char * strval;
}

%token T_ATTRIBUTION;
%token T_SEMICOLON;

// structures
%token T_IF_STATEMENT;
%token T_IF_THEN_STATEMENT;
%token T_VAR_STATEMENT
%token T_CONST_STATEMENT

// variable types
%token <strval> T_TYPE_CHAR
%token <strval> T_TYPE_STRING
%token <strval> T_TYPE_BOOLEAN
%token <strval> T_TYPE_SHORTINT
%token <strval> T_TYPE_SMALLINT
%token <strval> T_TYPE_LONGINT
%token <strval> T_TYPE_INT64
%token <strval> T_TYPE_INTEGER
%token <strval> T_TYPE_BYTE
%token <strval> T_TYPE_WORD
%token <strval> T_TYPE_LONGWORD
%token <strval> T_TYPE_QWORD
%token <strval> T_TYPE_CARDINAL
%token <strval> T_TYPE_REAL
%token <strval> T_TYPE_SINGLE
%token <strval> T_TYPE_DOUBLE
%token <strval> T_TYPE_EXTENDED
%token <strval> T_TYPE_COMP
%token <strval> T_TYPE_CURRENCY

%token T_ANY_STRING
%token T_ANY_DIGIT
%token T_END_LINE

%type <strval> Type_Of_Variable

%start Input

%%

Input:
    { /* nothing */ }
    | Input Command
;

Command:
    T_END_LINE
    | If_Statement T_END_LINE
    | Declaration_Of_Variables T_END_LINE
    | Attribuition T_END_LINE
;

Any_String:
    T_ANY_STRING
;

Conditions:
    Expression
;

Expression:
    Any_String
;

Declaration_Of_Variables:
    Type_Of_Variable Any_String T_SEMICOLON {
        fprintf(fileOut, "%s ", $<strval>1);
        fprintf(fileOut, "%s", $<strval>2);
        fprintf(fileOut, ";\n");
    }
    | Type_Of_Variable Attribuition {
        fprintf(fileOut, "%s ", $<strval>1);
    }
;

Attribuition:
    Any_String T_ATTRIBUTION Expression T_SEMICOLON {
        fprintf(fileOut, "%s", $<strval>1);
        fprintf(fileOut, " = %s", $<strval>3);
        fprintf(fileOut, ";\n");
    }
;

Type_Of_Variable:
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

If_Statement:
    T_IF_STATEMENT Conditions T_IF_THEN_STATEMENT {
        fprintf(fileOut, "if ");
        fprintf(fileOut, "(%s)", $<strval>2);
        fprintf(fileOut, " {\n");
        fprintf(fileOut, "}\n");
    }
;

%%

int main(int argc, char ** argv){
    int i;

    if (argc < 2) {
        curfilename = "(stdin)";
        yylineno = 1;

        // Start the analisis lexical
        fileOut = fopen("out.c", "w");
        printf("Esperando a entrada do código a ser compilado...\n");
        yyparse();
        fclose(fileOut);
        printf("Leitura concluída e resultado compilado em out%d.c\n", i);
    } else {
        for (i = 1; i < argc; i++) {
            FILE * f = fopen(argv[i], "r");

            // Verified if the file is openned
            if (!f) {
                perror(argv[1]);
                return (1);
            } else {
                curfilename = argv[i];

                // Start the analisis lexical
                yyrestart(f);
                yylineno = 1;

                printf("Iniciando leitura do arquivo %s...\n", curfilename);
                
                char outfilename [10];
                sprintf(outfilename, "out%d.c", i);

                fileOut = fopen(outfilename, "w");
                yyparse();
                fclose(fileOut);
                printf("Arquivo compilado e resultado em %s\n", outfilename);

                fclose(f);
            }
        }
    }

    printf("\n\n----------------------\n");
    printf("Print of symbol table! \n\n");
    printrefs();
    printf("----------------------\n");
    return 1;
}

void yyerror(const char* errmsg) {
    printf("\n*** Erro: %s\n", errmsg);
}
