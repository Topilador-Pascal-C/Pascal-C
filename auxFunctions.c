#include "auxFunctions.h"


void incrementScope() {
	scope = scope + 1;
}
void decrementScope() {
	scope = scope - 1;
}

void set_variable_for(char * new_variable) {
	variable_for = mallocNewString(new_variable);
	strcpy(new_variable, variable_for);
}

char * get_variable_for() {
	return variable_for;
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
	printNewLine();
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

void printAtribuitionNoSemicolonIntFor(char * variable, char * type, int value) {
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

void printForDeclaration(char * type, char * variable, int int_stop_point, char * str_stop_point) {
	if (strcmp(type, "begin") == 0) {
		printTabs();
		fprintf(fileOut, "for (");
	} else if (strcmp(type, "condition_to_int") == 0) {
		fprintf(fileOut, " %s < %d;", variable, int_stop_point);
	} else if (strcmp(type, "condition_to_str") == 0) {
		fprintf(fileOut, " %s < %s;", variable, str_stop_point);
	} else if (strcmp(type, "condition_downto_int") == 0) {
		fprintf(fileOut, " %s > %d;", variable, int_stop_point);
	} else if (strcmp(type, "end_to") == 0) {
        fprintf(fileOut, " %s++) {", variable);
        printNewLine();
    } else if (strcmp(type, "end_downto") == 0) {
        fprintf(fileOut, " %s--) {", variable);
    }
}

void printRepeatDeclaration(char * type) {
	if (strcmp(type, "begin") == 0) {
		printTabs();
		fprintf(fileOut, "do {");
		printNewLine();
	} else if (strcmp(type, "before_end") == 0) {
		printTabs();
        fprintf(fileOut, "} while (");
    } else if (strcmp(type, "after_end") == 0) {
        fprintf(fileOut, ");");
        printNewLine();
    }
}

void printCondition1(char * expression) {
	fprintf(fileOut, "%s", expression);
}

void printConditionInt(int expression) {
	fprintf(fileOut, "%d", expression);
}

void printConditionDouble(double expression) {
	fprintf(fileOut, "%lf", expression);
}

void printCondition(char * expression1, char * expression2, char * condition) {
	printCondition1(expression1);
	fprintf(fileOut, " %s ", condition);
	printCondition1(expression2);
}

void printConditionIntFirst(int expression1, char * expression2, char * condition) {
	printConditionInt(expression1);
	fprintf(fileOut, " %s ", condition);
	printCondition1(expression2);
}

void printConditionIntLast(char * expression1, int expression2, char * condition) {
	printCondition1(expression1);
	fprintf(fileOut, " %s ", condition);
	printConditionInt(expression2);
}

void printConditionIntAll(int expression1, int expression2, char * condition) {
	printConditionInt(expression1);
	fprintf(fileOut, " %s ", condition);
	printConditionInt(expression2);
}

void printConditionDoubleFirst(double expression1, char * expression2, char * condition) {
	printConditionDouble(expression1);
	fprintf(fileOut, " %s ", condition);
	printCondition1(expression2);
}

void printConditionDoubleLast(char * expression1, double expression2, char * condition) {
	printCondition1(expression1);
	fprintf(fileOut, " %s ", condition);
	printConditionDouble(expression2);
}

void printConditionDoubleAll(double expression1, double expression2, char * condition) {
	printConditionDouble(expression1);
	fprintf(fileOut, " %s ", condition);
	printConditionDouble(expression2);
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
}

char * mallocNewString(char * new_text) {
	char * destination = malloc(sizeof(strlen(new_text)));
    strcpy(destination, new_text);
    return destination;
}

void printWriteDeclarationString(char * expression) {
	printTabs();
	fprintf(fileOut, "cout << \"%s\";", expression);
	printNewLine();
}

void printWriteDeclarationVariable(char * expression) {
	printTabs();
	fprintf(fileOut, "cout << %s;", expression);
	printNewLine();
}

void printWritelnDeclarationString(char * expression) {
	printf("Testando...\n");
	printTabs();
	fprintf(fileOut, "cout << \"%s\" << endl;", expression);
	printNewLine();
}

void printWritelnDeclarationVariable(char * expression) {
	printTabs();
	fprintf(fileOut, "cout << %s << endl;", expression);
	printNewLine();
}

void printReadDeclaration(char * expression) {
	printTabs();
	fprintf(fileOut, "cin >> %s;", expression);
	printNewLine();
}
