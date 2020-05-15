D                       [0-9]
L                       [a-zA-Z_]
H                       [a-fA-F0-9]
E                       [Ee][+-]?{D}+
FS                      (f|F|l|L)
IS                      (u|U|l|L)*

%{
#include <stdio.h>
#include "structfe.tab.h"

%}

%%
"else"                  { ECHO; return ELSE; }
"extern"                { ECHO; return EXTERN; }
"for"                   { ECHO; return FOR; }
"if"                    { ECHO; return IF; }
"int"                   { ECHO; return INT; }
"return"                { ECHO; return RETURN; }
"sizeof"                { ECHO; return SIZEOF; }
"struct"                { ECHO; return STRUCT; }
"void"                  { ECHO; return VOID; }
"while"                 { ECHO; return WHILE; }

{L}({L}|{D})*           { ECHO; yylval.string = strdup(yytext); return IDENTIFIER; }
{D}+                    { ECHO; yylval.number = atoi(yytext); return CONSTANT; }

"&&"                    { ECHO; return AND_OP; }
"||"                    { ECHO; return OR_OP; }
"<="                    { ECHO; return LE_OP; }
">="                    { ECHO; return GE_OP; }
"=="                    { ECHO; return EQ_OP; }
"!="                    { ECHO; return NE_OP; }
"++"                    { ECHO; return INC; }

\/\*(.|\n)*\*\/         { ECHO; /* ignore comments */ }

"<<"                    { ECHO; return SHIFT_L; }
">>"                    { ECHO; return SHIFT_R; }

[ \n\t\v\f]             { ECHO; /* ignore whitespace */ }
.                       { ECHO; return (int) yytext[0]; }
%%
