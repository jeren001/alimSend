%option yylineno
%{
#include <stdio.h>
#include <stdlib.h>
int st = 0;
%}
id        [A-Za-z][A-Za-z0-9]*
intconst  [0-9]+
%%
"int"       { printf("(1,-) "); st = 1; }
"while"     { printf("(2,-) "); st = 1; }
"if"        { printf("(3,-) "); st = 1; }
"else"      { printf("(4,-) "); st = 1; }
"return"    { printf("(5,-) "); st = 1; }
{id}        { printf("(50,\"%s\") ", yytext); st = 1; }
{intconst}  { printf("(51,%s) ", yytext); st = 1; }
"<="        { printf("(66,-) "); st = 1; }
">="        { printf("(68,-) "); st = 1; }
"=="        { printf("(69,-) "); st = 1; }
"!="        { printf("(70,-) "); st = 1; }
"+"         { printf("(60,-) "); st = 1; }
"-"         { printf("(61,-) "); st = 1; }
"*"         { printf("(62,-) "); st = 1; }
"/"         { printf("(63,-) "); st = 1; }
"="         { printf("(64,-) "); st = 1; }
"<"         { printf("(65,-) "); st = 1; }
">"         { printf("(67,-) "); st = 1; }
"{"         { printf("(71,-) "); st = 1; }
"}"         { printf("(72,-) "); st = 1; }
"("         { printf("(73,-) "); st = 1; }
")"         { printf("(74,-) "); st = 1; }
","         { printf("(75,-) "); st = 1; }
";"         { printf("(76,-) "); st = 1; }
[ \t\r\n]+  { }
.           { if (st) printf("\n"); printf("<error character '%s' in line %d> ", yytext, yylineno); st = 1; }
%%

/**************以下为用户子程序段******************/
int main(int argc, char *argv[])
{
    yylineno = 1;
    yyin = fopen(argv[1], "r");
    if (!yyin) return 0;
    while (yylex());
    return 0;
}
int yywrap() { return 1; }