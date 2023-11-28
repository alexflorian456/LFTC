%{

%}

%token ID
%token CONST

%%

program : 'include<iostream>' 'using namespace std;' 'void main(){' instrs '}'

instrs : %empty
       | instr
       | instr instrs
       ;

instr : instr_decl
      | instr_assign
      | instr_read
      | instr_write
      | instr_cond
      | instr_loop
      ;

instr_decl : dtype ID ';'
           ;

dtype : 'int'
      | 'char'
      | 'circle'
      ;

instr_assign : ID '=' expr ';'
             ;

expr : ID
     | CONST
     | ID operator expr
     | CONST operator expr
     ;

operator : '*'
         | '-'
         | '+'
         | '!='
         | '>'
         ;

instr_read : 'cin' '>>' ID ';'
           ;

instr_write : 'cout' '<<' expr '<<' 'endl' ';'
            ;

instr_cond : 'if' '(' expr ')' '{' instrs '}' 'else' '{' instrs '}'
           ;

instr_loop : 'while' '(' expr ')' '{' instrs '}'
           ;



%%

