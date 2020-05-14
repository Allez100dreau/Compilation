compilateur: lex.yy.c structfe.tab.c structfe.tab.h
	-gcc -w lex.yy.c structfe.tab.c ./sources/hashtable.c -o compilateur
	rm lex.yy.c structfe.tab.*

structfe.tab.c structfe.tab.h:
	bison -d ./sources/structfe.y

lex.yy.c:
	flex ./sources/frontend.l