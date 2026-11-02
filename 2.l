#include "stdio.h"  
#include "stdlib.h"  
#include "ctype.h"  
#include "string.h"  
int main(int argc,char *argv[])    
{    
    
    FILE *fp;    
    fp=fopen(argv[1],"r");         //如果用C++实现，自行修改文件打开方式
    if (!fp) {printf("Fail Open\n");return 0;}    
 /***********在下面添加程序，根据文件指针读取测试文件中进行词法分析*********/  
    int c, line = 1, st = 0;
    char buf[100];
    int n;
    c = fgetc(fp);
    while (c != EOF) {
        if (c == '\n') { line++; c = fgetc(fp); continue; }
        if (c == ' ' || c == '\t' || c == '\r') { c = fgetc(fp); continue; }
        if (isalpha(c)) {
            n = 0;
            while (c != EOF && isalnum(c)) { buf[n++] = c; c = fgetc(fp); }
            buf[n] = 0;
            if (strcmp(buf, "int") == 0) printf("(1,-) ");
            else if (strcmp(buf, "while") == 0) printf("(2,-) ");
            else if (strcmp(buf, "if") == 0) printf("(3,-) ");
            else if (strcmp(buf, "else") == 0) printf("(4,-) ");
            else if (strcmp(buf, "return") == 0) printf("(5,-) ");
            else printf("(50,\"%s\") ", buf);
            st = 1;
            continue;
        }
        if (isdigit(c)) {
            n = 0;
            while (c != EOF && isdigit(c)) { buf[n++] = c; c = fgetc(fp); }
            buf[n] = 0;
            printf("(51,%s) ", buf);
            st = 1;
            continue;
        }
        if (c == '<' || c == '>' || c == '=' || c == '!') {
            int d = fgetc(fp);
            if (d == '=') {
                if (c == '<') printf("(66,-) ");
                else if (c == '>') printf("(68,-) ");
                else if (c == '=') printf("(69,-) ");
                else printf("(70,-) ");
                st = 1;
                c = fgetc(fp);
                continue;
            }
            if (c == '<') printf("(65,-) ");
            else if (c == '>') printf("(67,-) ");
            else if (c == '=') printf("(64,-) ");
            else { if (st) printf("\n"); printf("<error character '!' in line %d> ", line); }
            st = 1;
            c = d;
            continue;
        }
        switch (c) {
            case '+': printf("(60,-) "); break;
            case '-': printf("(61,-) "); break;
            case '*': printf("(62,-) "); break;
            case '/': printf("(63,-) "); break;
            case '{': printf("(71,-) "); break;
            case '}': printf("(72,-) "); break;
            case '(': printf("(73,-) "); break;
            case ')': printf("(74,-) "); break;
            case ',': printf("(75,-) "); break;
            case ';': printf("(76,-) "); break;
            default:
                if (st) printf("\n");
                printf("<error character '%c' in line %d> ", c, line);
        }
        st = 1;
        c = fgetc(fp);
    }
    fclose(fp);

    /*********************************************************************/  
    return 1;  
} 