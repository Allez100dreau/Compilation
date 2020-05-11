compilateur: lex.yy.c structfe.tab.c structfe.tab.h
	cc lex.yy.c structfe.tab.c -o compilateur

structfe.tab.c structfe.tab.h:
	bison -d ./sources/structfe.y

lex.yy.c:
	flex ./sources/frontend.l