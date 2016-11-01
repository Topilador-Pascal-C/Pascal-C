#ifndef __COMMON_H__
#define __COMMON_H__

extern int yylex();
extern int yyparse();
extern void yyerror(const char* s);
/* Name of current input file */
char * curfilename;
char * fileName;

#endif
