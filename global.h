#ifndef __COMMON_H__
#define __COMMON_H__

#define TYPE_STRING 0
#define TYPE_INT 1
#define TYPE_DOUBLE 2

extern int yylex();
extern int yyparse();
extern void yyerror(const char* s);
/* Name of current input file */
char * curfilename;
char * fileName;

typedef struct type_values {
    int type;
    void * value;
} type_values;

#endif
