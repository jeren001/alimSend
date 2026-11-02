/*********************请在下面完成parser.y*******************/
%{
#include "def.h"
extern int yylineno;
extern FILE *yyin;
int yylex(void);
void yyerror(const char *s);
struct node *mkop(char *op, struct node *a, struct node *b);
%}

%union {
    int type_int;
    float type_float;
    char type_id[32];
    struct node *ptr;
}

%token <type_int> INT
%token <type_float> FLOAT
%token <type_id> ID
%token LC RC LP RP SEMI SCAN PRINT IF ELSE WHILE
%token ASSIGNOP PLUS MINUS STAR DIV EQ NE LT LE GT GE

%type <ptr> program StmtList CompSt Stmt Exp

%right ASSIGNOP
%left EQ NE
%left LT LE GT GE
%left PLUS MINUS
%left STAR DIV
%right UMINUS
%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%%
program  : StmtList                     { display($1, 0); }
         ;
StmtList : /* empty */                  { $$ = NULL; }
         | Stmt StmtList                { $$ = mknode(STMT_LIST, $1, $2, NULL); }
         ;
CompSt   : LC StmtList RC               { $$ = mknode(COMP_STMT, $2, NULL, NULL); }
         ;
Stmt     : Exp SEMI                     { $$ = mknode(EXP_STMT, $1, NULL, NULL); }
         | CompSt                       { $$ = $1; }
         | SCAN ID SEMI                 { $$ = mknode(SCAN_STMT, NULL, NULL, NULL); strcpy($$->type_id, $2); }
         | PRINT Exp SEMI               { $$ = mknode(PRINT_STMT, $2, NULL, NULL); }
         | IF LP Exp RP Stmt %prec LOWER_THAN_ELSE { $$ = mknode(IF_STMT, $3, $5, NULL); }
         | IF LP Exp RP Stmt ELSE Stmt  { $$ = mknode(IF_ELSE_STMT, $3, $5, $7); }
         | WHILE LP Exp RP Stmt         { $$ = mknode(WHILE_STMT, $3, $5, NULL); }
         ;
Exp      : INT                          { $$ = mknode(INT_NODE, NULL, NULL, NULL); $$->type_int = $1; }
         | FLOAT                        { $$ = mknode(FLOAT_NODE, NULL, NULL, NULL); $$->type_float = $1; }
         | ID                           { $$ = mknode(ID_NODE, NULL, NULL, NULL); strcpy($$->type_id, $1); }
         | Exp ASSIGNOP Exp             { $$ = mkop("=", $1, $3); }
         | Exp PLUS Exp                 { $$ = mkop("+", $1, $3); }
         | Exp MINUS Exp                { $$ = mkop("-", $1, $3); }
         | Exp STAR Exp                 { $$ = mkop("*", $1, $3); }
         | Exp DIV Exp                  { $$ = mkop("/", $1, $3); }
         | Exp EQ Exp                   { $$ = mkop("==", $1, $3); }
         | Exp NE Exp                   { $$ = mkop("!=", $1, $3); }
         | Exp GT Exp                   { $$ = mkop(">", $1, $3); }
         | Exp GE Exp                   { $$ = mkop(">=", $1, $3); }
         | Exp LT Exp                   { $$ = mkop("<", $1, $3); }
         | Exp LE Exp                   { $$ = mkop("<=", $1, $3); }
         | MINUS Exp %prec UMINUS       { $$ = mknode(UMINUS_NODE, $2, NULL, NULL); }
         | LP Exp RP                    { $$ = $2; }
         ;
%%

struct node *mkop(char *op, struct node *a, struct node *b)
{
    struct node *T = mknode(OP_NODE, a, b, NULL);
    strcpy(T->type_id, op);
    return T;
}

int main(int argc, char *argv[])
{
    yyin = fopen(argv[1], "r");
    if (!yyin) return 0;
    yylineno = 1;
    yyparse();
    return 0;
}

void yyerror(const char *s)
{
    printf("Grammar Error at Line %d: %s\n", yylineno, s);
}

/************************************************************/