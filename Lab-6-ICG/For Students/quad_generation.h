extern FILE* icg_quad_file;		//pointer to the output file
extern int temp_no;				//variable to keep track of current temporary count
extern int label_no;				//variable to keep track of current temporary labelnt


void quad_code_gen(char* a, char* b, char* op, char* c); //a=b op c
char* new_temp();
char* new_label();