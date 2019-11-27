%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include "dep.h"
typedef struct node
{
     struct node *left;
     struct node *right;
     int eval;     
     char *token;   
}node;
extern node*temp,*temp2;
node *mknode(node*newnode,node *left, node *right, char *token,int eval);   
void printtree(node *tree); 
#undef YYSTYPE
#define YYSTYPE struct node *
int yylex();
int yyerror();
int yydebug = 1;
int chk = 1;
%}

%error-verbose
%token T_ID T_NUM T_ASSIGN T_ARITH T_RELAT T_BIT T_LOOP T_DES T_THEN T_LOGIC T_AND T_OR T_NOT T_LAND T_LOR T_LXOR T_LXNOR T_LEQV T_GE T_LE T_NE T_GT T_LT T_ET T_STRING T_PRINT;
%%
S : STMTS //{printf("accepted\n");YYACCEPT;}
;
STMTS : STMT {printtree($1);} STMTS
|
;
STMT : '(' ST2 ')' {$$=$2;}
|F {$$=$1;};
ST2: ASSIGN {$$=$1;}
|LOOP {$$=$1;}
|DES {$$=$1;}
|LOG {$$=$1;}
|REL {$$=$1;}
|ARITH {$$=$1;}
|BIT {$$=$1;}
|PRINT{$$=$1;};
PRINT: T_PRINT T_STRING {printf("%s\n",buf2);temp = (node *)malloc(sizeof(node));temp2 = (node *)malloc(sizeof(node));$$=mknod(temp,mknod(temp2,NULL,NULL,buf2),NULL,"print",0);}
| T_PRINT STMT {temp = (node *)malloc(sizeof(node));$$=mknod(temp,$2,NULL,"print",$2->eval);printf("%d\n",$$->eval);};
ASSIGN :  T_ASSIGN T_ID {push(buf2);push("=");}  STMT {codegen();temp = (node *)malloc(sizeof(node));$$=mknod(temp,view(),$3,"=",$3->eval);strcpy(symbol[tokval][2],"1");strcpy(symbol[tokval][3],itoa($3->eval,str));};
ARITH : '+' DP {$$=$2;}
| '*' DM {$$=$2;}
| '/' DD {$$=$2;}
| '-' DS {$$=$2;};
DP : STMT {push("+");}DP {codegen();}{temp = (node *)malloc(sizeof(node));$$=mknod(temp,$1,$3,"+",$1->eval+$3->eval);printf("Test2\n");fflush(stdout);}
| {temp = (node *)malloc(sizeof(node));$$=mknod(temp,NULL,NULL,"0",0);pop();}
;
DM : STMT {push("*");} DM {codegen();}{temp = (node *)malloc(sizeof(node));$$=mknod(temp,$1,$3,"*",$1->eval*$3->eval);}
| {temp = (node *)malloc(sizeof(node));$$=mknod(temp,NULL,NULL,"1",1);pop();}
;
DS : STMT {push("-");} DS {codegen();}{temp = (node *)malloc(sizeof(node));$$=mknod(temp,$1,$3,"-",$1->eval-$3->eval);}
| {temp = (node *)malloc(sizeof(node));$$=mknod(temp,NULL,NULL,"0",0);$$->eval=0;pop();}
;
DD : STMT {push("/");} STMT {codegen();}{if($3->eval==0) {printf("DividebyZeroError : Denominator cannot be zero\n");exit(0);}else {$$=mknod((node *)malloc(sizeof(node)),$1,$3,"/",$1->eval/$3->eval);}}
;
F : T_ID {push(buf2);if(valid==0) {temp = (node *)malloc(sizeof(node));$$=mknod(temp,NULL,NULL,buf2,0);}else{temp = (node *)malloc(sizeof(node));$$=mknod(temp,NULL,NULL,buf2,atoi(symbol[tokval][3]));}}
|T_NUM {push(buf2);temp = (node *)malloc(sizeof(node));$$=mknod(temp,NULL,NULL,buf2,atoi(buf2));printf("Test\n");fflush(stdout);}
| T_STRING {push(buf2);temp = (node *)malloc(sizeof(node));$$=mknod(temp,NULL,NULL,buf2,0);}
;
REL : T_GE DGE {$$=$2;}
| T_LE DLE {$$=$2;}
| T_NE DNE {$$=$2;}
| T_GT DG {$$=$2;}
| T_LT DL {$$=$2;}
| T_ET DE {$$=$2;};
DGE : STMT {push(">=");} STMT {codegen();} {temp = (node *)malloc(sizeof(node));$$=mknod(temp,$1,$3,">=",$1->eval>=$3->eval);};
DLE : STMT {push("<=");} STMT {codegen();} {temp = (node *)malloc(sizeof(node));$$=mknod(temp,$1,$3,"<=",$1->eval<=$3->eval);};
DNE : STMT {push("!=");} DNE {codegen();}{temp = (node *)malloc(sizeof(node));$$=mknod(temp,$1,$3,"!=",$1->eval!=$3->eval);};
DG : STMT {push(">");} DG {codegen();}{temp = (node *)malloc(sizeof(node));$$=mknod(temp,$1,$3,">",$1->eval>$3->eval);};
DL : STMT {push("<");}DL {codegen();}{temp = (node *)malloc(sizeof(node));$$=mknod(temp,$1,$3,"<",$1->eval<$3->eval);};
DE : STMT {push("==");}DE {codegen();}{temp = (node *)malloc(sizeof(node));$$=mknod(temp,$1,$3,"==",$1->eval==$3->eval);};
LOG : T_LAND  DBA {$$=$2;}
| T_LOR DBO {$$=$2;}
| T_LXOR DBX {$$=$2;}
| T_LXNOR DBN {$$=$2;}
| T_LEQV DBE {$$=$2;};

DBA : STMT {push("&&");} DD {codegen();} {temp = (node *)malloc(sizeof(node));$$=mknod(temp,$1,$3,"&&",$1->eval && $3->eval);}
| {temp = (node *)malloc(sizeof(node));$$=mknod(temp,NULL,NULL,"1",1);pop();}
;
DBO : STMT {push("||");} DS {codegen();} {temp = (node *)malloc(sizeof(node));$$=mknod(temp,$1,$3,"||",$1->eval || $3->eval);}
| {temp = (node *)malloc(sizeof(node)); $$=mknod(temp,NULL,NULL,"0",0);pop();}
;
DBX : STMT {push("XOR");}DD {codegen();}{chk = chk * (-1); temp = (node *)malloc(sizeof(node));$$=mknod(temp,$1,$3,"XOR",(!$1->eval && $3->eval)||($1->eval && !$3->eval));}
| {if(chk==1) {temp = (node *)malloc(sizeof(node));$$=mknod(temp,NULL,NULL,"0",0);} else {temp = (node *)malloc(sizeof(node));$$=mknod(temp,NULL,NULL,"1",1);} chk = 1;pop();}
;
DBN : STMT {push("NOR");} DS {codegen();}{temp = (node *)malloc(sizeof(node));$$=mknod(temp,$1,$3,"NOR",! $1->eval && ! $3->eval);}
| {temp = (node *)malloc(sizeof(node)); $$=mknod(temp,NULL,NULL,"0",0);pop();}
;
DBE : STMT {push("==");} STMT {codegen();} {temp = (node *)malloc(sizeof(node));$$=mknod(temp,$1,$3,"==",$1->eval == $3->eval);};

BIT : T_AND DLA {$$=$2;}
| T_OR DLO {$$=$2;}
| T_NOT DLN {$$=$2;};
DLA : STMT {push("&");} DD {codegen();} {temp = (node *)malloc(sizeof(node));$$=mknod(temp,$1,$3,"&",$1->eval & $3->eval);}
| {temp = (node *)malloc(sizeof(node));$$=mknod(temp,NULL,NULL,"1",1);pop();}
;
DLO : STMT {push("|");} DS {codegen();} {temp = (node *)malloc(sizeof(node));$$=mknod(temp,$1,$3,"|",$1->eval | $3->eval);}
| {temp = (node *)malloc(sizeof(node));$$=mknod(temp,NULL,NULL,"0",0);pop();}
;
DLN : STMT {push("!");} {codegen();} {temp = (node *)malloc(sizeof(node));$$=mknod(temp,$1,$3,"!",!$1->eval);};
LOOP:T_LOOP '('{create_label("cond.true",NULL);create_label("stmt.next",NULL);} T_ID {gen_code_init();} STMT {gen_code_cond();pop();} STS ')' STMTS {gen_code_loop();};
DES:T_DES {create_label("cond.true",NULL);create_label("stmt.next",NULL);} CONDN EXPN ;
CONDN:STMT {gen_code_if();} ;
EXPN:{gen_code_false();}STMT {gen_code_true();}
|STMT {gen_code_false();} STMT  {gen_code_true();}
|T_THEN {gen_code_false();}STMT {gen_code_true();} 
;
STS:STMT {push2();}
|
;
%%

int yyerror(char*a){
	printf("%s\n",a);
	fclose(tac);
	tac = fopen("intermediate.tac","w");
	fclose(tac);
	exit(0);	
}
void init()
{
	int i,j;
	for(i=0;i<100;i++)
	{
		for(j=0;j<4;j++)
		{
			symbol[i][j]=(char*)malloc(sizeof(char)*1000);
			strcpy(symbol[i][j],"0");
		}
	}
}

node *mknode(node*newnode,node *left, node *right, char *token, int eval) 
{ /* malloc the node */
   newnode->eval=eval;
   char *newstr = (char *)malloc(strlen(token)+1);   
   strcpy(newstr, token);   
   newnode->left = left;   
   newnode->right = right;   
   newnode->token = newstr;   
   return(newnode); 
} 
void printtree(node *tree) 
{
   int i;   
   if (tree->left || tree->right)  
      printf("(");   
   printf(" %s ", tree->token);   
   if (tree->left)     
     printtree(tree->left);   
   if (tree->right)     
     printtree(tree->right);   
   if (tree->left || tree->right)     
      printf(")"); 
}
int main()
{
	tac = fopen("intermediate.tac","w");
	init();
	init_label();
	printf("Enter the LISP code:\n");
	int i;
	if(!yyparse())
	{
		printf("Valid code!\n");
	}
	fclose(tac);
}

