%{

%}

%token ID CONST IF ELSE WHILE COUT EXTRACTION INT INSERTION HASHTAG CPR OPR PLUS NAMESPACE SEMICOLON MAIN ASSIGN LT GT IOSTREAM VOID USING ENDL STD INCLUDE CIN OCB CCB STAR MINUS NEQUALS CHAR CIRCLE

%%

program : HASHTAG INCLUDE LT IOSTREAM GT USING NAMESPACE STD SEMICOLON VOID MAIN OPR CPR OCB instrs CCB

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

instr_decl : dtype ID SEMICOLON
           ;

dtype : INT
      | CHAR
      | CIRCLE
      ;

instr_assign : ID ASSIGN expr SEMICOLON
             ;

expr : ID
     | CONST
     | ID operator expr
     | CONST operator expr
     ;

operator : STAR
         | MINUS
         | PLUS
         | NEQUALS
         | GT
         | LT
         ;

instr_read : CIN EXTRACTION ID SEMICOLON
           ;

instr_write : COUT INSERTION expr INSERTION ENDL SEMICOLON
            ;

instr_cond : IF OPR expr CPR OCB instrs CCB ELSE OCB instrs CCB
           ;

instr_loop : WHILE OPR expr CPR OCB instrs CCB
           ;



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
    yyparse();
    return 0;
}