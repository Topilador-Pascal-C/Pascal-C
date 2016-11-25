#ifndef AUXFUNCTIONS_H
#define AUXFUNCTIONS_H

#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include "global.h"

FILE * fileOut;
int scope;
char * variable_for;

void setVariableFor(char * new_variable);
char * getVariableFor();

void incrementScope();
void decrementScope();

void printTabs();
void printBlankSpace();

void printIncludesOfProgram();
void printBeginOfProgram();
void printEndOfProgram();

void printDeclaration(char * type, type_values * value);
void printAtribuition(char * variable, char * type, char * value);
void printAtribuitionNoSemicolon(char * variable, char * type, char * value);
void printAtribuitionNoSemicolonInt(char * variable, char * type, int value);
void printAtribuitionNoSemicolonIntFor(char * variable, char * type, int value);
void printAtribuitionNoSemicolonDouble(char * variable, char * type, double value);

void printIfDeclaration(char * type);
void printWhileDeclaration(char * type);
void printForDeclaration(char * type, char * variable, int int_stop_point, char * str_stop_point);
void printRepeatDeclaration(char * type);

void printConditionOne(type_values * expression);
void printConditionString(char * expression);
void printConditionInt(type_values * expression);
void printConditionDouble(type_values * expression);
void printCondition(type_values * expression1, type_values * expression2, char * condition);

void printAndOrCondition(char * type);

void printWriteDeclaration(char * type);
void printWriteDeclarationString(char * expression);
void printWriteDeclarationVariable(char * expression);

void printReadDeclaration(char * expression);

void printEndStatements();

char * mallocNewString(char * new_text);

#endif
