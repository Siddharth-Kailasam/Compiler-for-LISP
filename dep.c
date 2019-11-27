#include "dep.h"

char st[100][10];
char loopstack[100][10];
char i_[3]="0";
char temp[5]="t";
char id_name[100][40];
int top=0;
char *label[150][2];
int lnum=0;
int nextnum=0;
int idtop=0;
int labtop=0;
int looptop=0;
int nextop=0;
int truetop=0;
int falsetop=0;

int put_in_tabl(char*yytext)
{
	char* idname = yytext;
	int i;
	for(i=0;i<100;i++)
	{
		//printf("%s-%s-%s\n",symbol[i][1],symbol[i][0],idname);
		if(strcmp(symbol[i][1],"0")==0)
		{
			break;
		}
		if(strcmp(symbol[i][0],idname)==0)
		{
			valid=1;
			return i;
		}
	}
	valid=0;
	//printf("Hello - %d\n",i);
	//fflush(stdout);
	strcpy(symbol[i][0],idname);
	strcpy(symbol[i][1],"1");
	return i;
}
char *strrev(char *str)
{
      char *p1, *p2;
	//printf("gvv- %s\n",str);
      if (! str || ! *str)
            return str;
      for (p1 = str, p2 = str + strlen(str) - 1; p2 > p1; ++p1, --p2)
      {
            *p1 ^= *p2;
            *p2 ^= *p1;
            *p1 ^= *p2;
      }
      return str;
}

char* itoa(int num,char* str) 
{ 
    int base=10;
    int i = 0; 
    int isNegative = 0; 
  
    /* Handle 0 explicitely, otherwise empty string is printed for 0 */
    if (num == 0) 
    { 
        str[i++] = '0'; 
        str[i] = '\0'; 
        return str; 
    } 
 // printf("tokval=%d\n",tokval);
  
    // In standard itoa(), negative numbers are handled only with  
    // base 10. Otherwise numbers are considered unsigned. 
    if (num < 0 && base == 10) 
    { 
        isNegative = 1; 
        num = -num; 
    } 
    // Process individual digits 
    while (num != 0) 
    { 
        int rem = num % base; 
        str[i++] = (rem > 9)? (rem-10) + 'a' : rem + '0'; 
        num = num/base; 
    } 
  
    // If number is negative, append '-' 
    if (isNegative) 
        str[i++] = '-'; 
  
    str[i] = '\0'; // Append string terminator 
  
    // Reverse the string 
    strcpy(str,strrev(str)); 
    return str; 
} 



int push(char*op)
 {
  strcpy(st[++top],op);
 }
char* view()
{
  return st[top];
}
int codegen()
 {
 //fprintf(tac,"top : %d\n",top);
 //fprintf(tac,"stack : ");
 int i;
 if(top==0)
 	return 1;
 /*for(i=0;i<=top;i++)
 {
 	fprintf(tac,"%s ",st[i]);
 }
 fprintf(tac,"\n");*/
 if(strcmp(st[top-1],"=")==0)
 {
   fprintf(tac,"%s = %s\n",st[top-2],st[top]);
  // fprintf(tac,"test\n");
   fflush(tac);
   top-=3;
   return 0;
 }
 strcpy(temp,"t");
 strcat(temp,i_);
 if(strcmp(st[top-1],"")==0 || st[top-1][0]=='t')
 {
  fprintf(tac,"%s = %s\n",temp,st[top]);
  fflush(tac);
  top-=6;
  strcpy(st[top],temp);
  int tpp = atoi(i_);
  tpp++;
  strcpy(i_,itoa(tpp,str));
  return 0;
 }
 fprintf(tac,"%s = %s %s %s\n",temp,st[top-2],st[top-1],st[top]);
 fflush(tac);
 top-=2;
 strcpy(st[top],temp);
 int tpp = atoi(i_);
 tpp++;
 strcpy(i_,itoa(tpp,str));
 }
int pop()
{
	top--;
	return 0;
}

int push2()
{
	top++;
	return 0;
}

void init_label()
{
	int i,j;
	for(i=0;i<150;i++)
	{
		for(j=0;j<2;j++)
		{
			label[i][j]=(char*)malloc(sizeof(char)*20);
			strcpy(label[i][j],"\0");
		}
	}
}

int find_label(char*lname)
{
	int i;
	for(i=0;i<=labtop;i++)
	{
		if(strcmp(lname,label[i][0])==0)
		{
			return i;
		}
	}
	return -1;
}
int create_label(char*name,char*label1)
{
	int i,chk=0;
	if(strcmp(name,"cond.true")==0)
	{
		char*lname = (char*)malloc(sizeof(char)*20);
		strcpy(lname,name);
		strcat(lname,itoa(++truetop,str));
		char*lval = (char*)malloc(sizeof(char)*20);
		strcpy(lval,"L");
		strcat(lval,itoa(++lnum,str));
		strcpy(label[labtop][0],lname);
		strcpy(label[labtop++][1],lval);
		return 0;
	}
	if(strcmp(name,"cond.false")==0)
	{
		char*lname = (char*)malloc(sizeof(char)*20);
		strcpy(lname,name);
		strcat(lname,itoa(++falsetop,str));
		char*lval = (char*)malloc(sizeof(char)*20);
		strcpy(lval,"L");
		strcat(lval,itoa(++lnum,str));
		strcpy(label[labtop][0],lname);
		strcpy(label[labtop++][1],lval);
		return 0;
	}
	if(strcmp(name,"stmt.next")==0)
	{
		char*lname = (char*)malloc(sizeof(char)*20);
		strcpy(lname,name);
		strcat(lname,itoa(++nextop,str));
		char*lval = (char*)malloc(sizeof(char)*20);
		strcpy(lval,"next");
		strcat(lval,itoa(++nextnum,str));
		strcpy(label[labtop][0],lname);
		strcpy(label[labtop++][1],lval);
		return 0;
	}
}
int gen_code_if()
{
	char*lname = (char*)malloc(sizeof(char)*20);
	strcpy(lname,"cond.true");
	strcat(lname,itoa(truetop,str));
	int loc = find_label(lname);
	if(loc==-1)
		return -1;
	fprintf(tac,"ifFalse %s goto %s\n",st[1],label[loc][1]);
	fflush(tac);
	return 0;
}
int gen_code_false()
{
	char*lname = (char*)malloc(sizeof(char)*20);
	strcpy(lname,"stmt.next");
	pop();
	strcat(lname,itoa(nextop,str));
	int loc = find_label(lname);
	if(loc==-1)
		return -1;
	fprintf(tac,"goto %s\n",label[loc][1]);
	fflush(tac);
	strcpy(lname,"cond.true");
	strcat(lname,itoa(truetop,str));
	loc = find_label(lname);
	fprintf(tac,"%s:\n",label[loc][1]);
	fflush(tac);
	return 0;
}
int gen_code_true()
{
	char*lname = (char*)malloc(sizeof(char)*20);
	strcpy(lname,"stmt.next");
	strcat(lname,itoa(nextop,str));
	int loc = find_label(lname);
	if(loc==-1)
		return -1;
	fprintf(tac,"%s:\n",label[loc][1]);
	fflush(tac);
	truetop--;
	nextop--;
	labtop-=2;
	return 0;
}
int gen_code_init()
{
	fprintf(tac,"%s = 0\n",buf2);
	fflush(tac);
	strcpy(loopstack[looptop++],buf2);
	strcpy(id_name[idtop++],buf2);
	return 0;
}
int gen_code_cond()
{
	strcpy(temp,"t");
	strcat(temp,i_); 
	int tpp = atoi(i_);
	char lname[20],lname2[20];
	tpp++;
	strcpy(i_,itoa(tpp,str));
	strcpy(lname,"cond.true");
	strcat(lname,itoa(truetop,str));
	int loc = find_label(lname);
	strcpy(lname2,"stmt.next");
	strcat(lname2,itoa(nextop,str));
	int loc2 = find_label(lname2);
	fprintf(tac,"%s:\n%s=%s<%s\n",label[loc][1],temp,id_name[--idtop],st[1]);
	fprintf(tac,"ifFalse %s goto %s\n",temp,label[loc2][1]);
	fflush(tac);
	return 0;
}
int gen_code_loop()
{
	char lname[20],lname2[20];
	strcpy(lname,"cond.true");
	strcat(lname,itoa(truetop,str));
	int loc = find_label(lname);
	strcpy(lname2,"stmt.next");
	strcat(lname2,itoa(nextop,str));
	int loc2 = find_label(lname2);
	looptop--;
	fprintf(tac,"%s=%s+1\n",loopstack[looptop],loopstack[looptop]);
	fprintf(tac,"goto %s\n%s:\n",label[loc][1],label[loc2][1]);
	fflush(tac);
	truetop--;
	nextop--;
	labtop-=2;
	return 0;
}

