CHAR [A-Za-z!$%&\*\+-\./:<=>\?@\^_~]
DIGIT [0-9]
%{
#include "dep.h"
#include "y.tab.h"
%}
%%
\"(\\.|[^\"\\])*\" {free(buf2);buf2=(char*)malloc(sizeof(char)*strlen(yytext-1));strncpy(buf2,yytext+1,strlen(yytext)-2);return T_STRING;} 

("print") {free(buf2);buf2=(char*)malloc(sizeof(char)*strlen(yytext+1));strcpy(buf2,yytext);return T_PRINT;}
("setq"|"let"|"defvar")	{free(buf2);buf2=(char*)malloc(sizeof(char)*strlen(yytext+1));strcpy(buf2,yytext);return T_ASSIGN;}
("+"|"*"|"-"|"/")	{free(buf2);buf2=(char*)malloc(sizeof(char)*strlen(yytext+1));strcpy(buf2,yytext);return *yytext;}
(">=")  {free(buf2);buf2=(char*)malloc(sizeof(char)*strlen(yytext+1));strcpy(buf2,yytext);return T_GE;}
("<=")  {free(buf2);buf2=(char*)malloc(sizeof(char)*strlen(yytext+1));strcpy(buf2,yytext);return T_LE;}
("/=")	{free(buf2);buf2=(char*)malloc(sizeof(char)*strlen(yytext+1));strcpy(buf2,yytext);return T_NE;}
(">")   {free(buf2);buf2=(char*)malloc(sizeof(char)*strlen(yytext+1));strcpy(buf2,yytext);return T_GT;}
("<")   {free(buf2);buf2=(char*)malloc(sizeof(char)*strlen(yytext+1));strcpy(buf2,yytext);return T_LT;}
("=") {free(buf2);buf2=(char*)malloc(sizeof(char)*strlen(yytext+1));strcpy(buf2,yytext);return T_ET;}
("logand") {free(buf2);buf2=(char*)malloc(sizeof(char)*strlen(yytext+1));strcpy(buf2,yytext);return T_LAND;}
("logior") {free(buf2);buf2=(char*)malloc(sizeof(char)*strlen(yytext+1));strcpy(buf2,yytext);return T_LOR;}
("logxor") {free(buf2);buf2=(char*)malloc(sizeof(char)*strlen(yytext+1));strcpy(buf2,yytext);return T_LXOR;}
("lognor") {free(buf2);buf2=(char*)malloc(sizeof(char)*strlen(yytext+1));strcpy(buf2,yytext);return T_LXNOR;}
("logeqv") {free(buf2);buf2=(char*)malloc(sizeof(char)*strlen(yytext+1));strcpy(buf2,yytext);return T_LEQV;}
(dotimes) {free(buf2);buf2=(char*)malloc(sizeof(char)*strlen(yytext+1));strcpy(buf2,yytext);return T_LOOP;}
(if)	{free(buf2);buf2=(char*)malloc(sizeof(char)*strlen(yytext+1));strcpy(buf2,yytext);return T_DES;}
(then)	{free(buf2);buf2=(char*)malloc(sizeof(char)*strlen(yytext+1));strcpy(buf2,yytext);return T_THEN;}
("and") {free(buf2);buf2=(char*)malloc(sizeof(char)*strlen(yytext+1));strcpy(buf2,yytext);return T_AND;}
("or")  {free(buf2);buf2=(char*)malloc(sizeof(char)*strlen(yytext+1));strcpy(buf2,yytext);return T_OR;}
("not")	{free(buf2);buf2=(char*)malloc(sizeof(char)*strlen(yytext+1));strcpy(buf2,yytext);return T_NOT;}
"-"?{DIGIT}+	{free(buf2);buf2=(char*)malloc(sizeof(char)*strlen(yytext+1));strcpy(buf2,yytext);yylval=atoi(yytext);return T_NUM;}
{DIGIT}*{CHAR}+{DIGIT}*	{free(buf2);buf2=(char*)malloc(sizeof(char)*strlen(yytext+1));strcpy(buf2,yytext);tokval=put_in_tabl(yytext);return T_ID;}
[\n| |\t]+	;
. {return *yytext;}
%%
