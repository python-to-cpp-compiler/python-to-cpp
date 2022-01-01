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


struct Tree* table;


void insertIdIfnotExist(char * theId);
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
%token range_token
%token exit_command
%token print_token

%token <num> number
%token <id> identifire

%type <data> expr factor term


%%

start_state : {table = make_tree(NULL);OUTS("#include <stdio.h>\nint main (int argc, char* argv[]) {\n");} statements {OUTS("return 0;\n}");exit(EXIT_SUCCESS);}
            ;

statements  : state  statements
            | end_of_file
            ;


state : assign
      | new_line {OUTN();}
      | break_token {OUTS("break;\n");}
      | continue_token {OUTS("continue;\n");}
      | if_statment
      | for_token_state
      | while_token_state
      | print_state
      ;

print_state : print_token '(' expr ')' {multiple_print(4, calculate($<data>3, table), "printf(\"%f\\n\",", $<data>3->tmp, ");\n");}

inside_statements  : state  inside_statements
                   | '}'
                   ;

assign      :  identifire  assignment  rhandside       {insertIdIfnotExist($<id>1);multiple_print(7,calculate($<data>3,table),$1," ",$<id>2," ",$<data>3->tmp,";\n");}
            ;
rhandside   : expr      {$<data>$ = $<data>1;}
            | relops    {$<data>$ = $<data>1;}
            ;

else_statment : else_token ':' '{' {multiple_print(1,"else {\n");table = make_tree(table);} inside_statements {OUTS("}\n");table = goto_parent(table);}
              | {;}
              ;

if_statment   : if_token  relops {multiple_print(4,calculate($<data>2,table),"if(",$<data>2->tmp,"){\n");table = make_tree(table);}':' '{' inside_statements {OUTS("}\n");table = goto_parent(table);} else_statment
              ;


assignment  : '='         {$<id>$ = "=";}
            | sadder      {$<id>$ = "+=";}
            | ssubber     {$<id>$ = "-=";}
            | smult       {$<id>$ = "*=";}
            | sdivd       {$<id>$ = "/=";}
            ;

expr        : expr '+'  term   {$<data>$ = insert($<data>1, $<data>3,"+", 0, NULL, createTemp());}
            | expr '-'  term   {$<data>$ = insert($<data>1,  $<data>3,"-", 0, NULL, createTemp());}
            | term             {$<data>$ = $<data>1;}
            ;

term        : term '*'  signNumber   {$<data>$ = insert($<data>1, $<data>3,"*",  0, NULL, createTemp());}
            | term '/'  signNumber   {$<data>$ = insert($<data>1, $<data>3, "/", 0, NULL, createTemp());}
            | signNumber             {$<data>$ = $<data>1;}
            ;

signNumber  : '+' factor    {$<data>$ = insert($<data>2, NULL, "un+", 0, NULL, createTemp());}
            | '-' factor    {$<data>$ = insert($<data>2, NULL, "un-", 0, NULL, createTemp());}
            | factor        {$<data>$ = $<data>1;}
            ;

factor      :  value {$<data>$ = $<data>1;}
            | '('  expr ')' {$<data>$ = $<data>2;}
            ;

value       : number                          {$<data>$ = insert(NULL, NULL, NULL, $<num>1, NULL, createTemp());}
            | identifire                      {$<data>$ = insert(NULL, NULL, NULL, 0, $<id>1, createTemp()); }
            ;

relops      : relop                           {$<data>$ = $<data>1;}
            | relop and  relops               {$<data>$ = insert($<data>1, $<data>3,"&&", 0, NULL, createTemp());}
            | relop or  relops                {$<data>$ = insert($<data>1, $<data>3,"||", 0, NULL, createTemp());}
            | '('   relops ')'                {$<data>$ = $<data>2;}
            ;

relop       : not  relop                      {$<data>$ = insert($<data>2, NULL,"!", 0, NULL, createTemp());}
            | relo                            {$<data>$ = $<data>1;}
            ;

relo        : expr rel expr                   {$<data>$ = insert($<data>1, $<data>3, $<id>2, 0, NULL, createTemp());}
            ;

rel         : eq   {$<id>$ = "==";}
            | gteq {$<id>$ = ">=";}
            | lseq {$<id>$ = "<=";}
            | gt   {$<id>$ = ">";}
            | ls   {$<id>$ = "<";}
            | neq  {$<id>$ = "!=";}
            ;


for_token_state         : for_token identifire in_token range_token '(' expr ',' expr ',' expr ')' ':' '{' {insertIdIfnotExist($2);multiple_print(18,calculate($<data>6,table),calculate($<data>8,table),calculate($<data>10,table),"for(",$2," = ",$<data>6->tmp,"; ",$2," < ",$<data>8->tmp," ;",$2,"=",$2," + ",$<data>10->tmp,"){\n");table = make_tree(table);} inside_statements {OUTS("}\n");table = goto_parent(table);}
            ;

while_token_state : while_token relops ':' '{' {multiple_print(4,calculate($<data>2,table),"while(",$<data>2->tmp,"){\n");table = make_tree(table);} inside_statements   {multiple_print(2,calculate($<data>2,table),"}\n");table = goto_parent(table);}
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
    sprintf(temp,"t%ld",temp_counter);
    temp_counter++;
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
void insertIdIfnotExist(char * theId){
    if(find_by_id_in_tree(table,theId) == NULL){
        insert_in_tree_if_not_exist(table,theId);
        multiple_print(3,"double ",theId,";\n");
        }
}


int main (int argc, char* argv[]) {
    if(argc > 1)
    {
    	yyin = fopen(argv[1], "r");
    }
    else
        printf("YACC: no file input\n");
    if(argc > 2)
    {
        out = fopen(argv[2], "w");
    }
    else
        out = fopen("result.c", "w");
    return yyparse ();
}

void yyerror (char *s) {fprintf (stderr, "ERR: %s\n", s);}
