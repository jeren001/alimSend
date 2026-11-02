/*********************请在下面完成lex.l*******************/
%option yylineno
%{
#include "def.h"
#include "parser.tab.h"
%}
id     [A-Za-z][A-Za-z0-9]*
int    [0-9]+
float  ([0-9]*\.[0-9]+)|([0-9]+\.)
%%
"if"        { return IF; }
"else"      { return ELSE; }
"while"     { return WHILE; }
"scan"      { return SCAN; }
"read"      { return SCAN; }
"print"     { return PRINT; }
"write"     { return PRINT; }
{int}       { yylval.type_int = atoi(yytext); return INT; }
{float}     { yylval.type_float = atof(yytext); return FLOAT; }
{id}        { strcpy(yylval.type_id, yytext); return ID; }
"=="        { return EQ; }
"!="        { return NE; }
"<="        { return LE; }
">="        { return GE; }
"<"         { return LT; }
">"         { return GT; }
"="         { return ASSIGNOP; }
"+"         { return PLUS; }
"-"         { return MINUS; }
"*"         { return STAR; }
"/"         { return DIV; }
"{"         { return LC; }
"}"         { return RC; }
"("         { return LP; }
")"         { return RP; }
";"         { return SEMI; }
[ \t\r\n]+  { }
.           { printf("Error type A at line %d: Mysterious character \"%s\"\n", yylineno, yytext); }
%%
int yywrap()
{
    return 1;
}

/********************************************************/
