D                       [0-9]
L                       [a-zA-Z_]
H                       [a-fA-F0-9]
E                       [Ee][+-]?{D}+
FS                      (f|F|l|L)
IS                      (u|U|l|L)*

%{
#include <stdio.h>
#include "structfe.tab.h"

void dupl(char *text) {
    yylval.string = strdup(yytext);
}

%}

%%
"else"                  { ECHO; dupl(yytext); return ELSE; }
"extern"                { ECHO; dupl(yytext); return EXTERN; }
"for"                   { ECHO; dupl(yytext); return FOR; }
"if"                    { ECHO; dupl(yytext); return IF; }
"int"                   { ECHO; dupl(yytext); return INT; }
"return"                { ECHO; dupl(yytext); return RETURN; }
"sizeof"                { ECHO; dupl(yytext); return SIZEOF; }
"struct"                { ECHO; dupl(yytext); return STRUCT; }
"void"                  { ECHO; dupl(yytext); return VOID; }
"while"                 { ECHO; dupl(yytext); return WHILE; }

{L}({L}|{D})*           { ECHO; dupl(yytext); return IDENTIFIER; }
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
