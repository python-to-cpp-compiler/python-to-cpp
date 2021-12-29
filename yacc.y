%{
void yyerror (char *s);
int yylex();
int countDigit(long number);
void createTemp(char* temp);
void rest_temp();

#include <stdio.h>     /* C declarations used in actions */
#include <stdlib.h>
#include <ctype.h>

#define OUTD(X) fprintf(out, "%f", X)
#define OUTS(X) fprintf(out, "%s", X)
#define OUTN() fprintf(out, "\n")
#define OUTT() fprintf(out, "t%d", make_new_id())
#define OUTDV(X) fprintf(out, "double %s ;",X)

int symbols[52];
int symbolVal(char symbol);
void updateSymbolVal(char symbol, int val);
extern FILE * yyin;
FILE* out;
%}

%union {double num; char id[100];}         /* Yacc definitions */

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

%type <id> expr factor term relops relop relo rel


%%

start_state : statements {;}
            ;

statements  : assign {OUTS(";");} statements    {printf("YACC: statements assign\n");}
            | relops {OUTS(";");} statements    {printf("YACC: statements relop\n");}
            | if_token_state statements                 {printf("YACC: statements if_token\n");}
            | for_token_state statements                {printf("YACC: statements for_token\n");}
            | while_token_state statements              {printf("YACC: statements while_token\n");}
            | new_line {OUTN();} statements           {printf("YACC: statements new_line\n");}
            | end_of_file                   {printf("YACC: statements end of file");exit(EXIT_SUCCESS);}
            | break_token {OUTS(";");} statements              {printf("YACC: statements break_token\n");}
            | continue_token {OUTS(";");} statements           {printf("YACC: statements continue_token\n");}
            ;

assign      : identifire '='  expr       {OUTDV($1);OUTS($1);OUTS(" = ");rest_temp();OUTS($3);OUTS(";");OUTN();}       {printf("YACC: assign id = exp\n");}
            | identifire sadder expr     {OUTDV($1);OUTS($1);OUTS(" += ");rest_temp();OUTS($3);OUTS(";");OUTN();}      {printf("YACC: assign sadder expr\n");}
            | identifire ssubber expr    {OUTDV($1);OUTS($1);OUTS(" -= ");rest_temp();OUTS($3);OUTS(";");OUTN();}      {printf("YACC: assign ssubber expr\n");}
            | identifire smult expr      {OUTDV($1);OUTS($1);OUTS(" *= ");rest_temp();OUTS($3);OUTS(";");OUTN();}      {printf("YACC: assign smult expr\n");}
            | identifire sdivd expr      {OUTDV($1);OUTS($1);OUTS(" /= ");rest_temp();OUTS($3);OUTS(";");OUTN();}      {printf("YACC: assign sdivd expr\n");}
            ;

expr        : expr '+'  term  {createTemp($$);OUTDV($$);OUTS($$);OUTS(" = ");OUTS($1);OUTS(" + ");OUTS($3);OUTS(";");OUTN();}   {printf("YACC: expr + term\n");}
            | expr '-'  term  {createTemp($$);OUTDV($$);OUTS($$);OUTS(" = ");OUTS($1);OUTS(" - ");OUTS($3);OUTS(";");OUTN();}   {printf("YACC: expr - term\n");}
            | term            {printf("YACC: expr term\n");}
            ;

term        : term '*'  factor  {createTemp($$);OUTDV($$);OUTS($$);OUTS(" = ");OUTS($1);OUTS(" * ");OUTS($3);OUTS(";");OUTN();}  {printf("YACC: term * factor\n");}
            | term '/'  factor  {createTemp($$);OUTDV($$);OUTS($$);OUTS(" = ");OUTS($1);OUTS(" / ");OUTS($3);OUTS(";");OUTN();}  {printf("YACC: term / factor\n");}
            | factor                         {printf("YACC: term factor\n");}
            ;

factor      : {createTemp($$);OUTDV($$);OUTS($$);OUTS(" = ");} value {OUTS(";");OUTN();} {printf("YACC: factor value\n");}
            | '('  expr ')' {$$ = $2}                                          {printf("YACC: factor (expr)\n");}
            ;

value       : number                          {OUTD($1); printf("YACC: value digit\n");}
            | identifire                      {OUTS($1); printf("YACC: value id\n");}
            ;

if_token_state    : if_token relops ':' '{'  {OUTS("if( ");OUTS($2);OUTS(" ) {");}  statements '}'{OUTS("}");OUTN();} else_token_state    {printf("YACC: if_token if_token\n");}
            ;

else_token_state  : else_token ':' {OUTS("else { ");OUTN();} '{'  statements '}'   {OUTS("}");OUTN();} {printf("YACC: else_token else_token\n");}
            | {printf("YACC: else_token not else_token\n");}
            ;

while_token_state : while_token relops ':' '{' statements '}'      {printf("YACC: while_token while_token\n");}
            ;

for_token_state   : for_token identifire in_token range '(' expr ',' expr ',' expr ')' ':' {OUTDV($2);OUTS("for( ");OUTS($2);OUTS(" = ");OUTS($6);OUTS(" ; "); OUTS($2);OUTS(" < ");OUTS($8);OUTS(" ; ");OUTS($2);OUTS(" += ");OUTS($10);OUTS("{")} '{' statements '}' {OUTS("}");OUTN();}  {printf("YACC: for_token for_token\n");}
            ;

relops      : relop              {$$ = $1;}                                         {printf("YACC: relops relop\n");}
            | relop and  relops  {createTemp($$);OUTDV($$);OUTS("OUTS("$$");");OUTS(" = ");OUTS("$1");OUTS(" && ");OUTS("$3");OUTS(" ;");OUTN();}                            {printf("YACC: relops relop and\n");}
            | relop or   relops  {createTemp($$);OUTDV($$);OUTS("OUTS("$$");");OUTS(" = ");OUTS("$1");OUTS(" || ");OUTS("$3");OUTS(" ;");OUTN();}                               {printf("YACC: relops relop or\n");}
            | '(' relops ')'     {$$ = $2;}                                         {printf("YACC: relops (relops)\n");}
            ;

relop       : not {OUTS("!");} relo  {$$ = $2}                       {printf("YACC: relop not relop\n");}
            | relo   {$$ = $1;}                                       {printf("YACC: relop relo\n");}
            ;

relo        : expr rel expr  {createTemp($$);OUTDV($$);OUTS("OUTS("$$");");OUTS(" = ");OUTS("$1");OUTS($2);OUTS("$3");OUTS(" ;");OUTN();}                                {printf("YACC: relo expr rel expr\n");}
            ;

rel         : eq   {$$ = $1;}                                          {printf("YACC: rel ==\n");}
            | gteq {$$ = $1;}                                          {printf("YACC: rel >=\n");}
            | lseq {$$ = $1;}                                          {printf("YACC: rel <=\n");}
            | gt   {$$ = $1}                                          {printf("YACC: rel >\n");}
            | ls   {$$ = $1}                                          {printf("YACC: rel <\n");}
            | neq  {$$ = $1;}                                          {printf("YACC: rel !=\n");}
            ;


%%                     /* C code */
long temp_counter = 0;
int countDigit(long number){
    int count = 0;
    while(number != 0){
        number /= 10 ;
        count++;
    }
    return count;
}
void createTemp(char* temp){
    int temp_size = countDigit(temp_counter) + 3;
    temp = malloc(sizeof(char) * (temp_size));
    sprintf(temp,"t%ld",temp_size);
    temp_counter++;
}

void rest_temp(){
    temp_counter = 0;
}


int main (int argc, char* argv[]) {
    if(argc > 1)
    {
    	yyin = fopen(argv[1], "r");
    }
    else
        printf("YACC: no file input\n");
    out = fopen("result.c", "w");
    return yyparse ();
}

void yyerror (char *s) {fprintf (stderr, "ERR: %s\n", s);}
