#include "auxFunctions.h"


void incrementScope() {
	scope = scope + 1;
}
void decrementScope() {
	scope = scope - 1;
}

void printTabs() {
	int i;
	for (i = 0; i < scope; i++) {
		fprintf(fileOut, "\t");
	}
}

void printBlankSpace() {
	fprintf(fileOut, " ");
}

void printDeclaration(char * type, char * value) {
	printTabs();
	fprintf(fileOut, "%s", type);
	printBlankSpace();
    fprintf(fileOut, "%s", value);
    fprintf(fileOut, ";\n");
}

void printAtribuition(char * variable, char * type, char * value) {
	printTabs();
	fprintf(fileOut, "%s", variable);
	printBlankSpace();
	fprintf(fileOut, "=");
	printBlankSpace();

	if (strcmp(type, "string") == 0) {
    	fprintf(fileOut, "\"%s\"", value);
	} else {
		fprintf(fileOut, "%s", value);
	}

    fprintf(fileOut, ";\n");
}

void printIfDeclaration(char * type) {
	if (strcmp(type, "begin") == 0) {
		printTabs();
		fprintf(fileOut, "if (");
	} else {
        fprintf(fileOut, ") {\n");
    }
}

void printWhileDeclaration(char * type) {
	if (strcmp(type, "begin") == 0) {
		printTabs();
		fprintf(fileOut, "while (");
	} else {
        fprintf(fileOut, ") {\n");
    }
}

void printCondition1(char * expression) {
	fprintf(fileOut, "%s", expression);
}

void printCondition(char * expression1, char * expression2, char * condition) {
	printCondition1(expression1);
	fprintf(fileOut, " %s ", condition);
	printCondition1(expression2);
}

void printAndOrCondition(char * type) {
	if (strcmp(type, "and") == 0) {
		fprintf(fileOut, " && ");
	} else {
		fprintf(fileOut, " || ");
	}
}

void printEndStatements() {
	printTabs();
	fprintf(fileOut, "}\n");
}

char * mallocNewString(char * new_text) {
	char * destination = malloc(sizeof(strlen(new_text)));
    strcpy(destination, new_text);
    return destination;
}