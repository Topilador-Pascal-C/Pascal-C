%{
#include "common.h"
#include <stdio.h>
%}
 
%token T_STRING
%token T_DIGIT
%token T_SELECT
%token T_FROM
 
%error-verbose
 
%%
 
stmt:
   select_stmt
;
 
field_list:
      field
   |  field_list ',' field
;
 
field:
      T_STRING
   |  '`' T_STRING '`'
;
 
select_stmt:
      T_SELECT field_list T_FROM
;
 
%%
 
void yyerror(const char* errmsg)
{
   printf("\n*** Erro: %s\n", errmsg);
}
 
int yywrap(void) { return 1; }
 
int main(int argc, char** argv)
{
     yyparse();
     return 0;
}
