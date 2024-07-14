%{
#include <stdio.h>
#include <string.h>
%}

letter [a-zA-Z]
digit  [0-9]
id     {letter}({letter}|{digit})*

%%

{id} {
    printf("ID\n");
}
.* {
    printf("other\n");
}

%%


int yywrap() {
    return 1; 
}

/*
int main() {
    yylex();
    return 0;
}
*/
