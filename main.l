%option noyywrap
%{
	#include <iostream>
	#include <map>

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

		VARIABLE,

		// new_line
		NEW_LINE,

		NONE_TYPE,
    };

    union Value {
        int i;
        double d;
        char* c;
    };
    union Value yylval;

	class SymbolTableRow{
	private:
		int id;
		Token type;
		Value* v; // todo, required?

	public:
		SymbolTableRow(){
			id = 0;
			type = NONE_TYPE;
			v = nullptr;
		}

	}

	map<std::string, SymbolTableRow*> symbol_table;

%}

digit [0-9]
letter [a-zA-Z]

variable_alphabet [0-9a-zA-Z|_]

new_line \n

%%


[+|-]?{digit}+ {
    yylval.i = atoi(yytext);
#ifdef DEBUG_MODE
	std::cout << "integer found: " << yylval.i << std::endl;
#endif
    return INTEGER;
}

[+|-]?{digit}+\.{digit}+ { // todo for the first digit it can be used * instead of +
    yylval.d = 0;
	int i = 0;
	double e = 1;
	bool dot_found = false;
	bool neg = false;

	while (i < yyleng){
		// check +/-
		if (yytext[i] == '-'){
			neg = true;
			i++;
			continue;
		}
		else if (yytext[i] == '+'){
			i++;
			continue;
		}

		//check dot.
		if (yytext[i] == '.'){
			dot_found = true;
			i++;
			continue;
		}

		// after finding dot add 1 to exponential for each number
		if (dot_found)
			e *= 10;

		// shift number; add other digit to it.
		yylval.d *= 10.;
		yylval.d += yytext[i] - '0';
		i++;

#ifdef DEBUG_MODE
		/* std::cout << "float yyl.d: " << yylval.d << std::endl; */
#endif
	}

	yylval.d = (yylval.d / e) * (neg ? -1 : 1);

#ifdef DEBUG_MODE
	std::cout << "float found: " << yylval.d << std::endl;
#endif
    return FLOAT;
}
{letter}[{variable_alphabet}] {

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
