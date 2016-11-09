#ifndef AUXFUNCTIONS_H
#define AUXFUNCTIONS_H

#include <stdlib.h>
#include <string.h>
#include <stdio.h>

FILE * fileOut;

void printBlankSpace();
void printDeclaration(char * type, char * value);
void printAtribuition(char * variable, char * type, char * value);

#endif