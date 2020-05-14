# COMPILATION DU PROJET
#
# Un fichier exécutable comme un programme "compilateur" sera créé.
compilateur: makeflex makebison
	-gcc -w lex.yy.c structfe.tab.c ./sources/hashtable.c -o compilateur
	rm lex.yy.c structfe.tab.*

# Un output : "lex.yy.c"
makeflex:
	flex ./sources/frontend.l

# Deux outputs : "structfe.tab.c" et "structfe.tab.h"
makebison:
	bison -d ./sources/structfe.y

