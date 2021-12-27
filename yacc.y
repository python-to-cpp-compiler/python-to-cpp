%{
void yyerror (char *s);
int yylex();
#include <stdio.h>     /* C declarations used in actions */
#include <stdlib.h>
#include <ctype.h>
int symbols[52];
int symbolVal(char symbol);
void updateSymbolVal(char symbol, int val);
%}

%union {double num; char* id;}         /* Yacc definitions */

%start statements

%token if
%token else
%token for
%token while
%token range
%token eq
%token neq
%token gt
%token gteq
%token ls
%token lseq

%token exit_command
%token <num> number
%token <id> id


/* %type <num> line exp term
%type <id> assignment */

%%


statements  : assign new_line statements    {printf("statements assign");}
            | if_state statements                 {printf("statements if");}
            | for_state statements                {printf("statements for");}
            | while_state statements              {printf("statements while");}
            | new_line statements           {printf("statements new_line");}
            ;

assing      : id '=' expr                    {printf("assign id = exp");}
            ;

expr        : expr '+' term                  {printf("expr + term");}
            | expr '-' term                  {printf("expr - term");}
            | term                           {printf("expr term");}
            ;

term        : term '*' factor                {printf("term * factor");}
            | term '/' factor                {printf("term / factor");}
            | factor                         {printf("term factor");}
            ;

factor      : value                          {printf("factor value");}
            | '(' expr ')'                   {printf("factor (expr)");}
            ;

value       : number                          {printf("value digit");}
            | id                             {printf("value id");}
            ;

if_state    : if relops ':' '{' statements '}' else_state    {printf("if if");}
            ;

else_state  : else ':' '{' statements '}'              {printf("else else");}
            | {printf("else not else");}
            ;

while_state : while relops ':' '{' statements '}'      {printf("while while");}
            ;

for_state         : for range '(' epxr ',' epxr ',' epxr ')' ':' '{' statements '}'  {printf("for for");}
            ;

relops      : relop                                         {printf("relops relop");}
            | relop and relops                            {printf("relops relop and");}
            | relop or relops                             {printf("relops relop or");}
            | '(' relops ')'                                {printf("relops (relops)");}
            ;

relop       : "not" relop                                   {printf("relop not relop");}
            | relo                                          {printf("relop relo");}
            ;

relo        : expr rel expr                                  {printf("relo expr rel expr");}
            ;

rel         : eq                                           {printf("rel ==");}
            | gteq                                           {printf("rel >=");}
            | lseq                                           {printf("rel <=");}
            | gt                                           {printf("rel >");}
            | ls                                            {printf("rel <");}
            | neq                                           {printf("rel !=");}
            ;


%%                     /* C code */

int computeSymbolIndex(char token)
{
	int idx = -1;
	if(islower(token)) {
		idx = token - 'a' + 26;
	} else if(isupper(token)) {
		idx = token - 'A';
	}
	return idx;
}

/* returns the value of a given symbol */
int symbolVal(char symbol)
{
	int bucket = computeSymbolIndex(symbol);
	return symbols[bucket];
}

/* updates the value of a given symbol */
void updateSymbolVal(char symbol, int val)
{
	int bucket = computeSymbolIndex(symbol);
	symbols[bucket] = val;
}

int main (void) {
	/* init symbol table */
	int i;
	for(i=0; i<52; i++) {
		symbols[i] = 0;
	}

	return yyparse ( );
}

void yyerror (char *s) {fprintf (stderr, "%s\n", s);}
