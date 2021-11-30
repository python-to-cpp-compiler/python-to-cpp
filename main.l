%option noyywrap
%{
	#include <stdlib.h>
	#include <stdio.h>
%}

number [0-9]+

%%

{number} {printf("Found : %d\n",atoi(yytext));}

%%

main(int argc, char* argv[])
{
	if(argc > 1)
	{
		FILE *fp = fopen(argv[1], "r");
		if(fp)
			yyin = fp;
	}
	yylex();
	return 1;
}
