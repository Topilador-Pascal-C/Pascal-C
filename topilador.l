%{
// make include
#include <ctype.h>
#include <stdlib.h>
}%

; definitions
white_espace [ \t]+
digit [0-9]
integer {digit}+
letter[A-Za-z]
exponant [eE][+-]?{integer}
real {integer}("."{integer})?{exponant}?

%%

; basic symbol
"+" return(PLUS);
"-" return(MINUS);
"*" return(TIMES);
"/" return(DIVIDE);
"^" return(POWER);
"(" return(LEFT_PARENTHESIS);
")" return(RIGHT_PARENTHESIS);
"\n" return(END);
";" return (SEMICOLON);
":" return (COLON);
"," return (COMMA);

; basic commands
"program" return (PROGRAM_STATEMENT);
"unit" return (UNIT_STATEMENT);
"uses" return (IMPORT_LIBRARIES);
"inte"
"begin" return (BEGIN);
"end." return(END_PROGRAM);
"end" return(END);
"var" return (VAR_STATEMENT);
"type" return (NEW_STATEMENT);

;  other things
"of" return (OF);

; conditions
"if" return (IF_STATEMENT);
"then" return (IF_THEN_STATEMENT);
"else" return (ELSE_STATEMENT);
"case" return (SWITCH_CASE);

; io statements
"read" return (READ);
"readln" return (READLN);
"write" return (WRITE);
"writeln" return (WRITELN);

; repeating statements
"for" return (FOR);
"to" return (TO);
"downto" return (DOWNTO);
"do" return (FOR_DO_STATEMENT); used in for
"while" return (WHILE);
"repeat" return (REPEAT);
"until" return (UNTIL);
"goto" return (GOTO);

; 