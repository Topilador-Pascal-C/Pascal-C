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

void printWarning(char * code) {
	printf("%sWARNING[%s]: %s", COLOR_CYN, code, COLOR_RESET);
}

void printError(char * code) {
	printf("%sERROR[%s]: %s", COLOR_RED, code, COLOR_RESET);
}