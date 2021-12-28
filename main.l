%option noyywrap
%{
	#include "y.tab.h"
	#define DEBUG_MODE
	int yylex();
	void yyerror (char *s);



%}

digit [0-9]
letter [a-zA-Z]

variable_alphabet [0-9a-zA-Z|_]

new_line \n
delim [ \t]+
the_double ([+-])?{digit}+(\.{digit}+)?(E[+\-]?{digit}+)?
identifire {letter}{variable_alphabet}*
string \"(.)*\"

%%



"(" {
	#ifdef DEBUG_MODE
		/* //std::cout << "open parantez found " << std::endl; */
	#endif
		return '(';
	}
")" {
	#ifdef DEBUG_MODE
		/* //std::cout << "close parantez found " << std::endl; */
	#endif
		return ')';
	}
"{" {
	#ifdef DEBUG_MODE
		//std::cout << "open bracket found " << std::endl;
	#endif
		return '{';
	}
"}" {
	#ifdef DEBUG_MODE
		//std::cout << "close bracket found " << std::endl;
	#endif
		return '}';
	}
":" {
	#ifdef DEBUG_MODE
		//std::cout << "colons found " << std::endl;
	#endif
		return ':';
	}



"!=" {

	#ifdef DEBUG_MODE
		//std::cout << "not equal found " << std::endl;
	#endif
		return neq;
		}
"==" {

	#ifdef DEBUG_MODE
		//std::cout << "equal found " << std::endl;
	#endif
		return eq;
		}
">=" {

	#ifdef DEBUG_MODE
		//std::cout << "greater equal  found " << std::endl;
	#endif
		return gteq;
		}
"<=" {

	#ifdef DEBUG_MODE
		//std::cout << "less equal found " << std::endl;
	#endif
		return lseq;
		}
">" {

	#ifdef DEBUG_MODE
		//std::cout << "greater  found " << std::endl;
	#endif
		return gt;
		}
"<" {

	#ifdef DEBUG_MODE
		//std::cout << "less found " << std::endl;
	#endif
		return ls;
		}



"=" {

	#ifdef DEBUG_MODE
		printf("LEX: %s\n", yytext);
	#endif
		return '=';
		}
"-=" {

	#ifdef DEBUG_MODE
		//std::cout << "assign subtract found " << std::endl;
	#endif
		return ssubber;
		}
"+=" {

	#ifdef DEBUG_MODE
		//std::cout << "assign sum found " << std::endl;
	#endif
		return sadder;
		}
"*=" {

	#ifdef DEBUG_MODE
		//std::cout << "assign multiply found " << std::endl;
	#endif
		return smult;
		}
"/=" {

	#ifdef DEBUG_MODE
		//std::cout << "assign divide found " << std::endl;
	#endif
		return sdivd;
		}

"+" {
	#ifdef DEBUG_MODE
		//std::cout <<" sum found " << std::endl;
	#endif
		return '+';
		}

"-" {
	#ifdef DEBUG_MODE
		//std::cout << " subtract found " << std::endl;
	#endif
		return '-';
		}
"*" {
	#ifdef DEBUG_MODE
		//std::cout << " multiply found " << std::endl;
	#endif
		return '*';
		}
"/" {
	#ifdef DEBUG_MODE
		//std::cout << " divide found " << std::endl;
	#endif
		return '/';
		}
"if" {
	return if_token;
}
"else" {
	return else_token;
}
"while" {
	#ifdef DEBUG_MODE
		//std::cout << " while found " << std::endl;
	#endif
		return while_token;
		}
"for" {
	#ifdef DEBUG_MODE
		//std::cout << " for found " << std::endl;
	#endif
		return for_token;
		}
"continue" {
	#ifdef DEBUG_MODE
		//std::cout << " continue found " << std::endl;
	#endif
		return continue_token;
		}
"break" {
	#ifdef DEBUG_MODE
		//std::cout << " break  found " << std::endl;
	#endif
		return break_token;
		}


"and" {
	#ifdef DEBUG_MODE
		//std::cout << " and found " << std::endl;
	#endif
		return and;
		}
"or" {
	#ifdef DEBUG_MODE
		//std::cout << " or found " << std::endl;
	#endif
		return or;
		}
"not" {
	#ifdef DEBUG_MODE
		//std::cout << " not  found " << std::endl;
	#endif
		return not;
		}



{the_double} {

	yylval.num = atof(yytext);

	#ifdef DEBUG_MODE
		printf("LEX: double: %f\n", yylval.num);
	#endif
		return number;
}

{identifire} {

	strcpy(yylval.id, yytext);

	#ifdef DEBUG_MODE
		printf("LEX: identifire: %s\n", yylval.id);
	#endif
		return identifire;

}
{new_line} {
	#ifdef DEBUG_MODE
		printf("LEX: newline\n");
	#endif

	return new_line;
}

<<EOF>>   {
	return end_of_file;
}



%%


/* int main(int argc, char* argv[])
{
	// if(argc > 1)
	// {
	// 	FILE *fp = fopen(argv[1], "r");
	// 	if(fp)
	// 		yyin = fp;
	// }

	while (1)
		yylex();
	return 1;
} */
