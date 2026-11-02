/***********定义结点类型和给出函数说明*********/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

enum node_kind { EXP_STMT, COMP_STMT, SCAN_STMT, PRINT_STMT, IF_STMT, IF_ELSE_STMT, WHILE_STMT,
                 INT_NODE, FLOAT_NODE, ID_NODE, OP_NODE, UMINUS_NODE, STMT_LIST };

struct node {
    int kind;
    int type_int;
    float type_float;
    char type_id[32];
    struct node *p1, *p2, *p3;
};

struct node *mknode(int kind, struct node *p1, struct node *p2, struct node *p3);
void display(struct node *T, int indent);

/*********************************************/