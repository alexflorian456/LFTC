%{
#include<stdlib.h>
#include<string.h>
#include<stdio.h>
#include<ctype.h>

#include"attrib.h"

int line = 1;

extern char * yytext;
extern int yylex();
extern int yyerror(const char* msg)
{
    printf("%s : line %d : %s\n", msg, line, yytext);
    exit(1);
}

char text_section[4096] =
"section .text\n\
default rel\n\
extern scanf\n\
extern printf\n\
global main\n\n\
\
main:\n";

char bss_section[4096] = "section .bss\n";

const char data_section[4096] =
"section .data\n\
format_scanf: db \"%d\", 0\n\
format_printf: db \"%d\", 10, 0\n";

int temp_var_index = 0;

%}

%union {
    attributes attrib;
    char varname[10];
}

%token HASHTAG INCLUDE LT GT IOSTREAM
%token USING NAMESPACE STD SEMICOLON
%token VOID MAIN OPR CPR OCB CCB
%token INT ASSIGN ADD SUB MUL DIV
%token CIN COUT ENDL EXTRACTION INSERTION
%token RETURN

%left ADD SUB
%left MUL DIV

%token <varname> ID
%token <varname> CONST
%type <attrib> expr

%%

program :   HASHTAG INCLUDE LT IOSTREAM GT
            USING NAMESPACE STD SEMICOLON
            INT MAIN OPR CPR OCB
                instrs
                instr_ret
            CCB

instrs  : /* epsilon */
        | instr_list
        ;

instr_ret   :   RETURN CONST SEMICOLON
            {
                char * exit_instrs = (char *)malloc(256 * sizeof(char));
                if(isdigit($2[0])){
                    sprintf(exit_instrs, "\nmov rax, 60\nmov rdi, %s\nsyscall\n", $2);
                }
                else{
                    sprintf(exit_instrs, "\nmov rax, 60\nmov rdi, [%s]\nsyscall\n", $2);
                }
                strcat(text_section, exit_instrs);
                free(exit_instrs);
            }
            ;

instr_list  : instr
            | instr instr_list
            ;

instr   : instr_decl
        | instr_assign
        | instr_read
        | instr_write
        ;

instr_assign    : ID ASSIGN expr SEMICOLON
                {
                    char * assign_instrs = (char *)malloc(1024 * sizeof(char));
                    if(isdigit($1[0])){
                        sprintf(assign_instrs,"\nmov rax, [%s]\nmov %s, rax\n", $3.varn, $1);
                    }
                    else{
                        sprintf(assign_instrs,"\nmov rax, [%s]\nmov [%s], rax\n", $3.varn, $1);
                    }
                    strcat(text_section, assign_instrs);
                    free(assign_instrs);
                }
                ;

expr    : expr ADD expr
        {
            char * temp_var_name = (char *)malloc(10 * sizeof(char));
            char * resb_instr = (char *)malloc(256 * sizeof(char));
            char * add_instrs = (char *)malloc(256 * sizeof(char));
            char * add_mov_instrs = (char *)malloc(256 * sizeof(char));

            sprintf(temp_var_name, "t%d", temp_var_index++);
            sprintf(resb_instr, "%s resb 8\n", temp_var_name);
            strcpy($$.varn, temp_var_name);
            strcat(bss_section, resb_instr);

            if(isdigit($1.varn[0])){
                sprintf(add_instrs, "\nmov rax, %s", $1.varn);
            }
            else{
                sprintf(add_instrs, "\nmov rax, [%s]", $1.varn);
            }
            if(isdigit($3.varn[0])){
                sprintf(add_mov_instrs,"\nadd rax, %s\nmov [%s], rax\n", $3.varn, temp_var_name);
            }
            else{
                sprintf(add_mov_instrs,"\nadd rax, [%s]\nmov [%s], rax\n", $3.varn, temp_var_name);
            }
            strcat(add_instrs, add_mov_instrs);
            strcat(text_section, add_instrs);

            free(add_mov_instrs);
            free(add_instrs);
            free(resb_instr);
            free(temp_var_name);
        }
        | expr SUB expr
        {
            char * temp_var_name = (char *)malloc(10 * sizeof(char));
            char * resb_instr = (char *)malloc(256 * sizeof(char));
            char * add_instrs = (char *)malloc(256 * sizeof(char));
            char * add_mov_instrs = (char *)malloc(256 * sizeof(char));

            sprintf(temp_var_name, "t%d", temp_var_index++);
            sprintf(resb_instr, "%s resb 8\n", temp_var_name);
            strcpy($$.varn, temp_var_name);
            strcat(bss_section, resb_instr);

            if(isdigit($1.varn[0])){
                sprintf(add_instrs, "\nmov rax, %s", $1.varn);
            }
            else{
                sprintf(add_instrs, "\nmov rax, [%s]", $1.varn);
            }
            if(isdigit($3.varn[0])){
                sprintf(add_mov_instrs,"\nsub rax, %s\nmov [%s], rax\n", $3.varn, temp_var_name);
            }
            else{
                sprintf(add_mov_instrs,"\nsub rax, [%s]\nmov [%s], rax\n", $3.varn, temp_var_name);
            }
            strcat(add_instrs, add_mov_instrs);
            strcat(text_section, add_instrs);

            free(add_mov_instrs);
            free(add_instrs);
            free(resb_instr);
            free(temp_var_name);
        }
        | expr MUL expr
        {
            char * temp_var_name = (char *)malloc(10 * sizeof(char));
            char * resb_instr = (char *)malloc(256 * sizeof(char));
            char * add_instrs = (char *)malloc(256 * sizeof(char));
            char * add_mov_instrs = (char *)malloc(256 * sizeof(char));

            sprintf(temp_var_name, "t%d", temp_var_index++);
            sprintf(resb_instr, "%s resb 8\n", temp_var_name);
            strcpy($$.varn, temp_var_name);
            strcat(bss_section, resb_instr);

            if(isdigit($1.varn[0])){
                sprintf(add_instrs, "\nmov rax, %s", $1.varn);
            }
            else{
                sprintf(add_instrs, "\nmov rax, [%s]", $1.varn);
            }
            if(isdigit($3.varn[0])){
                sprintf(add_mov_instrs,"\nmov rbx, %s\nmul rbx\nmov [%s], rax\n", $3.varn, temp_var_name);
            }
            else{
                sprintf(add_mov_instrs,"\nmul qword [%s]\nmov [%s], rax\n", $3.varn, temp_var_name);
            }
            strcat(add_instrs, add_mov_instrs);
            strcat(text_section, add_instrs);

            free(add_mov_instrs);
            free(add_instrs);
            free(resb_instr);
            free(temp_var_name);
        }
        | expr DIV expr
        {
            char * temp_var_name = (char *)malloc(10 * sizeof(char));
            char * resb_instr = (char *)malloc(256 * sizeof(char));
            char * add_instrs = (char *)malloc(256 * sizeof(char));
            char * add_mov_instrs = (char *)malloc(256 * sizeof(char));

            sprintf(temp_var_name, "t%d", temp_var_index++);
            sprintf(resb_instr, "%s resb 8\n", temp_var_name);
            strcpy($$.varn, temp_var_name);
            strcat(bss_section, resb_instr);

            if(isdigit($1.varn[0])){
                sprintf(add_instrs, "\nmov rax, %s", $1.varn);
            }
            else{
                sprintf(add_instrs, "\nmov rax, [%s]", $1.varn);
            }
            if(isdigit($3.varn[0])){
                sprintf(add_mov_instrs,"\nmov rbx, %s\ndiv rbx\nmov [%s], rax\n", $3.varn, temp_var_name);
            }
            else{
                sprintf(add_mov_instrs,"\ndiv qword [%s]\nmov [%s], rax\n", $3.varn, temp_var_name);
            }
            strcat(add_instrs, add_mov_instrs);
            strcat(text_section, add_instrs);

            free(add_mov_instrs);
            free(add_instrs);
            free(resb_instr);
            free(temp_var_name);
        }
        | ID
        {
            strcpy($$.varn, $1);
        }
        | CONST
        {
            strcpy($$.varn, $1);
        }
        ;

instr_decl  : INT ID SEMICOLON
            {
                char * decl_instrs = (char *)malloc(256 * sizeof(char));
                sprintf(decl_instrs, "%s resb 8\n", $2);
                strcat(bss_section, decl_instrs);
                free(decl_instrs);
            }
            ;

instr_read  : CIN EXTRACTION ID SEMICOLON
            {
                char * read_instrs = (char *)malloc(256 * sizeof(char));
                sprintf(read_instrs, "\npush rbp\nmov rdi, format_scanf\nmov rsi, %s\ncall scanf wrt ..plt\npop rbp\n", $3);
                strcat(text_section, read_instrs);
                free(read_instrs);
            }
            ;

instr_write : COUT INSERTION ID INSERTION ENDL SEMICOLON
            {
                char * write_instrs = (char *)malloc(256 * sizeof(char));
                sprintf(write_instrs, "\npush rbp\nmov rdi, format_printf\nmov rsi, [%s]\ncall printf wrt ..plt\npop rbp\n", $3);
                strcat(text_section, write_instrs);
                free(write_instrs);
            }
            ;

%%

int main(int argc, char ** argv){
    yyparse();
    char * out_filename;
    FILE * file;
    if(argc<2){
        strcpy(out_filename, "a.asm");
    }
    else{
        strcpy(out_filename, argv[1]);
    }
    file = fopen(out_filename, "w");
    if(file == NULL){
        perror("error opening file\n");
        return 1;
    }
    fprintf(file, "%s\n%s\n%s\n", text_section, bss_section, data_section);
    fclose(file);
    return 0;
}
