%{
#define YYSTYPE char*
#include <unistd.h>
#include "y.tab.h"
#include <stdio.h>
extern void yyerror(const char *); // declare the error handling function
%}

/* Regular definitions */
digit [0-9]
letter [a-zA-Z]
id {letter}({letter}|{digit})*
digits {digit}+
opFraction (\.{digits})?
opExponent ([Ee][+-]?{digits})?
number {digits}{opFraction}{opExponent}

%option yylineno
%%

\/\/(.*)    ; // ignore comments
[\t\n]      ; // ignore whitespaces
"int"         { return INT; }
"main"         { return MAIN; }
"("         { return '('; }
"}"         { return '}'; }
"{"         { return '{'; }
")"         { return ')'; }
"."         { return '.'; }
","         { return ','; }
"*"         { return '*'; }
"+"         { return '+'; }
";"         { return ';'; }
"-"         { return '-'; }
"/"         { return '/'; }
"="         { return '='; }
">"         { return '>'; }
"<"         { return '<'; }
"if"        { return T_IF; }
"else"      { return T_ELSE; }
"do"        { return T_DO; }
"while"     { return T_WHILE; }
{number}    { yylval = strdup(yytext); return T_NUM; }
{id}        { yylval = strdup(yytext); return T_ID; }
.           ; // anything else => ignore

%%