#include<string.h>
#include<stdio.h>
#include<stdlib.h>

int put_in_tabl();
int tokval;
int valid;
FILE*tac;
char*symbol[100][4];
char*itoa(int,char*);
char*strrev(char*);
char str[100];
char*buf2;
int push(char*);
int codegen();
int pop();
int empty();
void init_label();
int create_label(char*,char*);
int gen_code_if();
int gen_code_true();
int gen_code_false();
int gen_code_init();
int gen_code_cond();
int gen_code_loop();
char* view();
