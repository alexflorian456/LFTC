%{

#include<stdio.h>
#include<stdlib.h>
#include<string.h>

#include"sintactic.tab.h"

int line = 1;

int yywrap(){
    return 1;
}

%}

ID          [a-zA-Z][a-zA-Z0-9]*   
CONST_INT   0|[1-9][0-9]*
CONST_REAL  (0|[1-9][0-9]*)?\.[0-9]+

%%

[ \t\r]
\n {line++;}

"if" {return IF;}
"else" {return ELSE;}
"while" {return WHILE;}
"cout" {return COUT;}
">>" {return EXTRACTION ;}
"int" {return INT;}
"<<" {return INSERTION ;}
"#" {return HASHTAG ;}
")" {return CPR;}
"(" {return OPR;}
"+" {return PLUS;}
"namespace" {return NAMESPACE;}
";" {return SEMICOLON;}
"main" {return MAIN;}
"=" {return ASSIGN;}
"<" {return LT;}
">" {return GT;}
"iostream" {return IOSTREAM;}
"void" {return VOID;}
"using" {return USING;}
"endl" {return ENDL;}
"std" {return STD;}
"include" {return INCLUDE;}
"cin" {return CIN;}
"{" {return OCB;}
"}" {return CCB;}
"*" {return STAR;}
"-" {return MINUS;}
"!=" {return NEQUALS;}
"char" {return CHAR;}
"circle" {return CIRCLE;}

{ID}    {
            if(strlen(yytext)>8){
                printf("Error: ID name longer than 8 characters: %s\n",yytext);
                exit(1);
            }
            return ID;
        }
{CONST_INT}|{CONST_REAL} {return CONST;}

.

%%

