D                       [0-9]
L                       [a-zA-Z_]
H                       [a-fA-F0-9]
E                       [Ee][+-]?{D}+
FS                      (f|F|l|L)
IS                      (u|U|l|L)*

%{
#include <stdio.h>
#include "y.tab.h"

%}

%%
"else"                  { return ELSE; printf("ELSE "); }
"extern"                { return EXTERN; printf("EXTERN "); }
"for"                   { return FOR; printf("FOR "); }
"if"                    { return IF; printf("IF "); }
"int"                   { return INT; printf("INT "); }
"return"                { return RETURN; printf("RETURN "); }
"sizeof"                { return SIZEOF; printf("SIZEOF "); }
"struct"                { return STRUCT; printf("STRUCT "); }
"void"                  { return VOID; printf("VOID "); }
"while"                 { return WHILE; printf("WHILE "); }

{L}({L}|{D})*           { return IDENTIFIER; printf("IDENTIFIER "); }
{D}                     { return CONSTANT; printf("CONSTANT "); }

"&&"                    { return AND_OP; printf("AND "); }
"||"                    { return OR_OP; printf("OR "); }
"<="                    { return LE_OP; printf("LESSEQ "); }
">="                    { return GE_OP; printf("GREATEQ "); }
"=="                    { return EQ_OP; printf("EQ "); }
"!="                    { return NE_OP; printf("NOTEQ "); }

\n                      { /* ignore end of line */ printf("\n"); }
[ \t\v\f]               { /* ignore whitespace */ }
.                       { return yytext[0]; }
%%
