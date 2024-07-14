%{
	#include "sym_tab.c"
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#define YYSTYPE char* //to change type of yylval
	int type=-1;	//initial declaration of type for symbol table
	int vtype=-1;	//initial declaration for type checking for symbol table
	int scope=0;	//initial declaration for scope
	void yyerror(char* s); // error handling function
	int yylex(); // declare the function performing lexical analysis
	extern int yylineno; // track the line number

%}
/* declare tokens */
%token T_INT T_CHAR T_DOUBLE T_FLOAT T_STRLITERAL T_MAIN T_ID T_NUM

/* specify start symbol */
%start START

%%
START : PROG { printf("Valid syntax\n"); YYACCEPT; }	

PROG :  MAIN 				/* main function  */
	| 					/* end of program */
	;

/* Grammar for main function */
MAIN : T_INT T_MAIN '(' ')' '{' {scope++;} STMT '}' {scope--;};//when u go in curly bracket you increment the scope

/* statements can be standalone, or parts of blocks */
STMT : DECLR ';' STMT
       | ASSGN ';' STMT
       | BLOCK STMT
       |
       ;

BLOCK : '{' {scope++;} STMT '}' {scope--;};//we can put the rules for SDD here also

/* Grammar for variable declaration */
DECLR : TYPE LISTVAR 
	;	/* always terminate with a ; */


LISTVAR : LISTVAR ',' VAR 
	  | VAR
	  ;
//$3 refers to val E
VAR: T_ID '=' E {//here we write the semantic rules for the SDD
	if(check_sym_tab($1)){
		printf("variable %s already declared\n",$1);
		yyerror($1);

	}
	else{
		insert_symbol($1,size(type),type,yylineno,scope);
		insert_val($1,$3,yylineno);
	}

}
     | T_ID {//here we write the semantic rules for the SDD
	if(check_sym_tab($1)){
		printf("variable %s already declared\n",$1);
		yyerror($1);

	}
	else{
		insert_symbol($1,size(type),type,yylineno,scope);
	}

} 	
	
TYPE : T_INT {type = INT;}		//INT=2
       | T_FLOAT {type = FLOAT;}	//FLOAT=3
       | T_DOUBLE {type = DOUBLE;}	//DOUBLE=4
       | T_CHAR {type = CHAR;}		//CHAR=1
       ;
    
/* Grammar for assignment */   
ASSGN : T_ID '=' E {//here we write the semantic rules for the SDD
	if(check_sym_tab($1)){
		insert_val($1,$3,yylineno);
	}
	else{
		printf("variable %s not declared\n",$1);
		yyerror($1);
	}

}
	;

/* Expression Grammar */	   
E : E '+' T {
	if(vtype==2)//int
	{
		sprintf($$,"%d",(atoi($1)+atoi($3)));//wont print anything it will store result in $$

	}
	else if(vtype==3)//int
	{
		sprintf($$,"%f",(atof($1)+atof($3)));

	}
	else{
		printf("character used in arithmetic operation\n");
		yyerror($$);
		$$="~";
	}
}
    | E '-' T {
	if(vtype==2)//int
	{
		sprintf($$,"%d",(atoi($1)-atoi($3)));//wont print anything it will store result in $$

	}
	else if(vtype==3)//int
	{
		sprintf($$,"%f",(atof($1)-atof($3)));

	}
	else{
		printf("character used in arithmetic operation\n");
		yyerror($$);
		$$="~";
	}
}
    | T 
    ;
	
	
T : T '*' F 	
    | T '/' F 	
    | F 
    ;

F : '(' E ')'{
	$$=$2;

}
    | T_ID 	{
		if(check_sym_tab($1)){
			char * value=retrieve_val($1);
			if(strcmp(value,"~")){
				printf("variable %s not initialized\n",$1);
				yyerror($1);
			}
			else{
				$$=strdup(value);//$$ is the lhs
				vtype=type_check(value);
			}
		}
	}
    | T_NUM {
		$$=$1;//here as we pass the value itself like a=10 we dont need to get the value for $1 we can just take the value
		vtype=type_check($1);
	}
    | T_STRLITERAL {
		$$=$1;
		vtype=-1;
	}
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
	t=init_table();
	//printf("here \n");
	yyparse();
	display_sym_tab();
	return 0;

} 

