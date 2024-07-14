//we need to implement symbol table with a linked list
//you need to take care of character mismatch like float x="a";

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "sym_tab.h"

table* init_table()	//allocate a new empty symbol table
{
	table* t = (table*)malloc(sizeof(table));
	t->head = NULL;
	return t;
}

symbol* init_symbol(char* name, int size, int type, int lineno,int scope) //allocates space for items in the list
{
	symbol* s = (symbol*)malloc(sizeof(symbol));
	s->name=(char*)malloc(sizeof(char)*(strlen(name)+1));
	strcpy(s->name,name);
	s->size=size;
	s->type=type;
	s->line=lineno;
	s->scope=scope;
	s->val=(char*)malloc(sizeof(char)*10);
	strcpy(s->val,"~");

	return s;
}

void insert_symbol(char* name, int size, int type, int lineno,int scope)	//inserts symbols into the table when declared
{
	symbol *s=init_symbol(name,size, type, lineno,scope);
	if(t->head==NULL){
		t->head=s;
		return;
	}
	symbol* cur=t->head;
	while(cur->next!=NULL){
		cur=cur->next;
	}
	cur->next=s;
}


void insert_val(char* name, char* v, int line)	//inserts values into the table when initialised
{
	if(t->head==NULL) return;

	symbol *cur=t->head;
	while(cur!=NULL){
		if(strcmp(cur->name,name)==0){
			strcpy(cur->val,v);
			cur->line=line;
			return;
		}
		cur=cur->next;
	}

}

char* retrieve_val(char* name)	//retrieves value from symbol table
{
	char*val="~";
	if(t->head==NULL) return val;
	symbol *cur=t->head;
	while(cur!=NULL){
		if(strcmp(cur->name,name)==0){
			val=cur->val;
			return val;
		}
		cur=cur->next;
	}
	return val;

}

int retrieve_type(char* name)	//retrieves type from symbol table
{
	int type=-1;
	if(t->head==NULL) return type;
	symbol *cur=t->head;
	while(cur!=NULL){
		if(strcmp(cur->name,name)==0){
			type=cur->type;
			return type;
		}
		cur=cur->next;
	}
	return type;
}

int check_sym_tab(char* name)		//checks symbol table whether the variable has been declared or not
{					//return 0 if symbol not found and 1 if symbol is found

	int found=0;
	if(t->head==NULL) return found;
	symbol *cur=t->head;
	while(cur!=NULL){
		if(strcmp(cur->name,name)==0){
			found=1;
			return found;
		}
		cur=cur->next;
	}
	return found;
	
}

void display_sym_tab()			//displays symbol table
{
	symbol* curr = t->head;
	if(curr == NULL)
		return;
	printf("Name\tsize\ttype\tlineno\tscope\tvalue\n");
	while(curr!=NULL)
	{		
		printf("%s\t%d\t%d\t%d\t%d\t%s\n", curr->name, curr->size, curr->type, curr->line, curr->scope,curr->val);
		curr = curr->next;
	}
}

int type_check(char* value)		//checks the type from the value string
{
	char *s=strchr(value,'\"');	//checks if there's a double quote then its a char
	if(s!=NULL)
		return 1; 
	char *f=strchr(value,'.');	//checks if there's a dot then its a float or double
	if(f!=NULL)
		return 3;
	return 2;			//otherwise returns int type
}

int size(int type)
{
	if(type==3)
		return 4;
	if(type==4)
		return 8;
	return type;
}

