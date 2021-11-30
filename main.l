%option noyywrap
%{
	#include <stdlib.h>
	#include <stdio.h>

    enum Token {
        // types
        INTEGER,
        FLOAT,
        STRING,

        // conditions
        IF,
        ELSE,
        ELIF,

        WHILE,
        // loops
        FOR,
        BREAK,
        CONTINUE,
    };

%}

digit [0-9]

%%


[+|-]{digit}+ {
    /* yylval.iValue = atoi(yytext); */
    return INTEGER;
}

[+|-]{digit}+\.{digit}+ {
    /* yylval.d = atoi(yytext); */
    return FLOAT;
}

%%

int main(int argc, char* argv[])
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
