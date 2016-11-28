#ifndef VALIDATIONS_H
#define VALIDATIONS_H
#include "global.h"
#define COLOR_RED  "\x1B[01;31m"
#define COLOR_CYN  "\x1B[01;36m"
#define COLOR_GRN  "\x1B[01;32m"
#define COLOR_RESET "\x1B[0m"

int validateDeclaration(char * type, type_values * variable, int line, char * filename);
int validateAtribuition(char * variable, type_values * value, int line, char * filename);
type_values * validationCalculator(type_values * value1, type_values * value2, char * type);

int calculateInteger(int * value1, int * value2, char * type);
double calculateDouble(double * value1, double * value2, char * type);

void printWarning(char * code);
void printError(char * code);

#endif