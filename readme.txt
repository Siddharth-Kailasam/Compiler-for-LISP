Compiler for LISP -

INSTRUCTIONS TO RUN THE CODE -
chmod a+x compile.sh
./compile.sh

Contents of compile.sh-

yacc -d -v parser.y && lex lexer.l && gcc -Wall dep.c y.tab.c lex.yy.c -ly -ll && ./a.out
python constantfold.py intermediate.tac > optimized.tac

Comment the second line if you do not need optimization

Please refer to report.docx for more details on the project
