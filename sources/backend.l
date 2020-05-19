D                       [0-9]
L                       [a-zA-Z_]
H                       [a-fA-F0-9]
E                       [Ee][+-]?{D}+
FS                      (f|F|l|L)
IS                      (u|U|l|L)*

%{
#include <stdio.h>
#include "structbe.tab.h"

void dupl(char *text) {
    yylval.string = strdup(yytext);
}

%}

%%
"extern"                { ECHO; dupl(yytext); return EXTERN; }
"if"                    { ECHO; dupl(yytext); return IF; }
"int"                   { ECHO; dupl(yytext); return INT; }
"return"                { ECHO; dupl(yytext); return RETURN; }
"void"                  { ECHO; dupl(yytext); return VOID; }
"goto"                  { ECHO; dupl(yytext); return GOTO; }

{L}({L}|{D})*           { ECHO; dupl(yytext); return IDENTIFIER; }
{D}+                    { ECHO; yylval.number = atoi(yytext); return CONSTANT; }

"<="                    { ECHO; return LE_OP; }
">="                    { ECHO; return GE_OP; }
"=="                    { ECHO; return EQ_OP; }
"!="                    { ECHO; return NE_OP; }

\/\*(.|\n)*\*\/         { ECHO; /* ignore comments */ }

[ \n\t\v\f]             { ECHO; /* ignore whitespace */ }
.                       { ECHO; return (int) yytext[0]; }
%%
