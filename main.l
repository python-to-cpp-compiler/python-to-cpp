%option noyywrap
%{
	#include <string.h>
	#include "y.tab.h"
	/* #define DEBUG_MODE */
	int yylex();
	void yyerror (char *s);



%}

digit [0-9]
letter [a-zA-Z]

variable_alphabet [0-9a-zA-Z|_]

new_line \n
delim [ \t]+
the_double {digit}+(\.{digit}+)?(E[+\-]?{digit}+)?
identifire {letter}{variable_alphabet}*
string \"(.)*\"

%%



"(" {
	#ifdef DEBUG_MODE
		printf("open parantez found " );
	#endif
		return '(';
	}
")" {
	#ifdef DEBUG_MODE
		printf("close parantez found " );
	#endif
		return ')';
	}
"{" {
	#ifdef DEBUG_MODE
		printf("open bracket found " );
	#endif
		return '{';
	}
"}" {
	#ifdef DEBUG_MODE
		printf("close bracket found " );
	#endif
		return '}';
	}
":" {
	#ifdef DEBUG_MODE
		printf("colons found " );
	#endif
		return ':';
	}
"," {
	#ifdef DEBUG_MODE
		printf(", found " );
	#endif
		return ',';
}


"!=" {

	#ifdef DEBUG_MODE
		printf("not equal found " );
	#endif
		return neq;
		}
"==" {

	#ifdef DEBUG_MODE
		printf("equal found " );
	#endif
		return eq;
		}
">=" {

	#ifdef DEBUG_MODE
		printf("greater equal  found " );
	#endif
		return gteq;
		}
"<=" {

	#ifdef DEBUG_MODE
		printf("less equal found " );
	#endif
		return lseq;
		}
">" {

	#ifdef DEBUG_MODE
		printf("greater  found " );
	#endif
		return gt;
		}
"<" {

	#ifdef DEBUG_MODE
		printf("less found " );
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
		printf("assign subtract found " );
	#endif
		return ssubber;
		}
"+=" {

	#ifdef DEBUG_MODE
		printf("assign sum found " );
	#endif
		return sadder;
		}
"*=" {

	#ifdef DEBUG_MODE
		printf("assign multiply found " );
	#endif
		return smult;
		}
"/=" {

	#ifdef DEBUG_MODE
		printf("assign divide found " );
	#endif
		return sdivd;
		}

"+" {
	#ifdef DEBUG_MODE
		printf("plus found " );
	#endif
		return '+';
		}

"-" {
	#ifdef DEBUG_MODE
		printf(" subtract found " );
	#endif
		return '-';
		}
"*" {
	#ifdef DEBUG_MODE
		printf(" multiply found " );
	#endif
		return '*';
		}
"/" {
	#ifdef DEBUG_MODE
		printf(" divide found " );
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
		printf(" while found " );
	#endif
		return while_token;
		}
"for" {
	#ifdef DEBUG_MODE
		printf(" for found " );
	#endif
		return for_token;
		}
"continue" {
	#ifdef DEBUG_MODE
		printf(" continue found " );
	#endif
		return continue_token;
		}
"break" {
	#ifdef DEBUG_MODE
		printf(" break  found " );
	#endif
		return break_token;
		}
"in" {
	#ifdef DEBUG_MODE
		printf(" in  found " );
	#endif
		return in_token;
		}

"and" {
	#ifdef DEBUG_MODE
		printf(" and found " );
	#endif
		return and;
		}
"or" {
	#ifdef DEBUG_MODE
		printf(" or found " );
	#endif
		return or;
		}
"not" {
	#ifdef DEBUG_MODE
		printf(" not  found " );
	#endif
		return not;
		}
"range" {
	#ifdef DEBUG_MODE
		printf(" range  found " );
	#endif
		return range_token;
		}


{the_double} {

	yylval.num = atof(yytext);

	#ifdef DEBUG_MODE
		printf("LEX: double: %f\n", yylval.num);
	#endif
		return number;
}

"print" {
	#ifdef DEBUG_MODE
		printf("LEX: print\n");
	#endif
		return print_token;
}

{identifire} {
	yylval.id = (char*)malloc(sizeof(char)*(strlen(yytext)+3));
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
