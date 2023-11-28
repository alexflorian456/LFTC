%{

#include<stdio.h>
#include<stdlib.h>
#include<string.h>

int yywrap(){
    return 1;
}

const int m = 101;
char ** TS;

int d1(int c){
    return c%m;
}

int d2(int c){
    return 1+c%(m-1);
}

int d(int c, int i){
    return (d1(c)+i*d2(c))%m;
}

int string_to_int(char* str){
    int total = 0;
    for(int i = 0; i < strlen(str); i++){
        total += str[i];
    }
    return total;
}

%}

ID          [a-zA-Z][a-zA-Z0-9]*   
CONST_INT   0|[1-9][0-9]*
CONST_REAL  (0|[1-9][0-9]*)?\.[0-9]+

%%

[ \t\r\n]

"if" printf("2 if \n");
"else" printf("3 else \n");
"while" printf("4 while \n");
"cout" printf("5 cout \n");
">>" printf("6 >> \n");
"int" printf("7 int \n");
"<<" printf("8 << \n");
"#" printf("9 # \n");
")" printf("10 ) \n");
"(" printf("11 ( \n");
"+" printf("12 + \n");
"namespace" printf("13 namespace \n");
";" printf("14 ; \n");
"main" printf("15 main \n");
"=" printf("16 = \n");
"<" printf("17 < \n");
">" printf("18 > \n");
"iostream" printf("19 iostream \n");
"void" printf("20 void \n");
"using" printf("21 using \n");
"endl" printf("22 endl \n");
"std" printf("23 std \n");
"include" printf("24 include \n");
"cin" printf("25 cin \n");
"{" printf("26 { \n");
"}" printf("27 } \n");
"*" printf("28 * \n");
"-" printf("29 - \n");
"!=" printf("30 != \n");
"char" printf("31 char \n");
"circle" printf("32 circle \n");
"repeta" printf("33 repeta \n");
"panacand" printf("34 panacand \n");
"sfrepeta" printf("35 sfrepeta \n");

{ID}                        {
                                if(yyleng > 8){
                                    printf("%s is longer than 8 characters!\n",yytext);
                                    return 1;
                                }
                                int value = string_to_int(yytext);
                                int j = 0;
                                while(strlen(TS[d(value, j)]) && strcmp(TS[d(value, j)], yytext)) j++;
                                strcpy(TS[d(value, j)], yytext);
                                printf("1 ID %d\n", d(value, j));
                            }
{CONST_INT}|{CONST_REAL}    {
                                int value = string_to_int(yytext);
                                int j = 0;
                                while(strlen(TS[d(value, j)]) && strcmp(TS[d(value, j)], yytext)) j++;
                                strcpy(TS[d(value, j)], yytext);
                                printf("0 CONST %d\n", d(value, j));
                            }

.

%%

int main(){
    TS = (char**)malloc(m * sizeof(char*));
    for(int i = 0; i < m; i++){
        TS[i] = (char*)malloc(100*sizeof(char));
        TS[i][0] = '\0';
    }
    printf("FIP:\n");
    yylex();
    printf("\nTS:\n");
    for(int i = 0; i < m; i++){
        if(strlen(TS[i])){
            printf("%d %s\n", i, TS[i]);
        }
    }
    return 0;
}

