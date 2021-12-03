%option noyywrap
%{
	#include <iostream>
	#include <map>

	#define DEBUG_MODE

    enum Token {
		OPEN_BRACKET,
		CLOSE_BRACKET,
		OPEN_PARANTEZ,
		CLOSE_PARANTEZ,
		COLONS,

        // types
        INTEGER,
        FLOAT,
        STRING,

		//operator
		RELOPE,
		ASSIGN,
		SUM,
		DIVIDE,
		MULTIPLY,
		SUBTRACT,
		REMINDER,

        // conditions
        IF,
        ELSE,
        ELIF,
		AND,
		OR,
		NOT,
        WHILE,
        // loops
        FOR,
        BREAK,
        CONTINUE,

		VARIABLE,

		// new_line
		NEW_LINE,

		NONE_TYPE
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
delim [ \t]+
the_double {digit}+(\.{digit}+)(E[+\-]?{digit}+)?
the_integer {digit}+(E[+\-]?{digit}+)? 
identifire {letter}{variable_alphabet}*
string \"(.)*\"

%%



"(" {
	#ifdef DEBUG_MODE
		std::cout << "open parantez found " << std::endl;
	#endif
		return OPEN_PARANTEZ;
	}
")" {
	#ifdef DEBUG_MODE
		std::cout << "close parantez found " << std::endl;
	#endif
		return CLOSE_PARANTEZ;
	}
"{" {
	#ifdef DEBUG_MODE
		std::cout << "open bracket found " << std::endl;
	#endif
		return OPEN_BRACKET;
	}
"}" {
	#ifdef DEBUG_MODE
		std::cout << "close bracket found " << std::endl;
	#endif
		return CLOSE_BRACKET;
	}
":" {
	#ifdef DEBUG_MODE
		std::cout << "colons found " << std::endl;
	#endif
		return COLONS;
	}



"!=" {
	yylval.c = yytext;
	#ifdef DEBUG_MODE
		std::cout << "not equal found " << std::endl;
	#endif
		return RELOPE;
		}
"==" {
	yylval.c = yytext;
	#ifdef DEBUG_MODE
		std::cout << "equal found " << std::endl;
	#endif
		return RELOPE;
		}
">=" {
	yylval.c = yytext;
	#ifdef DEBUG_MODE
		std::cout << "greater equal  found " << std::endl;
	#endif
		return RELOPE;
		}
"<=" {
	yylval.c = yytext;
	#ifdef DEBUG_MODE
		std::cout << "less equal found " << std::endl;
	#endif
		return RELOPE;
		}
">" {
	yylval.c = yytext;
	#ifdef DEBUG_MODE
		std::cout << "greater  found " << std::endl;
	#endif
		return RELOPE;
		}
"<" {
	yylval.c = yytext;
	#ifdef DEBUG_MODE
		std::cout << "less found " << std::endl;
	#endif
		return RELOPE;
		}



"=" {
	yylval.c = yytext;
	#ifdef DEBUG_MODE
		std::cout << "assign found " << std::endl;
	#endif
		return ASSIGN;
		}
"-=" {
	yylval.c = yytext;
	#ifdef DEBUG_MODE
		std::cout << "assign subtract found " << std::endl;
	#endif
		return ASSIGN;
		}
"+=" {
	yylval.c = yytext;
	#ifdef DEBUG_MODE
		std::cout << "assign sum found " << std::endl;
	#endif
		return ASSIGN;
		}
"*=" {
	yylval.c = yytext;
	#ifdef DEBUG_MODE
		std::cout << "assign multiply found " << std::endl;
	#endif
		return ASSIGN;
		}
"/=" {
	yylval.c = yytext;
	#ifdef DEBUG_MODE
		std::cout << "assign divide found " << std::endl;
	#endif
		return ASSIGN;
		}
"%=" {
	yylval.c = yytext;
	#ifdef DEBUG_MODE
		std::cout << "assign reminder found " << std::endl;
	#endif
		return ASSIGN;
		}

"+" {
	#ifdef DEBUG_MODE
		std::cout <<" sum found " << std::endl;
	#endif
		return SUM;
		}

"-" {
	#ifdef DEBUG_MODE
		std::cout << " subtract found " << std::endl;
	#endif
		return SUBTRACT;
		}
"*" {
	#ifdef DEBUG_MODE
		std::cout << " multiply found " << std::endl;
	#endif
		return MULTIPLY;
		}
"/" {
	#ifdef DEBUG_MODE
		std::cout << " divide found " << std::endl;
	#endif
		return DIVIDE;
		}
"%" {
	#ifdef DEBUG_MODE
		std::cout << " reminder found " << std::endl;
	#endif
		return REMINDER;
		}



"while" {
	#ifdef DEBUG_MODE
		std::cout << " while found " << std::endl;
	#endif
		return WHILE;
		}
"for" {
	#ifdef DEBUG_MODE
		std::cout << " for found " << std::endl;
	#endif
		return FOR;
		}
"continue" {
	#ifdef DEBUG_MODE
		std::cout << " continue found " << std::endl;
	#endif
		return CONTINUE;
		}
"break " {
	#ifdef DEBUG_MODE
		std::cout << " break  found " << std::endl;
	#endif
		return BREAK;
		}


"and" {
	#ifdef DEBUG_MODE
		std::cout << " and found " << std::endl;
	#endif
		return FOR;
		}
"or" {
	#ifdef DEBUG_MODE
		std::cout << " or found " << std::endl;
	#endif
		return OR;
		}
"not " {
	#ifdef DEBUG_MODE
		std::cout << " not  found " << std::endl;
	#endif
		return NOT;
		}



{the_double} { 

	yylval.d = std::stod(yytext);

	#ifdef DEBUG_MODE
		std::cout << "float found: " << yylval.d << std::endl;
	#endif
		return FLOAT;
}

{the_integer} {
    yylval.i = ((int) std::stod(yytext));
#ifdef DEBUG_MODE
	std::cout << "integer found: " << yylval.i << std::endl;
#endif
    return INTEGER;
}

{string} {
	//todo remove "" at begin and end of text
	yylval.c = yytext;

	#ifdef DEBUG_MODE
		std::cout << "string found: " << yylval.c << std::endl;
	#endif
		return STRING

}

{identifire} {

	yylval.c = yytext;

	#ifdef DEBUG_MODE
		std::cout << "VARIABLE found: " << yylval.c << std::endl;
	#endif
		return VARIABLE

}
{new_line} {
	#ifdef DEBUG_MODE
		std::cout << " new_line found " << std::endl;
	#endif
	
	return NEW_LINE;}

%%


int main(int argc, char* argv[])
{
	// if(argc > 1)
	// {
	// 	FILE *fp = fopen(argv[1], "r");
	// 	if(fp)
	// 		yyin = fp;
	// }

	// while (1) // todo remove it
	yylex();
	return 1;
}
