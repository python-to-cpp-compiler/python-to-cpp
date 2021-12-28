%{
void yyerror (char *s);
int yylex();


#include <stdio.h>     /* C declarations used in actions */
#include <stdlib.h>
#include <ctype.h>

#define OUTD(X) fprintf(out, "%f", X)
#define OUTS(X) fprintf(out, "%s", X)
#define OUTN() fprintf(out, "\n")
#define OUTT() fprintf(out, "t%d", make_new_id())


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

%token exit_command
%token <num> number
%token <id> identifire


/* %type <num> line exp term
%type <id> assignment */

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

assign      : identifire {OUTS($1);printf("YACC: id: %s\n", $1);} '=' {OUTS("=");} expr                    {printf("YACC: assign id = exp\n");}
            | identifire {OUTS($1);} sadder {OUTS("+=");} expr                 {printf("YACC: assign sadder expr\n");}
            | identifire {OUTS($1);} ssubber {OUTS("-=");} expr                {printf("YACC: assign ssubber expr\n");}
            | identifire {OUTS($1);} smult {OUTS("*=");} expr                  {printf("YACC: assign smult expr\n");}
            | identifire {OUTS($1);} sdivd {OUTS("/=");} expr                  {printf("YACC: assign sdivd expr\n");}
            ;

expr        : expr '+' {OUTS("+");} term                  {printf("YACC: expr + term\n");}
            | expr '-' {OUTS("-");} term                  {printf("YACC: expr - term\n");}
            | term                           {printf("YACC: expr term\n");}
            ;

term        : term '*' {OUTS("*");} factor                {printf("YACC: term * factor\n");}
            | term '/' {OUTS("/");} factor                {printf("YACC: term / factor\n");}
            | factor                         {printf("YACC: term factor\n");}
            ;

factor      : value                          {printf("YACC: factor value\n");}
            | '(' {OUTS("(");} expr ')' {OUTS(")");}        {printf("YACC: factor (expr)\n");}
            ;

value       : number                          {OUTD($1); printf("YACC: value digit\n");}
            | identifire                      {OUTS($1); printf("YACC: value id\n");}
            ;

if_token_state    : if_token relops ':' '{' statements '}' else_token_state    {printf("YACC: if_token if_token\n");}
            ;

else_token_state  : else_token ':' '{' statements '}'              {printf("YACC: else_token else_token\n");}
            | {printf("YACC: else_token not else_token\n");}
            ;

while_token_state : while_token relops ':' '{' statements '}'      {printf("YACC: while_token while_token\n");}
            ;

for_token_state         : for_token range '(' expr ',' expr ',' expr ')' ':' '{' statements '}'  {printf("YACC: for_token for_token\n");}
            ;

relops      : relop                                         {printf("YACC: relops relop\n");}
            | relop and {OUTS("&&");} relops                              {printf("YACC: relops relop and\n");}
            | relop or {OUTS("||");}relops                               {printf("YACC: relops relop or\n");}
            | '(' {OUTS("(");}  relops ')'{OUTS(")");}//todo error with ()                                {printf("YACC: relops (relops)\n");}
            ;

relop       : not {OUTS("!");} relop                                   {printf("YACC: relop not relop\n");}
            | relo                                          {printf("YACC: relop relo\n");}
            ;

relo        : expr rel expr                                  {printf("YACC: relo expr rel expr\n");}
            ;

rel         : eq   {OUTS("==");}                                          {printf("YACC: rel ==\n");}
            | gteq {OUTS(">=");}                                          {printf("YACC: rel >=\n");}
            | lseq {OUTS("<=");}                                          {printf("YACC: rel <=\n");}
            | gt   {OUTS(">");}                                          {printf("YACC: rel >\n");}
            | ls   {OUTS("<");}                                          {printf("YACC: rel <\n");}
            | neq  {OUTS("!=");}                                          {printf("YACC: rel !=\n");}
            ;


%%                     /* C code */

long make_new_id(){
    static long i = 0;
    return i++;
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
