#include "auxFunctions.h"


void incrementScope() {
	scope = scope + 1;
}
void decrementScope() {
	scope = scope - 1;
}

void setVariableFor(char * new_variable) {
	variable_for = mallocNewString(new_variable);
	strcpy(new_variable, variable_for);
}

char * getVariableFor() {
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

void printDeclaration(char * type, type_values * name) {
	printTabs();
	fprintf(fileOut, "%s", type);
	printBlankSpace();
    fprintf(fileOut, "%s", (char*)name->value);
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
        printNewLine();
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
    } else {
        fprintf(fileOut, ");");
        printNewLine();
    }
}

void printConditionString(char * expression) {
	fprintf(fileOut, "%s", expression);
}

void printConditionDouble(type_values * expression) {
	fprintf(fileOut, "%lf", ((double*)expression->value)[0]);
}

void printConditionInt(type_values * expression) {

	fprintf(fileOut, "%d", ((int*)expression->value)[0]);
}

void printConditionOne(type_values * expression) {
	if (expression->type == TYPE_STRING) {
		printConditionString((char*)expression->value);
	} else if (expression->type == TYPE_INT) {
		printConditionInt(expression);
	} else {
		printConditionDouble(expression);
	}
}

void printCondition(type_values * expression1, type_values * expression2, char * condition) {
	if (expression1->type == TYPE_STRING) {
		printConditionString((char*)expression1->value);
	} else if (expression1->type == TYPE_INT) {
		printConditionInt(expression1);
	} else {
		printConditionDouble(expression1);
	}

	fprintf(fileOut, " %s ", condition);

	if (expression2->type == TYPE_STRING) {
		printConditionString((char*)expression2->value);
	} else if (expression2->type == TYPE_INT) {
		printConditionInt(expression2);
	} else {
		printConditionDouble(expression2);
	}
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
	fprintf(fileOut, "\"%s\"", expression);
}

void printWriteDeclarationVariable(char * expression) {
	fprintf(fileOut, "%s", expression);
}

void printWriteDeclaration(char * type) {
	if (strcmp(type, "begin") == 0) {
		printTabs();
		fprintf(fileOut, "cout << ");
	} else if (strcmp(type, "endln") == 0) {
		fprintf(fileOut, " >> endl;");
		printNewLine();
	} else {
		fprintf(fileOut, ";");
		printNewLine();
	}
}

void printReadDeclaration(char * expression) {
	printTabs();
	fprintf(fileOut, "cin >> %s;", expression);
	printNewLine();
}
