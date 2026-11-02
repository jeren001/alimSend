#include "stdio.h"
#include "parser.tab.h"
#include "def.h"

/****************请在下面填写代码显示语法树*************/
struct node *mknode(int kind, struct node *p1, struct node *p2, struct node *p3)
{
    struct node *T = (struct node *)malloc(sizeof(struct node));
    memset(T, 0, sizeof(struct node));
    T->kind = kind;
    T->p1 = p1;
    T->p2 = p2;
    T->p3 = p3;
    return T;
}

static void sp(int n)
{
    int i;
    for (i = 0; i < n; i++) printf(" ");
}

void display(struct node *T, int indent)
{
    if (T == NULL) return;
    switch (T->kind) {
    case STMT_LIST:
        display(T->p1, indent);
        display(T->p2, indent);
        break;
    case COMP_STMT:
        display(T->p1, indent);
        break;
    case EXP_STMT:
        sp(indent); printf("表达式语句：\n");
        display(T->p1, indent + 4);
        break;
    case SCAN_STMT:
        sp(indent); printf("输入变量：%s\n", T->type_id);
        break;
    case PRINT_STMT:
        sp(indent); printf("输出表达式:\n");
        display(T->p1, indent + 4);
        break;
    case IF_STMT:
        sp(indent); printf("条件语句(if_then)：\n");
        sp(indent + 4); printf("条件：\n");
        display(T->p1, indent + 8);
        sp(indent + 4); printf("if子句：\n");
        display(T->p2, indent + 8);
        break;
    case IF_ELSE_STMT:
        sp(indent); printf("条件语句(if_then_else)：\n");
        sp(indent + 4); printf("条件：\n");
        display(T->p1, indent + 8);
        sp(indent + 4); printf("if子句：\n");
        display(T->p2, indent + 8);
        sp(indent + 4); printf("else子句：\n");
        display(T->p3, indent + 8);
        break;
    case WHILE_STMT:
        sp(indent); printf("循环语句：\n");
        sp(indent + 4); printf("条件：\n");
        display(T->p1, indent + 8);
        sp(indent + 4); printf("循环体：\n");
        display(T->p2, indent + 8);
        break;
    case INT_NODE:
        sp(indent); printf("整型常量：%d\n", T->type_int);
        break;
    case FLOAT_NODE:
        sp(indent); printf("浮点常量：%f\n", T->type_float);
        break;
    case ID_NODE:
        sp(indent); printf("变量：%s\n", T->type_id);
        break;
    case OP_NODE:
        sp(indent); printf("%s\n", T->type_id);
        display(T->p1, indent + 4);
        display(T->p2, indent + 4);
        break;
    case UMINUS_NODE:
        sp(indent); printf("单目-\n");
        display(T->p1, indent + 4);
        break;
    }
}

/*****************************************************/