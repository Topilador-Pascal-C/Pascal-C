#include "auxFunctions.h"

void printBlankSpace() {
	fprintf(fileOut, " ");
}

void printDeclaration(char * type, char * value) {
	fprintf(fileOut, "%s", type);
	printBlankSpace();
    fprintf(fileOut, "%s", value);
    fprintf(fileOut, ";\n");
}

void printAtribuition(char * variable, char * type, char * value) {
	fprintf(fileOut, "%s", variable);
	printBlankSpace();
	fprintf(fileOut, "=");
	printBlankSpace();

	printf("teste: %s\n", type);

	if (strcmp(type, "string") == 0) {
    	fprintf(fileOut, "\"%s\"", value);
	} else {
		fprintf(fileOut, "%s", value);
	}

    fprintf(fileOut, ";\n");
}