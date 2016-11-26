#ifndef AUXFUNCTIONS_H
#define AUXFUNCTIONS_H

#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include "global.h"

FILE * fileOut;
int scope;
char * variable_for;

void setVariableFor(char * variable_for);
char * getVariableFor();

char * mallocNewString(char * new_text);
void incrementScope();
void decrementScope();

void printTabs();
void printBlankSpace();

void printIncludesOfProgram();
void printBeginOfProgram();
void printEndOfProgram();

void printDeclaration(char * type, type_values * value);

void printAtribuition(char * variable, type_values * value);

void printIfDeclaration(char * type);
void printWhileDeclaration(char * type);
void printRepeatDeclaration(char * type);

void printForDeclaration(char * type);
void printForAtribuition(type_values * value);
void printForScope(char * type, type_values * expression);
void printForScopeAux1();
void printForScopeAux2(type_values * expression);

void printCondition(type_values * expression1, type_values * expression2, char * condition);
void printConditionValue(type_values * expression);

void printAndOrCondition(char * type);

void printWriteDeclaration(char * type);
void printWriteDeclarationValues(type_values * expression);
void printReadDeclaration(char * type);

void printComment(char * type, char * comment);

void printCalcStatements(type_values * expression1);

void printEndStatements();

void printTypeValues(type_values * type_value);
void printTypeValues1(type_values * type_value);
void printTypeValues2(int type, void * type_value);
char * returnTypeValuesString(type_values * type_value);
int returnTypeValuesInt(type_values * type_value);
double returnTypeValuesDouble(type_values * type_value);


int convertTypeStringToTypeInt(char * type);
char * convertTypeIntToTypeString(int type);

#endif
