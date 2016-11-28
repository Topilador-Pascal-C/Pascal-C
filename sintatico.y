%{
#include "global.h"
#include "symbolTable.h"
#include "auxFunctions.h"
#include "validations.h"
#include <stdlib.h> /* For malloc in symbol table */
#include <string.h> /* For strcmp in symbol table */
#include <stdio.h> /* For error messages */
#define YYDEBUG 1 /* For debugging */

/* interface to the lexer */
extern int yylineno;
extern int yyrestart();

int debugValue = 1;

// to use debugValues:
// debugValue = printDebugText(debugValue);
// {debugValue = printDebugText(debugValue);}

%}

%union { /* SEMANTIC RECORD */
    char * strval;
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

%token T_OPERATOR_PLUS
%token T_OPERATOR_MINUS
%token T_OPERATOR_MOD
%token T_OPERADOR_DIV
%token T_SLASH
%token T_ASTERISK

%token <all> T_SLASH_COMMENT
%token <all> T_BRACE_COMMENT

%token T_WRITE
%token T_WRITELN
%token T_READ
%token T_READLN

%token T_LEFT_PARENTHESIS
%token T_RIGHT_PARENTHESIS

%type <strval> Type_Of_Variable
%type <all> Some_String
%type <all> Number
%type <all> Calc_Statments

%start ProgramBegin

%left T_OPERATOR_PLUS T_OPERATOR_MINUS
%left T_SLASH T_ASTERISK

%%

Variable:
    T_SOME_WORD
;

Some_String:
    T_SOME_TEXT
    | T_APOSTROPHE T_SOME_WORD T_APOSTROPHE {
        $$ = $<all>2;
    }
;

Number:
    T_INT_NUMBER
    | T_DOUBLE_NUMBER
;

Expression:
    Variable
    | Some_String
    | Number
    | Calc_Statments
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
    | Read_Statement
    | Repeat_Until_Statement
    | Comment_Statement
;

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

Declaration_Of_Variables:
    Declaration_Of_Variable
    | Declaration_Of_Variables Declaration_Of_Variable
;

Declaration_Of_Variable:
    T_VAR_STATEMENT Variable T_COLON Type_Of_Variable T_SEMICOLON {
        if (validateDeclaration($4, $<all>2, yylineno, curfilename)) {
            printDeclaration($4, $<all>2);
        }
    }
    | Variable T_COLON Type_Of_Variable T_SEMICOLON {
        if (validateDeclaration($3, $<all>1, yylineno, curfilename)) {
            printDeclaration($3, $<all>1);
        }
    }
;

Attribuition:
    Variable T_ATTRIBUTION Expression T_SEMICOLON {
        if (validateAtribuition($<all>1->value, $<all>3, yylineno, curfilename)) {
            printAtribuition($<all>1->value, $<all>3);
        }
    }
;

For_Statement:
    T_FOR_STATEMENT {
        printForDeclaration("begin");
    } For_Complementation {
        printForDeclaration("end");
    } Statement_Complementation
;

For_Complementation:
    For_Attribuition T_TO_STATEMENT Expression {
        printForScope("<", $<all>3);
        incrementScope();
    } T_DO_STATEMENT
    | For_Attribuition T_DOWNTO_STATEMENT Expression {
        printForScope(">", $<all>3);
        incrementScope();
    } T_DO_STATEMENT
;

For_Attribuition:
    Variable T_ATTRIBUTION Expression {
        setVariableFor($<all>1->value);
        printForAtribuition($<all>3);
    }
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
    T_LEFT_PARENTHESIS Expression T_RIGHT_PARENTHESIS T_SEMICOLON {
        printWriteDeclarationValues($<all>2);
    }
;

Read_Statement:
    T_READ  Read_Statement_Complement
    | T_READLN Read_Statement_Complement
;

Read_Statement_Complement:
    T_LEFT_PARENTHESIS Variable T_RIGHT_PARENTHESIS T_SEMICOLON {
        printReadDeclaration($<all>3->value);
    }
;

Comment_Statement:
    T_SLASH_COMMENT {
        printComment("slash", $<all>1->value);
    }
    | T_BRACE_COMMENT {
        printComment("brace_asterisk", $<all>1->value);
    }
;

Calc_Statments:
    Number
    | Number T_OPERATOR_PLUS Calc_Statments {
        type_values * returnCalc = validationCalculator($<all>1, $<all>3, "+", yylineno, curfilename);
        $$ = returnCalc;
    }
    | Number T_OPERATOR_MINUS Calc_Statments {
        type_values * returnCalc = validationCalculator($<all>1, $<all>3, "-", yylineno, curfilename);
        $$ = returnCalc;
    } 
    | Number T_SLASH Calc_Statments {
        type_values * returnCalc = validationCalculator($<all>1, $<all>3, "/", yylineno, curfilename);
        $$ = returnCalc;
    } 
    | Number T_ASTERISK Calc_Statments {
        type_values * returnCalc = validationCalculator($<all>1, $<all>3, "*", yylineno, curfilename);
        $$ = returnCalc;
    } 
    | Number T_OPERATOR_MOD Calc_Statments {
        type_values * returnCalc = validationCalculator($<all>1, $<all>3, "mod", yylineno, curfilename);
        $$ = returnCalc;
    } 
    | Number T_OPERADOR_DIV Calc_Statments {
        type_values * returnCalc = validationCalculator($<all>1, $<all>3, "div", yylineno, curfilename);
        $$ = returnCalc;
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
        printConditionValue($<all>1);
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
            errors = 0;
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
                printf("------------------------------------------\n");

                char outfilename [10];
                sprintf(outfilename, "%s.cpp", fileName);

                fileOut = fopen(outfilename, "w");
                yyparse();
                fclose(fileOut);

                printf("------------------------------------------\n");
                if (errors != 0) {
                    remove(outfilename);
                    printf("%sFALHA:%s ", COLOR_RED, COLOR_RESET);
                    printf("Arquivo %s não compilado devido aos problemas.\n", curfilename);
                } else {
                    printf("%sCONCLUIDO:%s ", COLOR_GRN, COLOR_RESET);
                    printf("Arquivo compilado e resultado em %s\n", outfilename);
                }

                printf("\n\n");
                fclose(f);
            }
        }
    }

    // printf("\n\n----------------------\n");
    // printf("Print of symbol table! \n\n");
    // printSymbolTable();
    // printf("----------------------\n");

    return 1;
}

void yyerror(const char* errmsg) {
    printf("\n*** Erro: %s\n", errmsg);
    errors = errors + 1;
}
