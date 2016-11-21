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

void printNewLine() {
	fprintf(fileOut, "\n");
}

void printIncludesOfProgram() {
	fprintf(fileOut, "#include <bits/stdc++.h>");
    printNewLine();
    printNewLine();
    fprintf(fileOut, "using namespace std;");
    printNewLine();
    printNewLine();
}

void printBeginOfProgram() {
    printNewLine();
	fprintf(fileOut, "int main() {");
    printNewLine();
}

void printEndOfProgram() {
	printNewLine();
	printTabs();
	fprintf(fileOut, "return 0;");
	printNewLine();
	fprintf(fileOut, "}");
	printNewLine();
}

void printDeclaration(char * type, char * value) {
	printTabs();
	fprintf(fileOut, "%s", type);
	printBlankSpace();
    fprintf(fileOut, "%s", value);
    fprintf(fileOut, ";");
    printNewLine();
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

    fprintf(fileOut, ";");
    printNewLine();
}

void printAtribuitionNoSemicolon(char * variable, char * type, char * value) {
	fprintf(fileOut, "%s", variable);
	printBlankSpace();
	fprintf(fileOut, "=");
	printBlankSpace();

	if (strcmp(type, "string") == 0) {
    	fprintf(fileOut, "\"%s\"", value);
	} else {
		fprintf(fileOut, "%s", value);
	}

	fprintf(fileOut, ";");
}

void printAtribuitionNoSemicolonInt(char * variable, char * type, int value) {
	printTabs();

	fprintf(fileOut, "%s", variable);
	printBlankSpace();
	fprintf(fileOut, "=");
	printBlankSpace();


	if (strcmp(type, "string") == 0) {
    	fprintf(fileOut, "\"%d\"", value);
	} else {
		fprintf(fileOut, "%d", value);
	}


	fprintf(fileOut, ";");
	printNewLine();
}

void printAtribuitionNoSemicolonDouble(char * variable, char * type, double value) {
	printTabs();

	fprintf(fileOut, "%s", variable);
	printBlankSpace();
	fprintf(fileOut, "=");
	printBlankSpace();


	if (strcmp(type, "string") == 0) {
    	fprintf(fileOut, "\"%lf\"", value);
	} else {
		fprintf(fileOut, "%lf", value);
	}


	fprintf(fileOut, ";");
	printNewLine();
}

void printIfDeclaration(char * type) {
	if (strcmp(type, "begin") == 0) {
		printTabs();
		fprintf(fileOut, "if (");
	} else {
        fprintf(fileOut, ") {");
        printNewLine();
    }
}

void printWhileDeclaration(char * type) {
	if (strcmp(type, "begin") == 0) {
		printTabs();
		fprintf(fileOut, "while (");
	} else {
        fprintf(fileOut, ") {");
        printNewLine();
    }
}

void printForDeclaration(char * type) {
	if (strcmp(type, "begin") == 0) {
		printTabs();
		fprintf(fileOut, "for (");
	} else {
        fprintf(fileOut, ") {");
        printNewLine();
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
	fprintf(fileOut, "}");
	printNewLine();
	printNewLine();
}

char * mallocNewString(char * new_text) {
	char * destination = malloc(sizeof(strlen(new_text)));
    strcpy(destination, new_text);
    return destination;
}

void printWriteDeclarationString(char * expression) {
	fprintf(fileOut, "cout << \"%s\";", expression);
}

void printWriteDeclarationVariable(char * expression) {
	fprintf(fileOut, "cout << %s;", expression);
}

void printWritelnDeclarationString(char * expression) {
	fprintf(fileOut, "cout << \"%s\" << endl;", expression);
}

void printWritelnDeclarationVariable(char * expression) {
	fprintf(fileOut, "cout << %s << endl;", expression);
}

void printReadDeclaration(char * expression) {
	fprintf(fileOut, "cin >> %s;", expression);
}
