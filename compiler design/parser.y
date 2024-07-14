%{
#include "sym_tab.c"
#include <stdio.h>
#include <string.h>
void yyerror(const char *str)
{
    printf(stderr, "error: %s\n", str);
}



%}

%token ID INT FLOAT IF WHILE REL

%%
P : Stmt {printf("valid syntax"); YYACCEPT;}
    ;
Stmt:Declr
    | IF '(' Cond ')' '{' Stmt '}'
    | WHILE '(' Cond ')' '{' Stmt '}'
    ;
Cond : ID REL ID
    ;
Declr :ID
    ;
Type : INT
    | FLOAT
    ;
ListVar : ID
        | ID ',' ListVar
        ;
ifstmt : 'if'

%%

int main()
{
    printf("Enter inputtt:\n");
    printf("parser tesing 2");

    if (!yyparse())
    {
        printf("Successful parsing\n");
    }
    else
    {
        printf("Parsing failed\n");
    }
    printf("parser tesing 2");

    return 0;
}
