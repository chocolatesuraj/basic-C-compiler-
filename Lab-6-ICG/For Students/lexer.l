%{
    #define YYSTYPE char*
    #include <unistd.h>
    #include "y.tab.h"
    #include <stdio.h>
    extern void yyerror(const char *); // declare the error handling function
	extern char* yylval;
%}

/* Regular definitions */
digit	[0-9]
letter	[a-zA-Z]
id	{letter}({letter}|{digit})*
digits	{digit}+
opFraction	(\.{digits})?
opExponent	([Ee][+-]?{digits})?
number	{digits}{opFraction}{opExponent}
%option yylineno

%%
\/\/(.*) ; // ignore comments



"if"            {return IF;}
"else"          {return ELSE;}
"while"         {return WHILE;}
"do"            {return DO;}
"int"            {return T_INT;}
"char"            {return T_CHAR;}
"float"            {return T_FLOAT;}
"double"            {return T_DOUBLE;}
"main"            {return MAIN;}

{number}	{
			yylval = strdup(yytext);  //stores the value of the number to be used later for symbol table insertion
			return T_NUM;
		}
{id}        	{
					yylval = strdup(yytext); //stores the identifier to be used later for symbol table insertion
					return T_ID;
				}
[ \t\n] ; // ignore whitespaces
.		{return *yytext;} // anything else => ignore
%%
