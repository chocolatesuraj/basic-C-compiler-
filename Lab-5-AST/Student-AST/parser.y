%{
#include "abstract_syntax_tree.c"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(char* s);
int yylex();
extern int yylineno;
%}

%union {
    char* text;
    expression_node* exp_node;
}

%token <text> T_ID T_NUM T_IF T_ELSE T_DO T_WHILE INT MAIN
%type <exp_node> E T F ASSGN STMT STMT_LIST IF_STMT IF_ELSE_STMT DO_WHILE_STMT Block
%start START

%%

START :INT MAIN '(' ')' '{' STMT_LIST '}'   { printf("Valid syntax\n"); display_exp_tree($6); YYACCEPT; }
     ;

STMT_LIST : STMT  { $$ = $1; }
          | Block { $$ = $1; }
          | STMT_LIST STMT  { $$ = init_exp_node(strdup(","), $1, $2); }
          ;

Block : '{' STMT_LIST '}' { $$ = $2;}
      ;

STMT : ASSGN ';' { $$ = $1; }
     | IF_STMT { $$ = $1; }
     | IF_ELSE_STMT { $$ = $1; }
     | DO_WHILE_STMT { $$ = $1; }
     ;

ASSGN : T_ID '=' E { $$ = init_exp_node(strdup("="), init_exp_node(strdup($1), NULL, NULL), $3); }
      ;

E : E '+' T { $$ = init_exp_node(strdup("+"), $1, $3); }
  | E '-' T { $$ = init_exp_node(strdup("-"), $1, $3); }
  | E '>' T { $$ = init_exp_node(strdup(">"), $1, $3); }
  | E '<' T { $$ = init_exp_node(strdup(">"), $1, $3); }
  | T { $$ = $1; }
  ;

T : T '*' F { $$ = init_exp_node(strdup("*"), $1, $3); }
  | T '/' F { $$ = init_exp_node(strdup("/"), $1, $3); }
  | F { $$ = $1; }
  ;

F : '(' E ')' { $$ = $2; }
  | T_ID { $$ = init_exp_node(strdup($1), NULL, NULL); }
  | T_NUM { $$ = init_exp_node(strdup($1), NULL, NULL); }
  ;

IF_STMT : T_IF '(' E ')' Block { $$ = init_exp_node(strdup("if"), $3, $5); }
        ;

IF_ELSE_STMT : T_IF '(' E ')' STMT_LIST T_ELSE Block { $$ = init_exp_node(strdup("if-else"), $3, init_exp_node(strdup(","), $5, $7)); }
             ;

DO_WHILE_STMT : T_DO Block T_WHILE '(' E ')' { $$ = init_exp_node(strdup("do-while"), $5, $2); }
              ;

%%

void yyerror(char* s) {
    printf("Error :%s at %d \n", s, yylineno);
}

int main(int argc, char* argv[]) {
    yyparse();
    return 0;
}