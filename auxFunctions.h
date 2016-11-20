#ifndef AUXFUNCTIONS_H
#define AUXFUNCTIONS_H

#include <stdlib.h>
#include <string.h>
#include <stdio.h>

FILE * fileOut;
int scope;

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
void printAtribuitionNoSemicolonDouble(char * variable, char * type, double value);

void printIfDeclaration(char * type);
void printWhileDeclaration(char * type);
void printForDeclaration(char * type);

void printCondition1(char * expression);
void printCondition(char * expression1, char * expression2, char * condition);
void printAndOrCondition(char * type);

void printEndStatements();

char * mallocNewString(char * new_text);

#endif