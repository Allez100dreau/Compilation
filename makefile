traduction: flex bison compilateur
	./compilateur < ./tests/add.c
	mv ./backend/backend.c ./backend/add_be.c
	./compilateur < ./tests/compteur.c
	mv ./backend/backend.c ./backend/compteur_be.c
	./compilateur < ./tests/cond.c
	mv ./backend/backend.c ./backend/cond_be.c
	./compilateur < ./tests/div.c
	mv ./backend/backend.c ./backend/div_be.c
	./compilateur < ./tests/expr.c
	mv ./backend/backend.c ./backend/expr_be.c
	./compilateur < ./tests/functions.c
	mv ./backend/backend.c ./backend/functions_be.c
	./compilateur < ./tests/listes.c
	mv ./backend/backend.c ./backend/listes_be.c
	./compilateur < ./tests/loops.c
	mv ./backend/backend.c ./backend/loops_be.c
	./compilateur < ./tests/mul.c
	mv ./backend/backend.c ./backend/mul_be.c
	./compilateur < ./tests/neg.c
	mv ./backend/backend.c ./backend/neg_be.c
	./compilateur < ./tests/pointeur.c
	mv ./backend/backend.c ./backend/pointeur_be.c
	./compilateur < ./tests/sub.c
	mv ./backend/backend.c ./backend/sub_be.c
	./compilateur < ./tests/variables.c
	mv ./backend/backend.c ./backend/variables_be.c

compilateur: flex bison
	-gcc -w fe.yy.c structfe.tab.c ./sources/hashtable.c -o compilateur
	-gcc -w be.yy.c structbe.tab.c -o parsebe
	mv *.yy.c struct*.tab.* ./output

flex:
	flex -o fe.yy.c ./sources/frontend.l
	flex -o be.yy.c ./sources/backend.l


bison:
	bison -d -Wnone ./sources/structfe.y
	bison -d -Wnone ./sources/structbe.y