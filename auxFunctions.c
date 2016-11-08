#include "auxFunctions.h"

void printDeclarations(char * type, char * value) {
	fprintf(fileOut, "%s ", type);
    fprintf(fileOut, "%s", value);
    fprintf(fileOut, ";\n");
}