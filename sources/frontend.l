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
"else"                  { printf("ELSE\n"); }
"extern"                { printf("EXTERN\n"); }
"for"                   { printf("FOR\n"); }
"if"                    { printf("IF\n"); }
"int"                   { printf("INT\n"); }
"return"                { printf("RETURN\n"); }
"sizeof"                { printf("SIZEOF\n"); }
"struct"                { printf("STRUCT\n"); }
"void"                  { printf("VOID\n"); }
"while"                 { printf("WHILE\n"); }

{L}({L}|{D})*           { printf("ID\n"); }

0[xX]{H}+{IS}?          { /* A completer */ }
0{D}+{IS}?              { /* A completer */ }
{D}+{IS}?               { /* A completer */ }
L?'(\\.|[^\\'])+'       { /* A completer */ }

{D}+{E}{FS}?            { /* A completer */ }
{D}*"."{D}+({E})?{FS}?  { /* A completer */ }
{D}+"."{D}*({E})?{FS}?  { /* A completer */ }

L?\"(\\.|[^\\"])*\"     { /* A completer */ }

"->"                    { /* A completer */ }
"&&"                    { /* A completer */ }
"||"                    { /* A completer */ }
"<"                     { /* A completer */ }
">"                     { /* A completer */ }
"<="                    { /* A completer */ }
">="                    { /* A completer */ }
"=="                    { /* A completer */ }
"!="                    { /* A completer */ }

[ \t\v\n\f]             { /* A completer */ }
.                       { return yytext[0]; }
%%

