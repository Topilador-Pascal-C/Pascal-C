#include "validations.h"
#include "symbolTable.h"
#include "auxFunctions.h"

int validateDeclaration(char * type, type_values * variable, int line, char * filename) {

	int returnValidate = 0;
	if (searchIdentifier(variable->value) != NULL) {
		printWarning("W01");
		printf("Declaration of variable %s already exist in file %s in line %d.\n", (char*) variable->value, filename, line);
		returnValidate = 0;
	} else {
		addNewVariable(variable, type, line, filename);
		returnValidate = 1;
	}
	return returnValidate;
}

int validateAtribuition(char * variable, type_values * value, int line, char * filename) {

	int returnValidate = 0;
	symbol * sp = searchIdentifier(variable);

	if (sp == NULL) {
		printError("E01");
		printf("Atribuition in not declarated variable %s. File %s in line %d.\n", variable, filename, line);
		returnValidate = 0;
		errors = errors + 1;

	} else if (sp->type != value->type) {
		printError("E02");
		printf("Atribuition in variable %s of diferent type. File %s in line %d.\n", variable, filename, line);
		returnValidate = 0;
		errors = errors + 1;

	} else {

		addAttribuition(variable, value, line, filename);
		returnValidate = 1;
	}
	return returnValidate;
}

type_values * validationCalculator(type_values * value1, type_values * value2, char * type, int line, char * filename) {
	type_values * returnCalculator;

	if (value1->type == value2->type) {
		returnCalculator = (type_values*) malloc(sizeof(type_values));
		returnCalculator->type = value1->type;

		if (value1->type == TYPE_INT) {
			int * value = malloc(sizeof(int));
			*value = calculateInteger((int*) value1->value, (int*) value2->value, type);
			returnCalculator->value = (int*) value;
		} else {
			double * value = malloc(sizeof(double));
			*value = calculateDouble((double*) value1->value, (double*) value2->value, type);
			returnCalculator->value = (double*) value;
		}

	} else {
		returnCalculator = (type_values*) malloc(sizeof(type_values));
		returnCalculator->type = TYPE_INT;

		int * value = malloc(sizeof(int));
		* value = 0;
		returnCalculator->value = (int*) value;

		printError("E03");
		printf("Calculator invalid of different types. File %s in line %d.\n", filename, line);
		errors = errors + 1;
	}

	return returnCalculator;
}

int calculateInteger(int * value1, int * value2, char * type) {
	int returnCalc = 0;
	if (!strcmp(type, "+")) {
		returnCalc = *value1 + *value2;
	} else if (!strcmp(type, "-")) {
		returnCalc = *value1 - *value2;
	} else if (!strcmp(type, "*")) {
		returnCalc = *value1 * *value2;
	} else if (!strcmp(type, "mod")) {
		returnCalc = *value1 % *value2;
	} else if (!strcmp(type, "div")) {
		returnCalc = *value1 / *value2;
	} else {
		returnCalc = 0;
	}
	return returnCalc;
}

double calculateDouble(double * value1, double * value2, char * type) {
	double returnCalc = 0.0;
	if (!strcmp(type, "+")) {
		returnCalc = *value1 + *value2;
	} else if (!strcmp(type, "-")) {
		returnCalc = *value1 - *value2;
	} else if (!strcmp(type, "*")) {
		returnCalc = *value1 * *value2;
	} else if (!strcmp(type, "/")) {
		returnCalc = *value1 / *value2;
	} else {
		returnCalc = 0.0;
	}
	return returnCalc;
}

void printWarning(char * code) {
	printf("%sWARNING[%s]: %s", COLOR_CYN, code, COLOR_RESET);
}

void printError(char * code) {
	printf("%sERROR[%s]: %s", COLOR_RED, code, COLOR_RESET);
}