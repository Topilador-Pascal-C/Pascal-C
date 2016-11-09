%{
#include "global.h"
#include "symbolTable.h"
#include "auxFunctions.h"
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

%}

%union { /* SEMANTIC RECORD */
    char * strval;
}

%token T_ATTRIBUTION;
%token T_SEMICOLON;
%token T_COLON;
%token T_QUOTATION_MARKS;

// structures
%token T_IF_STATEMENT;
%token T_IF_THEN_STATEMENT;
%token T_WHILE_STATEMENT;
%token T_DO_STATEMENT;
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

%token T_APOSTROPHE;
%token T_SOME_TEXT
%token T_SOME_WORD
%token T_SOME_VARIABLES
%token T_SOME_DIGIT
%token T_END_LINE
%token <strval> T_END_PROGRAM
%token <strval> T_PROGRAM
%token <strval> T_BEGIN
%token T_END_STATEMENT
%token T_OR_STATEMENT
%token T_AND_STATEMENT

%token T_EQUAL
%token T_DIFFERENT
%token T_BIGGER
%token T_BIGGER_OR_EQUAL
%token T_MINOR
%token T_MINOR_OR_EQUAL

%type <strval> Type_Of_Variable
%type <strval> Lim_File
%type <strval> Conditions
%type <strval> Multiple_Conditions

%start Input

%%

Input:
    { /* nothing */ }
    | Input Command
;

Command:
    Lim_File
    | T_END_LINE
    | If_Statement T_END_LINE
    | While_Statement T_END_LINE
    | Declaration_Of_Variables T_END_LINE
    | Attribuition T_END_LINE
;

Some_String:
    T_SOME_WORD
    | T_SOME_VARIABLES
;

Lim_File:
    T_END_PROGRAM {
        fprintf(fileOut, "\n\treturn 0;\n}");
    }
    | T_PROGRAM Expression T_SEMICOLON {
        fprintf(fileOut, "#include <bits/stdc++.h>\n\n using namespace std;\n\n");
    }
    | T_BEGIN {
        fprintf(fileOut, "\nint main() {\n");
    }
;

Expression:
    Some_String
;

If_Statement:
    T_IF_STATEMENT {
        fprintf(fileOut, "if ");
        fprintf(fileOut, "(");
        
    } Multiple_Conditions T_IF_THEN_STATEMENT {
        fprintf(fileOut, ") ");
        fprintf(fileOut, "{\n");
        fprintf(fileOut, "}\n");
    }

;

Multiple_Conditions:
    Conditions
    | Conditions T_AND_STATEMENT {
        fprintf(fileOut, " && ");
    } Conditions
    | Conditions T_OR_STATEMENT {
        fprintf(fileOut, " || ");
    } Conditions
;

Conditions:
    Expression {
        fprintf(fileOut, "%s", $<strval>1);
    }
    | Expression T_EQUAL Expression {
        fprintf(fileOut, "%s", $<strval>1);
        fprintf(fileOut, " == ");
        fprintf(fileOut, "%s", $<strval>3);

    }
    | Expression T_DIFFERENT Expression {
        fprintf(fileOut, "%s", $<strval>1);
        fprintf(fileOut, " != ");
        fprintf(fileOut, "%s", $<strval>3);
    }
    | Expression T_BIGGER Expression {
        fprintf(fileOut, "%s", $<strval>1);
        fprintf(fileOut, " > ");
        fprintf(fileOut, "%s", $<strval>3);
    }
    | Expression T_BIGGER_OR_EQUAL Expression {
        fprintf(fileOut, "%s", $<strval>1);
        fprintf(fileOut, " >= ");
        fprintf(fileOut, "%s", $<strval>3);
    }
    | Expression T_MINOR Expression {
        fprintf(fileOut, "%s", $<strval>1);
        fprintf(fileOut, " < ");
        fprintf(fileOut, "%s", $<strval>3);
    }
    | Expression T_MINOR_OR_EQUAL Expression {
        fprintf(fileOut, "%s", $<strval>1);
        fprintf(fileOut, " <= ");
        fprintf(fileOut, "%s", $<strval>3);
    }
;

Declaration_Of_Variables:
    T_VAR_STATEMENT T_END_LINE Some_String T_COLON Type_Of_Variable T_SEMICOLON {
        addSymbol(yylineno, curfilename, $<strval>3);
        printDeclarations($<strval>5, $<strval>3);
    }
    | Some_String T_COLON Type_Of_Variable T_SEMICOLON {
        addSymbol(yylineno, curfilename, $<strval>1);
        printDeclarations($<strval>3, $<strval>1);
    }
;

Attribuition:
    Some_String T_ATTRIBUTION T_APOSTROPHE Some_String T_APOSTROPHE T_SEMICOLON {
        addSymbol(yylineno, curfilename, $<strval>1);
        fprintf(fileOut, "%s", $<strval>1);
        fprintf(fileOut, " = \"%s\"", $<strval>4);
        fprintf(fileOut, ";\n");
    }
    | Some_String T_ATTRIBUTION Some_String T_SEMICOLON {
        addSymbol(yylineno, curfilename, $<strval>1);
        fprintf(fileOut, "%s", $<strval>1);
        fprintf(fileOut, " = %s", $<strval>3);
        fprintf(fileOut, ";\n");
    }
;

Type_Of_Variable:
    T_TYPE_SHORTINT {
        $$ = malloc(sizeof(strlen("signed char")));
        strcpy($$, "signed char");
    }
    | T_TYPE_SMALLINT {
        $$ = malloc(sizeof(strlen("short int")));
        strcpy($$, "short int");
    }
    | T_TYPE_LONGINT {
        $$ = malloc(sizeof(strlen("int")));
        strcpy($$, "int");
    }
    | T_TYPE_INT64 {
        $$ = malloc(sizeof(strlen("long long")));
        strcpy($$, "long long");
    }
    | T_TYPE_BYTE {
        $$ = malloc(sizeof(strlen("unsigned char")));
        strcpy($$, "unsigned char");
    }
    | T_TYPE_WORD {
        $$ = malloc(sizeof(strlen("unsigned short int")));
        strcpy($$, "unsigned short int");
    }
    | T_TYPE_LONGWORD {
        $$ = malloc(sizeof(strlen("unsigned int")));
        strcpy($$, "unsigned int");
    }
    | T_TYPE_QWORD {
        $$ = malloc(sizeof(strlen("unsigned long long")));
        strcpy($$, "unsigned long long");
    }
    | T_TYPE_INTEGER {
        $$ = malloc(sizeof(strlen("int")));
        strcpy($$, "int");
    }
    | T_TYPE_CARDINAL {
        $$ = malloc(sizeof(strlen("unsigned int")));
        strcpy($$, "unsigned int");
    }

    | T_TYPE_CURRENCY
    | T_TYPE_COMP
    | T_TYPE_REAL

    | T_TYPE_DOUBLE {
        $$ = malloc(sizeof(strlen("double")));
        strcpy($$, "double");
    }
    | T_TYPE_EXTENDED {
        $$ = malloc(sizeof(strlen("long double")));
        strcpy($$, "long double");
    }
    | T_TYPE_SINGLE {
        $$ = malloc(sizeof(strlen("float")));
        strcpy($$, "float");
    }

    | T_TYPE_STRING {
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
;
While_Statement:
    T_WHILE_STATEMENT Conditions T_DO_STATEMENT {
        fprintf(fileOut, "while ");
        fprintf(fileOut, "(%s)", $<strval>2);
        fprintf(fileOut, " {\n");
        fprintf(fileOut, "}\n");
    }
    | T_WHILE_STATEMENT Expression T_EQUAL Expression T_DO_STATEMENT {
        fprintf(fileOut, "while ");
        fprintf(fileOut, "(%s == %s)", $<strval>2, $<strval>4);
        fprintf(fileOut, " {\n");
        fprintf(fileOut, "}\n");
    }
    | T_WHILE_STATEMENT Expression T_DIFFERENT Expression T_DO_STATEMENT {
        fprintf(fileOut, "while ");
        fprintf(fileOut, "(%s != %s)", $<strval>2, $<strval>4);
        fprintf(fileOut, " {\n");
        fprintf(fileOut, "}\n");
    }
    | T_WHILE_STATEMENT  Expression T_BIGGER Expression T_DO_STATEMENT {
        fprintf(fileOut, "while ");
        fprintf(fileOut, "(%s > %s)", $<strval>2, $<strval>4);
        fprintf(fileOut, " {\n");
        fprintf(fileOut, "}\n");
    }
    | T_WHILE_STATEMENT Expression T_BIGGER_OR_EQUAL Expression T_DO_STATEMENT {
        fprintf(fileOut, "while ");
        fprintf(fileOut, "(%s >= %s)", $<strval>2, $<strval>4);
        fprintf(fileOut, " {\n");
        fprintf(fileOut, "}\n");
    }
    | T_WHILE_STATEMENT Expression T_MINOR Expression T_DO_STATEMENT {
        fprintf(fileOut, "while ");
        fprintf(fileOut, "(%s < %s)", $<strval>2, $<strval>4);
        fprintf(fileOut, " {\n");
        fprintf(fileOut, "}\n");
    }
    | T_WHILE_STATEMENT Expression T_MINOR_OR_EQUAL Expression T_DO_STATEMENT {
        fprintf(fileOut, "while ");
        fprintf(fileOut, "(%s <= %s)", $<strval>2, $<strval>4);
        fprintf(fileOut, " {\n");
        fprintf(fileOut, "}\n");
    }
;

%%

int main(int argc, char ** argv){
    int i, k;

    size_of_table = 0;

    if (argc < 2) {
        curfilename = "(stdin)";
        yylineno = 1;

        // Start the analisis lexical
        fileOut = fopen("out.c", "w");
        printf("Esperando a entrada do código a ser compilado...\n");
        yyparse();
        fclose(fileOut);
        printf("Leitura concluída e resultado compilado em %s.c\n", fileName);
    } else {
        for (i = 1; i < argc; i++) {
            FILE * f = fopen(argv[i], "r");

            // Verified if the file is openned
            if (!f) {
                perror(argv[1]);
                return (1);
            } else {
                curfilename = argv[i];
                fileName = malloc(sizeof(strlen(curfilename)));
                for (k = 0; k < (int)strlen(curfilename)-4; k++) {
                    if (curfilename[k] != '.') {
                        fileName[k] = curfilename[k];
                    }
                    else break;
                }

                // Start the analisis lexical
                yyrestart(f);
                yylineno = 1;

                printf("Iniciando leitura do arquivo %s...\n", curfilename);

                char outfilename [10];
                sprintf(outfilename, "%s.cpp", fileName);

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
    printSymbolTable();
    printf("----------------------\n");
    return 1;
}

void yyerror(const char* errmsg) {
    printf("\n*** Erro: %s\n", errmsg);
}
