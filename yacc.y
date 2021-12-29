%{
void yyerror (char *s);
int yylex();
int countDigit(long number2);
char* createTemp();
void rest_temp();

#include <stdio.h>     /* C declarations used in actions */
#include <stdlib.h>
#include <ctype.h>

#include "structures.h"

#define OUTD(X) fprintf(out, "%f", X)
#define OUTS(X) fprintf(out, "%s", X)
#define OUTN() fprintf(out, "\n")
#define OUTT() fprintf(out, "t%d", make_new_id())
#define OUTDV(X) fprintf(out, "double %s;\n",X)

int symbols[52];
int symbolVal(char symbol);
void updateSymbolVal(char symbol, int val);
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

start_state : {printf("HI25\n");printf("HI26\n");}statements {;}
            ;

statements  : {printf("HI30\n");fflush(stdout);} assign {OUTS(";");} statements    {printf("YACC: statements assign\n");}
            | {printf("HI31\n");} new_line {OUTN();} statements           {printf("YACC: statements new_line\n");}
            | {printf("HI32\n");} end_of_file                   {printf("YACC: statements end of file");exit(EXIT_SUCCESS);}
            | {printf("HI33\n");} break_token {OUTS("break");OUTS(";");} statements              {printf("YACC: statements break_token\n");}
            | {printf("HI34\n");} continue_token {OUTS(";");} statements           {printf("YACC: statements continue_token\n");}
            ;

assign      : {printf("HI40\n");fflush(stdout);} identifire {printf("HI50\n");fflush(stdout);} '='  expr       {printf("HEEEEEEEEEEEREEEEEEEEEEEEEEEEEEE\n");printf("%s", calculate($<data>5));}       {printf("YACC: assign id = exp\n");}
            | {printf("HI41\n");fflush(stdout);} identifire {printf("HI51\n");fflush(stdout);} sadder expr     {OUTDV($2);OUTS($2);OUTS(" += ");OUTS($5);OUTS(";");OUTN();}      {printf("YACC: assign sadder expr\n");}
            | {printf("HI42\n");fflush(stdout);} identifire {printf("HI52\n");fflush(stdout);} ssubber expr    {OUTDV($2);OUTS($2);OUTS(" -= ");OUTS($5);OUTS(";");OUTN();}      {printf("YACC: assign ssubber expr\n");}
            | {printf("HI43\n");fflush(stdout);} identifire {printf("HI53\n");fflush(stdout);} smult expr      {OUTDV($2);OUTS($2);OUTS(" *= ");OUTS($5);OUTS(";");OUTN();}      {printf("YACC: assign smult expr\n");}
            | {printf("HI44\n");fflush(stdout);} identifire {printf("HI54\n");fflush(stdout);} sdivd expr      {OUTDV($2);OUTS($2);OUTS(" /= ");OUTS($5);OUTS(";");OUTN();}      {printf("YACC: assign sdivd expr\n");}
            ;

expr        : expr '+'  term   {$<data>$ = insert($<data>1, "+", $<data>3, 0, NULL, createTemp()); printf("calculate+: %s", calculate($<data>$));} {printf("YACC: expr + term\n");}
            | expr '-'  term   {$<data>$ = insert($<data>1, "-", $<data>3, 0, NULL, createTemp());} {printf("YACC: expr - term\n");}
            | term             {$<data>$ = $<data>1;} {printf("YACC: expr term\n");}
            ;

term        : term '*'  factor   {$<data>$ = insert($<data>1, "*", $<data>3, 0, NULL, createTemp());} {printf("YACC: term * factor\n");}
            | term '/'  factor   {$<data>$ = insert($<data>1, "/", $<data>3, 0, NULL, createTemp());} {printf("YACC: term / factor\n");}
            | factor             {$<data>$ = $<data>1;} {printf("YACC: term factor\n");}
            ;

factor      :  value {$<data>$ = $<data>1;printf("HI62\n");}                                 {printf("YACC: factor value\n");}
            | '('  expr ')' {$<data>$ = $<data>2;}                                          {printf("YACC: factor (expr)\n");}
            ;

value       : number                          {$<data>$ = insert(NULL, NULL, NULL, $<num>1, NULL, createTemp()); printf("YACC: value digit\n");}
            | identifire                      {printf("HI80\n");$<data>$ = insert(NULL, NULL, NULL, 0, $<id>1, createTemp()); printf("YACC: value id\n");}
            ;


%%                     /* C code */
long temp_counter = 0;
int countDigit(long number2){
    printf("HI20\n");
    int count = 0;
    while(number2 != 0){
        number2 /= 10 ;
        count++;
    }
    printf("HI21\n");
    return count;
}
char* createTemp(){
    char* temp;
    printf("HI10\n");
    int temp_size = countDigit(temp_counter) + 3;
    temp = (char*)malloc(sizeof(char) * (temp_size));
    sprintf(temp,"t%ld\0",temp_counter);
    temp_counter++;
    printf("HI11\n");
    printf("tmp: %s, %d\n", temp, temp_size);
    printf("address: %p\n", temp);
    return temp;
}

void rest_temp(){
    temp_counter = 0;
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
