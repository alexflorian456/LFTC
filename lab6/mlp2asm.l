%{
#include<stdio.h>
#include<string.h>

#include"attrib.h"
#include"mlp2asm.tab.h"

extern int line;

%}

ID      [a-zA-Z][a-zA-Z0-9]*
CONST   0|[1-9][0-9]*

%%

[ \t\r]
\n {line++;}

"#" {return HASHTAG;}
"include" {return INCLUDE;}
"<" {return LT;}
">" {return GT;}
"iostream" {return IOSTREAM;}
"using" {return USING;}
"namespace" {return NAMESPACE;}
"std" {return STD;}
";" {return SEMICOLON;}
"void" {return VOID;}
"main" {return MAIN;}
"(" {return OPR;}
")" {return CPR;}
"{" {return OCB;}
"}" {return CCB;}
"int" {return INT;}
"cin" {return CIN;}
"cout" {return COUT;}
"endl" {return ENDL;}
">>" {return EXTRACTION;}
"<<" {return INSERTION;}
"=" {return ASSIGN;}
"+" {return ADD;}
"-" {return SUB;}
"*" {return MUL;}
"/" {return DIV;}
"return" {return RETURN;}

{ID}    {
            strcpy(yylval.varname, yytext);
            return ID;
        }
{CONST} {
            strcpy(yylval.varname, yytext);
            return CONST;
        }

. {printf("illegal character %s on line %d\n", yytext, line);}

%%

int yywrap(){
    return 1;
}