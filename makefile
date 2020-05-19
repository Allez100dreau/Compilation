compilateur: makeflex makebison
	-gcc -w fe.yy.c structfe.tab.c ./sources/hashtable.c -o compilateur
	-gcc -w be.yy.c structbe.tab.c -o parseurbackend
	mv *.yy.c struct*.tab.* ./output

makeflex:
	flex -o fe.yy.c ./sources/frontend.l
	flex -o be.yy.c ./sources/backend.l


makebison:
	bison -d -Wnone ./sources/structfe.y
	bison -d -Wnone ./sources/structbe.y