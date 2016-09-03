/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_SINTATICO_H_INCLUDED
# define YY_YY_SINTATICO_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    NUMBER = 258,
    PLUS = 259,
    MINUS = 260,
    TIMES = 261,
    DIVIDE_REAL = 262,
    DIVIDE_INTEGER = 263,
    POWER = 264,
    LEFT_PARENTHESIS = 265,
    RIGHT_PARENTHESIS = 266,
    ATTRIBUTION = 267,
    SEMICOLON = 268,
    COLON = 269,
    COMMA = 270,
    EQUAL = 271,
    DIFFERENT = 272,
    BIGGER = 273,
    BIGGER_OR_EQUAL = 274,
    MINOR = 275,
    MINOR_OR_EQUAL = 276,
    MOD = 277,
    AND_STATEMENT = 278,
    OR_STATEMENT = 279,
    XOR = 280,
    END = 281,
    END_PROGRAM = 282,
    PROGRAM_STATEMENT = 283,
    UNIT_STATEMENT = 284,
    IMPORT_LIBRARIES = 285,
    BEGIN = 286,
    VAR_STATEMENT = 287,
    NEW_STATEMENT = 288,
    BREAK = 289,
    CONST = 290,
    CONTINUE = 291,
    IMPLEMENTATION = 292,
    INHERITED = 293,
    INLINE = 294,
    INTERFACE = 295,
    NULL_STATEMENT = 296,
    NOT = 297,
    FILE_DECLARATION = 298,
    RESET = 299,
    REWRITE = 300,
    ASSIGN = 301,
    CLOSE = 302,
    STRING_STATEMENT = 303,
    FALSE = 304,
    TRUE = 305,
    ARRAY = 306,
    BOOLEAN = 307,
    CHAR = 308,
    OBJECT = 309,
    RECORD = 310,
    INTEGER_STATEMENT = 311,
    BYTE = 312,
    SHORTINT = 313,
    SMALLINT = 314,
    WORD = 315,
    CARDINAL = 316,
    LONGINT = 317,
    LONGWORD = 318,
    INT64 = 319,
    QWORD = 320,
    REAL = 321,
    DOUBLE = 322,
    SINGLE = 323,
    EXTENDED = 324,
    COMP = 325,
    CURRENCY = 326,
    FUNCTION = 327,
    PROCEDURE = 328,
    CONSTRUCTOR = 329,
    DESTRUCTOR = 330,
    IN = 331,
    ON = 332,
    OF = 333,
    WITH = 334,
    IF_STATEMENT = 335,
    IF_THEN_STATEMENT = 336,
    ELSE_STATEMENT = 337,
    SWITCH_CASE = 338,
    FOR = 339,
    TO = 340,
    DOWNTO = 341,
    FOR_DO_STATEMENT = 342,
    WHILE = 343,
    REPEAT = 344,
    UNTIL = 345,
    GOTO = 346,
    ASM = 347,
    LABEL = 348,
    OPERATOR = 349,
    PACKED = 350,
    REINTRODUCE = 351,
    SELF = 352,
    SET = 353,
    SHL = 354,
    SHR = 355
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_SINTATICO_H_INCLUDED  */
