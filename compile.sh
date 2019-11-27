yacc -d -v parser.y && lex lexer.l && gcc -Wall dep.c y.tab.c lex.yy.c -ly -ll && ./a.out
python constantfold.py intermediate.tac > optimized.tac
