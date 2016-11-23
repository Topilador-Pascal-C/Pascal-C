#ifndef AUXFUNCTIONS_H
#define AUXFUNCTIONS_H

#include <stdlib.h>
#include <string.h>
#include <stdio.h>

FILE * fileOut;
int scope;
char * variable_for;

void set_variable_for(char * new_variable);
char * get_variable_for();

void incrementScope();
void decrementScope();

void printTabs();
void printBlankSpace();

void printIncludesOfProgram();
void printBeginOfProgram();
void printEndOfProgram();

void printDeclaration(char * type, char * value);
void printAtribuition(char * variable, char * type, char * value);
void printAtribuitionNoSemicolon(char * variable, char * type, char * value);
void printAtribuitionNoSemicolonInt(char * variable, char * type, int value);
void printAtribuitionNoSemicolonIntFor(char * variable, char * type, int value);
void printAtribuitionNoSemicolonDouble(char * variable, char * type, double value);

void printIfDeclaration(char * type);
void printWhileDeclaration(char * type);
void printForDeclaration(char * type, char * variable, int int_stop_point, char * str_stop_point);
void printRepeatDeclaration(char * type);

void printCondition1(char * expression);
void printConditionInt(int expression);
void printConditionDouble(double expression);

void printCondition(char * expression1, char * expression2, char * condition);

void printConditionIntFirst(int expression1, char * expression2, char * condition);
void printConditionIntLast(char * expression1, int expression2, char * condition);
void printConditionIntAll(int expression1, int expression2, char * condition);

void printConditionDoubleFirst(double expression1, char * expression2, char * condition);
void printConditionDoubleLast(char * expression1, double expression2, char * condition);
void printConditionDoubleAll(double expression1, double expression2, char * condition);

void printAndOrCondition(char * type);

void printWriteDeclaration(char * type);
void printWriteDeclarationString(char * expression);
void printWriteDeclarationVariable(char * expression);

void printReadDeclaration(char * expression);

void printEndStatements();

char * mallocNewString(char * new_text);

#endif
