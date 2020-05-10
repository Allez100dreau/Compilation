# TODO

Il faudra réaliser deux programmes:

1. Un compilateur qui traduit un code du langage STRUCIT-frontend versun code STRUCIT-backend, et affiche des messages d’erreur si le code en entrée est incorrect.

2. Un simple parseur pour le langage STRUCIT-backend, qui permet devérifier si un code écrit en langage STRUCIT-backend est correct lexicalement et syntaxiquement (pas d’analyse sémantique demandée pour ce parseur). Il devra afficher des messages d’erreur sinon. La vérification sémantique du code généré STRUCIT-backend se fera à la main.

Comment compiler:

flex example.l <br />
bison -d example.y <br />
cc lex.yy.c y.tab.c -o example
