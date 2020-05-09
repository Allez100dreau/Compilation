D                       [0-9]
L                       [a-zA-Z_]
H                       [a-fA-F0-9]
E                       [Ee][+-]?{D}+
FS                      (f|F|l|L)
IS                      (u|U|l|L)*

%{
#include <stdio.h>
/* #include "y.tab.h" */


/* Ne g�re pas les commentaires. A rajouter */
/* Supprimer les lignes dont vous n'avez pas besoin. */

%}

%%
"else"                  { printf("ELSE "); }
"extern"                { printf("EXTERN "); }
"for"                   { printf("FOR "); }
"if"                    { printf("IF "); }
"int"                   { printf("INT "); }
"return"                { printf("RETURN "); }
"sizeof"                { printf("SIZE "); }
"struct"                { printf("STRUCT "); }
"void"                  { printf("VOID "); }
"while"                 { printf("WHILE "); }

{L}({L}|{D})*           { printf("ID "); }

"->champ"               { printf("CHAMP "); }
"&&"                    { printf("AND "); }
"||"                    { printf("OR "); }
"<"                     { printf("LESS "); }
">"                     { printf("GREAT "); }
"<="                    { printf("LESSEQ "); }
">="                    { printf("GREATEQ "); }
"=="                    { printf("EQ "); }
"!="                    { printf("NOTEQ "); }

"/*"                    { printf("COMMSTART "); }
"*/"                    { printf("COMMEND "); }

\n                      { printf("\n"); }
[ \t\v\f]               { /* ignore whitespace */ }
.                       { return yytext[0]; }
%%
