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
    int intval;
    double doubval;
    type_values * all;
}

%token <all> T_INT_NUMBER;
%token <all> T_DOUBLE_NUMBER;

%token T_ATTRIBUTION;
%token T_SEMICOLON;
%token T_COLON;
%token T_QUOTATION_MARKS;
%token T_APOSTROPHE;

// structures
%token T_IF_STATEMENT;
%token T_IF_THEN_STATEMENT;
%token T_WHILE_STATEMENT;
%token T_DO_STATEMENT;
%token T_VAR_STATEMENT
%token T_CONST_STATEMENT
%token T_FOR_STATEMENT
%token T_TO_STATEMENT
%token T_DOWNTO_STATEMENT
%token T_REPEAT_STATEMENT
%token T_UNTIL_STATEMENT

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

%token <all> T_SOME_TEXT
%token <all> T_SOME_WORD
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

%token T_WRITE
%token T_WRITELN

%token T_READ

%token T_LEFT_PARENTHESIS
%token T_RIGHT_PARENTHESIS

%type <strval> Type_Of_Variable
%type <all> Some_String

%start ProgramBegin

%%

ProgramBegin:
    T_PROGRAM Variable T_SEMICOLON {
        printIncludesOfProgram();
    } T_BEGIN_STATEMENT {
        printBeginOfProgram();
        incrementScope();
    } Commands T_END_PROGRAM {
        printEndOfProgram();
        decrementScope();
    }
    | T_PROGRAM Variable T_SEMICOLON {
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
    | For_Statement
    | Write_Statements
    | Repeat_Until_Statement
;

Declaration_Of_Variables:
    Declaration_Of_Variable
    | Declaration_Of_Variables Declaration_Of_Variable
;

Declaration_Of_Variable:
    T_VAR_STATEMENT Variable T_COLON Type_Of_Variable T_SEMICOLON {
        if (addNewVariable($<all>2, $4, yylineno, curfilename) == 1) {
            printDeclaration($4, $<all>2);
        } else {
            printf("WARNING: Declaration of variable %s already exist in file %s in line %d.\n", (char*)$<all>2->value, curfilename, yylineno);
        }
    }
    | Variable T_COLON Type_Of_Variable T_SEMICOLON {
        if (addNewVariable($<all>1, $3, yylineno, curfilename) == 1) {
            printDeclaration($3, $<all>1);
        } else {
            printf("WARNING: Declaration of variable %s already exist in file %s in line %d.\n", (char*)$<all>1->value, curfilename, yylineno);
        }
    }
;

Variable:
    T_SOME_WORD
;

Some_String:
    T_SOME_TEXT
    | T_APOSTROPHE T_SOME_WORD T_APOSTROPHE {
        $$ = $<all>2;
    }
;

Some_Int:
    T_INT_NUMBER
;

Some_Double:
    T_DOUBLE_NUMBER
;

Expression:
    Variable
	| T_INT_NUMBER
    | T_DOUBLE_NUMBER
;

For_Statement:
    T_FOR_STATEMENT {
        printForDeclaration("begin", "", 0, "");
    } For_Info
;

For_Info:
    Attribuition T_TO_STATEMENT Some_Int {
        char * variable = getVariableFor();
        printForDeclaration("condition_to_int", variable, $<intval>3, "");
    } For_Do_To
    | Attribuition T_TO_STATEMENT Variable {
        char * variable = getVariableFor();
        printForDeclaration("condition_to_str", variable, 0,$<all>3->value);
    } For_Do_To
    | Attribuition T_DOWNTO_STATEMENT Some_Int {
        char * variable = getVariableFor();
        printForDeclaration("condition_downto_int", variable, $<intval>3, "");
    } For_Do_Downto
;

For_Do_To:
    T_DO_STATEMENT {
        char * variable = getVariableFor();
        printForDeclaration("end_to", variable, 0, "");
        incrementScope();
    } Statement_Complementation
;

For_Do_Downto:
    T_DO_STATEMENT {
        char * variable = getVariableFor();
        printForDeclaration("end_downto", variable, 0, "");
        incrementScope();
    } Statement_Complementation
;

If_Statement:
    T_IF_STATEMENT {
        printIfDeclaration("begin");
    } Multiple_Conditions T_IF_THEN_STATEMENT {
        printIfDeclaration("end");
        incrementScope();
    } Statement_Complementation
;

While_Statement:
    T_WHILE_STATEMENT {
        printWhileDeclaration("begin");
    } Multiple_Conditions T_DO_STATEMENT  {
        printWhileDeclaration("end");
        incrementScope();
    } Statement_Complementation
;

Statement_Complementation:
    T_BEGIN_STATEMENT Commands T_END_STATEMENT T_SEMICOLON {
        decrementScope();
        printEndStatements();
    }
    | Command {
        decrementScope();
        printEndStatements();
    }
;

Repeat_Until_Statement:
    T_REPEAT_STATEMENT {
        printRepeatDeclaration("begin");
        incrementScope();
    } Commands T_UNTIL_STATEMENT {
        decrementScope();
        printRepeatDeclaration("before_end");
    } Multiple_Conditions T_SEMICOLON {
        printRepeatDeclaration("after_end");
    }
;

Write_Statements:
    T_WRITE {
        printWriteDeclaration("begin");
    } Write_Statement_Complementation {
        printWriteDeclaration("end");
    }
    | T_WRITELN {
        printWriteDeclaration("begin");
    } Write_Statement_Complementation {
        printWriteDeclaration("endln");
    }
;

Write_Statement_Complementation:
    T_LEFT_PARENTHESIS Some_String T_RIGHT_PARENTHESIS T_SEMICOLON {
        printWriteDeclarationString($<all>2->value);
    }
    | T_LEFT_PARENTHESIS Expression T_RIGHT_PARENTHESIS T_SEMICOLON {
        printWriteDeclarationVariable($<all>2->value);
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
        printConditionOne($<all>1);
    }
    | Expression T_EQUAL Expression {
        printCondition($<all>1, $<all>3, "==");
    }
    | Expression T_DIFFERENT Expression {
        printCondition($<all>1, $<all>3, "!=");
    }
    | Expression T_BIGGER Expression {
        printCondition($<all>1, $<all>3, ">");
    }
    | Expression T_BIGGER_OR_EQUAL Expression {
        printCondition($<all>1, $<all>3, ">=");
    }
    | Expression T_MINOR Expression {
        printCondition($<all>1, $<all>3, "<");
    }
    | Expression T_MINOR_OR_EQUAL Expression {
        printCondition($<all>1, $<all>3, "<=");
    }
;

Attribuition:
    Attribuition_Without_Semicolon
    | Attribuition_With_Semicolon
;
Attribuition_With_Semicolon:
    Variable T_ATTRIBUTION Some_String T_SEMICOLON {
        addAttribuition($<all>1->value, $<all>3->value, yylineno, curfilename);
        printAtribuition($<all>1->value, "string", $<all>3->value);
    }
    | Variable T_ATTRIBUTION Variable T_SEMICOLON {
        addAttribuition($<all>1->value, $<all>3->value, yylineno, curfilename);
        printAtribuition($<all>1->value, "variable", $<all>3->value);
    }
    | Variable T_ATTRIBUTION Some_Int T_SEMICOLON {
        printAtribuitionNoSemicolonInt($<all>1->value, "int", $<intval>3);
    }
    | Variable T_ATTRIBUTION Some_Double T_SEMICOLON {
        printAtribuitionNoSemicolonDouble($<all>1->value, "double", $<doubval>3);
    }
;

Attribuition_Without_Semicolon:
    Variable T_ATTRIBUTION Some_String {
        addAttribuition($<all>1->value, $<all>3->value, yylineno, curfilename);
        printAtribuitionNoSemicolon($<all>1->value, "number/expression", $<all>3->value);
    }
    | Variable T_ATTRIBUTION Variable {
        addAttribuition($<all>1->value, $<all>3->value, yylineno, curfilename);
        printAtribuition($<all>1->value, "variable", $<all>3->value);
    }
    | Variable T_ATTRIBUTION Some_Int {
        setVariableFor($<all>1->value);
        printAtribuitionNoSemicolonIntFor($<all>1->value, "int", $<intval>3);
    }
    | Variable T_ATTRIBUTION Some_Double {
        printAtribuitionNoSemicolonDouble($<all>1->value, "double", $<doubval>3);
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
