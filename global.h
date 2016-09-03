#ifndef __COMMON_H__
#define __COMMON_H__
#define YYSTYPE double
extern YYSTYPE yylval;

extern int yylex(); 
extern int yyparse(); 
extern void yyerror(const char* s);
 
#endif
