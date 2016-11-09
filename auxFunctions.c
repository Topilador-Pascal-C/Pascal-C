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
void printIfCondition() {

}

void printWhileDeclaration(char * type) {
	if (strcmp(type, "begin") == 0) {
		printTabs();
		fprintf(fileOut, "while (");
	} else {
        fprintf(fileOut, ") {\n");
    }
}
void printWhileCondition() {

}

void printEndStatements() {
	printTabs();
	fprintf(fileOut, "}\n");
}