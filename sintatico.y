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
}

%token <intval> T_INT_NUMBER;
%token <doubval> T_DOUBLE_NUMBER;

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

%token T_WRITE
%token T_WRITELN
%token <strval> T_STRING

%token T_READ

%token T_LEFT_PARENTHESIS
%token T_RIGHT_PARENTHESIS

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
    | For_Statement
    | Write_Statement
    | Writeln_Statement
<<<<<<< HEAD
=======
    | Read_Statement
    | Repeat_Until_Statement
>>>>>>> 453e4a1ef273bf25188e2ff8a590b55de1169664
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

Some_Int:
    T_INT_NUMBER
;

Some_Double:
	T_DOUBLE_NUMBER
;

Some_String:
    T_SOME_WORD
    | T_SOME_VARIABLES
    | T_SOME_TEXT
;

Expression:
    Some_String
;

Expression_Int:
	Some_Int
;

Expression_Double:
    Some_Double
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

For_Statement:
    T_FOR_STATEMENT {
        printForDeclaration("begin", "", 0, "");
    } For_Info
;

For_Info:
    For_Attribution T_TO_STATEMENT Some_Int {
        char * variable = get_variable_for();
        printForDeclaration("condition_to_int", variable, $<intval>3, "");
    } For_Do_To
    | For_Attribution T_TO_STATEMENT Some_String {
        char * variable = get_variable_for();
        printForDeclaration("condition_to_str", variable, 0,$<strval>3);
    } For_Do_To
    | For_Attribution T_DOWNTO_STATEMENT Some_Int {
        char * variable = get_variable_for();
        printForDeclaration("condition_downto_int", variable, $<intval>3, "");
    } For_Do_Downto
;

For_Do_To:
    T_DO_STATEMENT {
        char * variable = get_variable_for();
        printForDeclaration("end_to", variable, 0, "");
        incrementScope();
    } Statement_Complementation
;

For_Do_Downto:
    T_DO_STATEMENT {
        char * variable = get_variable_for();
        printForDeclaration("end_downto", variable, 0, "");
        incrementScope();
    } Statement_Complementation
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

Write_Statement:
    T_WRITE T_LEFT_PARENTHESIS T_APOSTROPHE Some_String T_APOSTROPHE T_RIGHT_PARENTHESIS T_SEMICOLON {
        printWriteDeclarationString($<strval>4);
    }
    | T_WRITE T_LEFT_PARENTHESIS Expression T_RIGHT_PARENTHESIS T_SEMICOLON {
        printWriteDeclarationVariable($<strval>3);
    }
;

Writeln_Statement:
    T_WRITELN T_LEFT_PARENTHESIS T_APOSTROPHE Some_String T_APOSTROPHE T_RIGHT_PARENTHESIS T_SEMICOLON {
        printWritelnDeclarationString($<strval>4);
    }
    | T_WRITELN T_LEFT_PARENTHESIS Expression T_RIGHT_PARENTHESIS T_SEMICOLON {
        printWritelnDeclarationVariable($<strval>3);
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
    Conditions_String
    | Conditions_Double
    | Conditions_Int
;

Conditions_String:
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

Conditions_Int:
    Expression_Int {
    	printConditionInt($<intval>1);
    }
    | Expression_Int T_EQUAL Expression {
        printConditionIntFirst($<intval>1, $<strval>3, "==");
    }
    | Expression T_EQUAL Expression_Int {
        printConditionIntLast($<strval>1, $<intval>3, "==");
    }
    | Expression_Int T_EQUAL Expression_Int {
        printConditionIntAll($<intval>1, $<intval>3, "==");
    }
    | Expression_Int T_DIFFERENT Expression {
        printConditionIntFirst($<intval>1, $<strval>3, "!=");
    }
    | Expression T_DIFFERENT Expression_Int {
        printConditionIntLast($<strval>1, $<intval>3, "!=");
    }
    | Expression_Int T_DIFFERENT Expression_Int {
        printConditionIntAll($<intval>1, $<intval>3, "!=");
    }
    | Expression_Int T_BIGGER Expression {
        printConditionIntFirst($<intval>1, $<strval>3, ">");
    }
    | Expression T_BIGGER Expression_Int {
        printConditionIntLast($<strval>1, $<intval>3, ">");
    }
    | Expression_Int T_BIGGER Expression_Int {
        printConditionIntAll($<intval>1, $<intval>3, ">");
    }
    | Expression_Int T_BIGGER_OR_EQUAL Expression {
        printConditionIntFirst($<intval>1, $<strval>3, ">=");
    }
    | Expression T_BIGGER_OR_EQUAL Expression_Int {
        printConditionIntLast($<strval>1, $<intval>3, ">=");
    }
    | Expression_Int T_BIGGER_OR_EQUAL Expression_Int {
        printConditionIntAll($<intval>1, $<intval>3, ">=");
    }
    | Expression_Int T_MINOR Expression {
        printConditionIntFirst($<intval>1, $<strval>3, "<");
    }
    | Expression T_MINOR Expression_Int {
        printConditionIntLast($<strval>1, $<intval>3, "<");
    }
    | Expression_Int T_MINOR Expression_Int {
        printConditionIntAll($<intval>1, $<intval>3, "<");
    }
    | Expression_Int T_MINOR_OR_EQUAL Expression {
        printConditionIntFirst($<intval>1, $<strval>3, "<=");
    }
    | Expression T_MINOR_OR_EQUAL Expression_Int {
        printConditionIntLast($<strval>1, $<intval>3, "<=");
    }
    | Expression_Int T_MINOR_OR_EQUAL Expression_Int {
        printConditionIntAll($<intval>1, $<intval>3, "<=");
    }
;

Conditions_Double:
    Expression_Double {
        printConditionDouble($<doubval>1);
    }
    | Expression_Double T_EQUAL Expression {
        printConditionDoubleFirst($<doubval>1, $<strval>3, "==");
    }
    | Expression T_EQUAL Expression_Double {
        printConditionDoubleLast($<strval>1, $<doubval>3, "==");
    }
    | Expression_Double T_EQUAL Expression_Double {
        printConditionDoubleAll($<doubval>1, $<doubval>3, "==");
    }
    | Expression_Double T_DIFFERENT Expression {
        printConditionDoubleFirst($<doubval>1, $<strval>3, "!=");
    }
    | Expression T_DIFFERENT Expression_Double {
        printConditionDoubleLast($<strval>1, $<doubval>3, "!=");
    }
    | Expression_Double T_DIFFERENT Expression_Double {
        printConditionDoubleAll($<doubval>1, $<doubval>3, "!=");
    }
    | Expression_Double T_BIGGER Expression {
        printConditionDoubleFirst($<doubval>1, $<strval>3, ">");
    }
    | Expression T_BIGGER Expression_Double {
        printConditionDoubleLast($<strval>1, $<doubval>3, ">");
    }
    | Expression_Double T_BIGGER Expression_Double {
        printConditionDoubleAll($<doubval>1, $<doubval>3, ">");
    }
    | Expression_Double T_BIGGER_OR_EQUAL Expression {
        printConditionDoubleFirst($<doubval>1, $<strval>3, ">=");
    }
    | Expression T_BIGGER_OR_EQUAL Expression_Double {
        printConditionDoubleLast($<strval>1, $<doubval>3, ">=");
    }
    | Expression_Double T_BIGGER_OR_EQUAL Expression_Double {
        printConditionDoubleAll($<doubval>1, $<doubval>3, ">=");
    }
    | Expression_Double T_MINOR Expression {
        printConditionDoubleFirst($<doubval>1, $<strval>3, "<");
    }
    | Expression T_MINOR Expression_Double {
        printConditionDoubleLast($<strval>1, $<doubval>3, "<");
    }
    | Expression_Double T_MINOR Expression_Double {
        printConditionDoubleAll($<doubval>1, $<doubval>3, "<");
    }
    | Expression_Double T_MINOR_OR_EQUAL Expression {
        printConditionDoubleFirst($<doubval>1, $<strval>3, "<=");
    }
    | Expression T_MINOR_OR_EQUAL Expression_Double {
        printConditionDoubleLast($<strval>1, $<doubval>3, "<=");
    }
    | Expression_Double T_MINOR_OR_EQUAL Expression_Double {
        printConditionDoubleAll($<doubval>1, $<doubval>3, "<=");
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
    | Some_String T_ATTRIBUTION Some_String {
        addAttribuition($<strval>1, $<strval>3, yylineno, curfilename);
        printAtribuitionNoSemicolon($<strval>1, "number/expression", $<strval>3);
    }
    | Some_String T_ATTRIBUTION Some_Int T_SEMICOLON {
        printAtribuitionNoSemicolonInt($<strval>1, "number/expression", $<intval>3);
    }
    | Some_String T_ATTRIBUTION Some_Double T_SEMICOLON {
        printAtribuitionNoSemicolonDouble($<strval>1, "number/expression", $<doubval>3);
    }
;

For_Attribution:
    Some_String T_ATTRIBUTION Some_Int {
        set_variable_for($<strval>1);
        printAtribuitionNoSemicolonIntFor($<strval>1, "number/expression", $<intval>3);
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
