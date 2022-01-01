yacc -d yacc.y
lex main.l
gcc lex.yy.c y.tab.c -o project