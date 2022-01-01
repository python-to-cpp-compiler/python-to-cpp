bison -dy yacc.y
flex main.l
gcc lex.yy.c y.tab.c -o project
.\compile.sh && .\project inputs_test\t2.py