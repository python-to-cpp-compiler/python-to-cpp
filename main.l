%option noyywrap
%{
	#include <stdlib.h>
	#include <stdio.h>

	#define DEBUG_MODE

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

		// new_line
		NEW_LINE,
    };

    union Value {
        int i;
        double d;
        char* c;
    };
    union Value yylval;
%}

digit [0-9]

new_line \n

%%


[+|-]?{digit}+ {
    yylval.i = atoi(yytext);
#ifdef DEBUG_MODE
	printf("integer found: %d\n", yylval.i);
#endif
    return INTEGER;
}

[+|-]?{digit}+\.{digit}+ { // todo for the first digit it can be used * instead of +
    yylval.d = atoi(yytext);
#ifdef DEBUG_MODE
	printf("float found: %f\n", yylval.d);
#endif
    return FLOAT;
}

{new_line} {return NEW_LINE;}

%%

int main(int argc, char* argv[])
{
	if(argc > 1)
	{
		FILE *fp = fopen(argv[1], "r");
		if(fp)
			yyin = fp;
	}

	while (1) // todo remove it
		yylex();
	return 1;
}
