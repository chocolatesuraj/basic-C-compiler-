%{
	#include "quad_generation.c"
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>

	#define YYSTYPE char*

	void yyerror(char* s); // error handling function
	int yylex(); 	// declare the function performing lexical analysis
	extern int yylineno; // track the line number

	FILE* icg_quad_file;
	int temp_no = 1;
	int label_no = 1;
    char* l1;
    char* l2;
    char* l3="0";
    int a=0;

    #define MAX_STACK_SIZE 100
char* label_stack[MAX_STACK_SIZE];
int top = -1;
    
    void push(char* label) {
    if (top == MAX_STACK_SIZE - 1) {
        printf("Stack Overflow\n");
        return;
    }
    label_stack[++top] = label;
}

char* pop() {
    if (top == -1) {
        printf("Stack Underflow\n");
        return NULL;
    }
    return label_stack[top--];
}
%}


%token T_ID T_NUM IF ELSE DO WHILE T_INT T_FLOAT T_DOUBLE T_CHAR MAIN

/* specify start symbol */
%start START


%%
START : Main { printf("Valid syntax\n");YYACCEPT;}

Main : Type MAIN '(' ')' '{' S '}'
    ;

Type : T_INT
     | T_FLOAT
     | T_DOUBLE
     | T_CHAR
     ;

S : IF '(' Cond ')'{
        l1=new_label();
        quad_code_gen("if",$3,"goto",l1);
        l2=new_label();
        quad_code_gen("","","goto",l2);
        push(l2); 
        fprintf(icg_quad_file,"%s:\n",l1);
    }'{' S '}'
    Else

    | DO{
        l1=new_label();
        fprintf(icg_quad_file,"%s:\n",l1);
    }
    '{' S '}' WHILE '(' Cond ')'{
        quad_code_gen("if",$8,"goto",l1);
    } ';' S
    | ASSGN ';' S
    |
    ;
Else : ELSE {
    char* l3 = new_label();
    fprintf(icg_quad_file, "%s:\n", pop());
    push(l3);
    quad_code_gen("", "", "goto", l3);
} '{' S '}' {
    fprintf(icg_quad_file, "%s:\n", pop());
} S
| {
    fprintf(icg_quad_file, "%s:\n", pop());
} S
;

Cond : E '>' E {$$=new_temp();quad_code_gen($$,$1,">",$3);}
    | E '<' E {$$=new_temp();quad_code_gen($$,$1,"<",$3);}
    | E '>''=' E {$$=new_temp();quad_code_gen($$,$1,">=",$3);}
    | E '<''=' E {$$=new_temp();quad_code_gen($$,$1,"<=",$3);}
    | E '=''=' E {$$=new_temp();quad_code_gen($$,$1,"==",$3);}
    | E '!''=' E {$$=new_temp();quad_code_gen($$,$1,"!=",$3);}
	;



/* Grammar for assignment */
ASSGN : T_ID '=' E {$$=strdup($1),quad_code_gen($$,$3,strdup(" "),strdup(" "));}
	;

/* Expression Grammar */
E : E '+' T {$$=new_temp();quad_code_gen($$,$1,strdup("+"),$3);}		
	| E '-' T {$$=new_temp();quad_code_gen($$,$1,strdup("-"),$3);}
	|T
	;
	
	
T : T '*' F {$$=new_temp();quad_code_gen($$,$1,strdup("*"),$3);}
	| T '/' F {$$=new_temp();quad_code_gen($$,$1,strdup("/"),$3);}
	| F
	;

F : '(' E ')' 	{$$=$2;}	
	| T_ID 		{$$=strdup($1);}
	| T_NUM 	{$$=strdup($1);}
	;

%%


/* error handling function */
void yyerror(char* s)
{
	printf("Error :%s at %d \n",s,yylineno);
}


/* main function - calls the yyparse() function which will in turn drive yylex() as well */
int main(int argc, char* argv[])
{
	icg_quad_file = fopen("icg_quad.txt","w");
	yyparse();
	fclose(icg_quad_file);
	return 0;
}