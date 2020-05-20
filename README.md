# COMPILER LE PROJET

Pour compiler le projet, il suffit d'exécuter la commande 'make' à la racine du projet.

Cela va produire deux programmes:

- 'compilateur' : Le compilateur.
- 'parsebe' : Le parseur pour le langage STRUCIT-backend.

Les fichiers produits par lex et yacc se trouveront dans le dossier /output.

Cela va également traduire tous les fichiers se trouvant dans /tests. Les fichiers traduits se trouveront dans le dossier /backend sous le nom "<nom-du-fichier>_be.c".



Il est également possible de tester chaque fichier individuellement. Pour cela, il faut se placer dans la racine du projet et exécuter la commande suivante:

'./compilateur < tests/<nom-du-fichier>.c'

Si le programme en entrée est correct lexicalement et syntaxiquement, il sera affiché sur la sortie standard. On pourra voir la table des symboles affichée à la fin également.

Le fichier traduit sera /backend/backend.c.



Pour vérifier qu'un fichier écrit en STRUCIT-backend est correct lexicalement et syntaxiquement, on utilise le parseur en exécutant la commande suivante:

'./parsebe < backend/<nom-du-fichier>.c'

Si le programme en entrée est correct lexicalement et syntaxiquement, il sera affiché sur la sortie standard.




# NOTES

Le seul programme à être "traduit" correctement est "variables.c", ce qui n'est pas compliqué car il suffit de le restituer à l'identique pour avoir un programme en STRUCIT-backend.

Pour le reste des programmes, la traduction est inachevée, et par conséquent, incorrecte.

Le rapport se trouve dans le dossier /doc.

Lien du dépôt GitHub : https://github.com/Allez100dreau/Compilation

