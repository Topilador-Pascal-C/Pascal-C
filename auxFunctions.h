#ifndef AUXFUNCTIONS_H
#define AUXFUNCTIONS_H

#include <stdlib.h>
#include <string.h>
#include <stdio.h>

FILE * fileOut;
int scope;

void incrementScope();
void decrementScope();

void printBlankSpace();
void printDeclaration(char * type, char * value);
void printAtribuition(char * variable, char * type, char * value);

void printIfDeclaration(char * type);
void printIfCondition();

void printWhileDeclaration(char * type);
void printWhileCondition();

void printEndStatements();

#endif