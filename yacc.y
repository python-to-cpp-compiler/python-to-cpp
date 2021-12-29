%{
void yyerror (char *s);
int yylex();
int countDigit(long number2);
char* createTemp();
void rest_temp();

#include <stdio.h>     /* C declarations used in actions */
#include <stdlib.h>
#include <ctype.h>
#include <stdarg.h>
#include "structures.h"

#define OUTD(X) fprintf(out, "%f", X)
#define OUTS(X) fprintf(out, "%s", X)
#define OUTN() fprintf(out, "\n")
#define OUTT() fprintf(out, "t%d", make_new_id())
#define OUTDV(X) fprintf(out, "double %s;\n",X)

int symbols[52];
int symbolVal(char symbol);
void updateSymbolVal(char symbol, int val);
void multiple_print(int num, ...);
extern FILE * yyin;
FILE* out;
%}

%union {struct CalcList* data; double num; char* id;}         /* Yacc definitions */

%start start_state

%token if_token
%token else_token
%token for_token
%token while_token
%token range
%token eq
%token neq
%token gt
%token gteq
%token ls
%token lseq
%token not
%token and
%token or
%token new_line
%token end_of_file
%token sadder
%token ssubber
%token smult
%token sdivd
%token break_token
%token continue_token
%token in_token
%token exit_command
%token <num> number
%token <id> identifire

%type <data> expr factor term


%%

start_state : {OUTS("int main (int argc, char* argv[]) {\n");} statements {OUTS("return 0;\n}");exit(EXIT_SUCCESS);}
            ;

statements  : assign  statements    {printf("YACC: statements assign\n");}
            | new_line {OUTN();} statements           {printf("YACC: statements new_line\n");}
            | end_of_file   {printf("YACC: statements end of file");}
            | break_token {OUTS("break;\n");} statements              {printf("YACC: statements break_token\n");}
            | continue_token {OUTS("continue;\n");} statements           {printf("YACC: statements continue_token\n");}
            ;

assign      :  identifire  '='  expr       {printf("eval location\n");printf("%s", calculate($<data>3));printf("%s = %s;\n",$1,$<data>3->tmp);multiple_print(5,calculate($<data>3),$1," = ",$<data>3->tmp,";\n");}
            | {;} identifire {;} sadder expr     {OUTDV($2);OUTS($2);OUTS(" += ");OUTS($5);OUTS(";");OUTN();}      {printf("YACC: assign sadder expr\n");}
            | {;} identifire {;} ssubber expr    {OUTDV($2);OUTS($2);OUTS(" -= ");OUTS($5);OUTS(";");OUTN();}      {printf("YACC: assign ssubber expr\n");}
            | {;} identifire {;} smult expr      {OUTDV($2);OUTS($2);OUTS(" *= ");OUTS($5);OUTS(";");OUTN();}      {printf("YACC: assign smult expr\n");}
            | {;} identifire {;} sdivd expr      {OUTDV($2);OUTS($2);OUTS(" /= ");OUTS($5);OUTS(";");OUTN();}      {printf("YACC: assign sdivd expr\n");}
            ;

expr        : expr '+'  term   {$<data>$ = insert($<data>1, $<data>3,"+", 0, NULL, createTemp());}
            | expr '-'  term   {$<data>$ = insert($<data>1,  $<data>3,"-", 0, NULL, createTemp());} 
            | term             {$<data>$ = $<data>1;} {printf("YACC: expr term\n");}
            ;

term        : term '*'  factor   {$<data>$ = insert($<data>1, $<data>3,"*",  0, NULL, createTemp());}
            | term '/'  factor   {$<data>$ = insert($<data>1, $<data>3, "/", 0, NULL, createTemp());} 
            | factor             {$<data>$ = $<data>1;} 
            ;

factor      :  value {$<data>$ = $<data>1;}                                 
            | '('  expr ')' {$<data>$ = $<data>2;}                                         
            ;

value       : number                          {$<data>$ = insert(NULL, NULL, NULL, $<num>1, NULL, createTemp());}
            | identifire                      {$<data>$ = insert(NULL, NULL, NULL, 0, $<id>1, createTemp()); }
            ;


%%                     /* C code */
long temp_counter = 0;
int countDigit(long number2){
    int count = 0;
    while(number2 != 0){
        number2 /= 10 ;
        count++;
    }
    return count;
}
char* createTemp(){
    char* temp;
    int temp_size = countDigit(temp_counter) + 3;
    temp = (char*)malloc(sizeof(char) * (temp_size));
    sprintf(temp,"t%ld\0",temp_counter);
    temp_counter++;
    printf("tmp: %s, %d\n", temp, temp_size);
    printf("address: %p\n", temp);
    return temp;
}

void rest_temp(){
    temp_counter = 0;
}

void multiple_print(int num, ...)
{
    va_list valist;
  
    int  i;
    char* word;
    va_start(valist, num);
    for (i = 0; i < num; i++){ 
        word = va_arg(valist, char*);
        OUTS(word);
    }

  
    va_end(valist);
  
}


int main (int argc, char* argv[]) {
    if(argc > 1)
    {
        printf("HI5\n");
    	yyin = fopen(argv[1], "r");
        printf("HI4\n");
    }
    else
        printf("YACC: no file input\n");
    printf("HI\n");
    out = fopen("result.c", "w");
    printf("HI2\n");
    return yyparse ();
    printf("HI3\n");
}

void yyerror (char *s) {fprintf (stderr, "ERR: %s\n", s);}
