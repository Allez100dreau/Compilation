traduction: flex bison compilateur
	@./compilateur < ./tests/add.c > /dev/null || true
	@mv ./backend/backend.c ./backend/add_be.c || true
	@./compilateur < ./tests/compteur.c > /dev/null || true
	@mv ./backend/backend.c ./backend/compteur_be.c || true
	@./compilateur < ./tests/cond.c > /dev/null || true
	@mv ./backend/backend.c ./backend/cond_be.c || true
	@./compilateur < ./tests/div.c > /dev/null || true
	@mv ./backend/backend.c ./backend/div_be.c || true
	@./compilateur < ./tests/expr.c > /dev/null || true
	@mv ./backend/backend.c ./backend/expr_be.c || true
	@./compilateur < ./tests/functions.c > /dev/null || true
	@mv ./backend/backend.c ./backend/functions_be.c || true
	@./compilateur < ./tests/listes.c > /dev/null || true
	@mv ./backend/backend.c ./backend/listes_be.c || true
	@./compilateur < ./tests/loops.c > /dev/null || true
	@mv ./backend/backend.c ./backend/loops_be.c || true
	@./compilateur < ./tests/mul.c > /dev/null || true
	@mv ./backend/backend.c ./backend/mul_be.c || true
	@./compilateur < ./tests/neg.c > /dev/null || true
	@mv ./backend/backend.c ./backend/neg_be.c || true
	@./compilateur < ./tests/pointeur.c > /dev/null || true
	@mv ./backend/backend.c ./backend/pointeur_be.c || true
	@./compilateur < ./tests/sub.c > /dev/null || true
	@mv ./backend/backend.c ./backend/sub_be.c || true
	@./compilateur < ./tests/variables.c > /dev/null || true
	@mv ./backend/backend.c ./backend/variables_be.c || true

compilateur: flex bison
	@-gcc -w fe.yy.c structfe.tab.c ./sources/hashtable.c -o compilateur || true
	@-gcc -w be.yy.c structbe.tab.c -o parsebe || true
	@mv *.yy.c struct*.tab.* ./output || true

flex:
	@flex -o fe.yy.c ./sources/frontend.l || true
	@flex -o be.yy.c ./sources/backend.l|| true

bison:
	@bison -d -Wnone ./sources/structfe.y || true
	@bison -d -Wnone ./sources/structbe.y || true