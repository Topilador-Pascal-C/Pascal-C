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

%token T_END_PROGRAM
%token T_PROGRAM
%token T_BEGIN_STATEMENT
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

%start ProgramBegin

%%

ProgramBegin:
    T_PROGRAM Expression T_SEMICOLON {
        printIncludesOfProgram();
    } T_BEGIN_STATEMENT {
        printBeginOfProgram();
        incrementScope();
    } Commands T_END_PROGRAM {
        printEndOfProgram();
        decrementScope();
    }
    | T_PROGRAM Expression T_SEMICOLON {
        printIncludesOfProgram();
    } Declaration_Of_Variables T_BEGIN_STATEMENT {
        printBeginOfProgram();
        incrementScope();
    } Commands T_END_PROGRAM {
        printEndOfProgram();
        decrementScope();
    }
;

Commands:
    Command
    | Commands Command
;

Command:
    Attribuition
    | If_Statement
    | While_Statement
;

Declaration_Of_Variables:
    Declaration_Of_Variable
    | Declaration_Of_Variables Declaration_Of_Variable
;

Declaration_Of_Variable:
    T_VAR_STATEMENT Some_String T_COLON Type_Of_Variable T_SEMICOLON {
        if (addNewVariable($<strval>2, $<strval>4, yylineno, curfilename) == 1) {
            printDeclaration($<strval>4, $<strval>2);
        } else {
            printf("WARNING: Declaration of variable %s already exist in file %s in line %d.\n", $<strval>3, curfilename, yylineno);
        }
    }
    | Some_String T_COLON Type_Of_Variable T_SEMICOLON {
        if (addNewVariable($<strval>1, $<strval>3, yylineno, curfilename) == 1) {
            printDeclaration($<strval>3, $<strval>1);
        } else {
            printf("WARNING: Declaration of variable %s already exist in file %s in line %d.\n", $<strval>1, curfilename, yylineno);
        }
    }
;

Some_String:
    T_SOME_WORD
    | T_SOME_VARIABLES
;

Expression:
    Some_String
;

If_Statement:
    T_IF_STATEMENT {
        printIfDeclaration("begin");
    } Multiple_Conditions {
        debugValue = printDebugText(debugValue);
    } T_IF_THEN_STATEMENT {
        debugValue = printDebugText(debugValue);
    }  T_BEGIN_STATEMENT {
        printIfDeclaration("end");
        incrementScope();
    } Commands T_END_STATEMENT T_SEMICOLON {
        decrementScope();
        printEndStatements();
    }
    //| T_IF_STATEMENT {
    //    printIfDeclaration("begin");
    //} Multiple_Conditions T_IF_THEN_STATEMENT {
    //    printIfDeclaration("end");
    //    incrementScope();
    //} Command {
    //    decrementScope();
    //    printEndStatements();
    //} 
;

While_Statement:
    T_WHILE_STATEMENT {
        printWhileDeclaration("begin");
    } Multiple_Conditions T_DO_STATEMENT {
        printWhileDeclaration("end");
        printEndStatements();
    }
;

Multiple_Conditions:
    Conditions
    | Conditions T_AND_STATEMENT {
        printAndOrCondition("and");
    } Conditions
    | Conditions T_OR_STATEMENT {
        printAndOrCondition("or");
    } Conditions
;

Conditions:
    Expression {
        printCondition1($<strval>1);
    }
    | Expression T_EQUAL Expression {
        printCondition($<strval>1, $<strval>3, "==");
    }
    | Expression T_DIFFERENT Expression {
        printCondition($<strval>1, $<strval>3, "!=");
    }
    | Expression T_BIGGER Expression {
        printCondition($<strval>1, $<strval>3, ">");
    }
    | Expression T_BIGGER_OR_EQUAL Expression {
        printCondition($<strval>1, $<strval>3, ">=");
    }
    | Expression T_MINOR Expression {
        printCondition($<strval>1, $<strval>3, "<");
    }
    | Expression T_MINOR_OR_EQUAL Expression {
        printCondition($<strval>1, $<strval>3, "<=");
    }
;

Attribuition:
    Some_String T_ATTRIBUTION T_APOSTROPHE Some_String T_APOSTROPHE T_SEMICOLON {
        addAttribuition($<strval>1, $<strval>4, yylineno, curfilename);
        printAtribuition($<strval>1, "string", $<strval>4);
    }
    | Some_String T_ATTRIBUTION Some_String T_SEMICOLON {
        addAttribuition($<strval>1, $<strval>3, yylineno, curfilename);
        printAtribuition($<strval>1, "number/expression", $<strval>3);
    }
;

Type_Of_Variable:
    T_TYPE_SHORTINT {
        $$ = mallocNewString("signed char");
    }
    | T_TYPE_SMALLINT {
        $$ = mallocNewString("short int");
    }
    | T_TYPE_LONGINT {
        $$ = mallocNewString("int");
    }
    | T_TYPE_INT64 {
        $$ = mallocNewString("long long");
    }
    | T_TYPE_BYTE {
        $$ = mallocNewString("unsigned char");
    }
    | T_TYPE_WORD {
        $$ = mallocNewString("unsigned short int");
    }
    | T_TYPE_LONGWORD {
        $$ = mallocNewString("unsigned int");
    }
    | T_TYPE_QWORD {
        $$ = mallocNewString("unsigned long long");
    }
    | T_TYPE_INTEGER {
        $$ = mallocNewString("int");
    }
    | T_TYPE_CARDINAL {
        $$ = mallocNewString("unsigned int");
    }

    | T_TYPE_CURRENCY
    | T_TYPE_COMP
    | T_TYPE_REAL

    | T_TYPE_DOUBLE {
        $$ = mallocNewString("double");
    }
    | T_TYPE_EXTENDED {
        $$ = mallocNewString("long double");
    }
    | T_TYPE_SINGLE {
        $$ = mallocNewString("float");
    }

    | T_TYPE_STRING {
        $$ = mallocNewString("string");
    }
    | T_TYPE_CHAR {
        $$ = mallocNewString("char");
    }
    | T_TYPE_BOOLEAN {
        $$ = mallocNewString("bool");
    }
;

%%

int main(int argc, char ** argv){
    int i, k;

    size_of_table = 0;
    if (argc < 2) {
        curfilename = "(stdin)";
        yylineno = 1;
        scope = 0;

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
                scope = 0;
                
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
