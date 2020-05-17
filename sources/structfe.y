%{
#include <stdio.h>
#include <string.h>
#include "./sources/hashtable.h"

hashtable_t *hashtable;
FILE *output;
int incLabel;

char *newtmp(void) {
        char start[50] = "tmp_";
        char i[10] = "1";
        char tmp[50];
        int inc;
        strcpy(tmp,start);
        strcat(tmp, i);

        /*
        while (ht_get(hashtable, tmp) != NULL) {
                inc = (atoi(i) + 1);
                sprintf(i, "%d", inc);
                strcpy(tmp,start);
                strcat(start, i);
        }
        */

        printf("%s", tmp);
        return tmp;
}

void gencode(char *code) {
        fputs(code, output);
}

void yyerror(const char *str) {
        fprintf(stderr,"error: %s\n",str);
}
 
int yywrap() {
        return 1;
}
  
main() {
        output = fopen("./backend/test.c", "w");

	if(output == NULL) {
		fprintf(stderr, "Impossible d'ouvrir le fichier d'output en écriture.\n");
		exit(1);
	}

	incLabel = 0;
        hashtable = ht_create();
        yyparse(hashtable);
        ht_dump(hashtable);

        fclose(output);
}

%}

%token <number> CONSTANT
%token <string> IDENTIFIER
%token SIZEOF
%token SHIFT_R SHIFT_L
%token PTR_OP LE_OP GE_OP EQ_OP NE_OP
%token AND_OP OR_OP
%token <string> EXTERN
%token <string> INT VOID
%token <string> STRUCT 
%token <string> IF ELSE WHILE FOR RETURN
%token INC

%type <string> declaration_specifiers
%type <string> direct_declarator
%type <string> struct_specifier
%type <string> type_specifier
%type <string> declarator
%type <string> declaration
%type <string> declaration_list
%type <string> expression
%type <string> unary_expression
%type <string> external_declaration
%type <string> parameter_list
%type <string> parameter_declaration
%type <string> expression_statement
%type <string> primary_expression
%type <string> compound_statement
%type <string> function_definition
%type <string> program
%type <string> statement_list
%type <string> statement
%type <string> jump_statement

%union {
        int number;
        char *string;
}

%left '+' '-'

%start program
%%

primary_expression
        : IDENTIFIER
        | CONSTANT
        | '-' CONSTANT {$$ = -$2;}
        | '(' expression ')'
        ;

postfix_expression
        : primary_expression
        | postfix_expression '(' ')'
        | postfix_expression '(' argument_expression_list ')' {printf("<-- Appel de fonction avec arguments");}
        | postfix_expression '.' IDENTIFIER
        | postfix_expression PTR_OP IDENTIFIER
        ;

argument_expression_list
        : expression
        | argument_expression_list ',' expression
        ;

unary_expression
        : postfix_expression
        | unary_operator unary_expression
        | SIZEOF sizeof_expression
        | unary_expression INC
        ;
        
sizeof_expression
        : unary_expression
        | '(' type_specifier ')'
        ;

unary_operator
        : '&'
        | '*'
        | '-'
        ;

shift_expression
        : unary_expression
        | shift_expression SHIFT_L unary_expression
        | shift_expression SHIFT_R unary_expression
        ;

multiplicative_expression
        : shift_expression
        | multiplicative_expression '*' unary_expression
        | multiplicative_expression '/' unary_expression
        ;

additive_expression
        : multiplicative_expression
        | additive_expression '+' multiplicative_expression
        | additive_expression '-' multiplicative_expression
        ;

relational_expression
        : additive_expression
        | relational_expression '<' additive_expression
        | relational_expression '>' additive_expression
        | relational_expression LE_OP additive_expression
        | relational_expression GE_OP additive_expression
        ;

equality_expression
        : relational_expression
        | equality_expression EQ_OP relational_expression
        | equality_expression NE_OP relational_expression
        ;

logical_and_expression
        : equality_expression
        | logical_and_expression AND_OP equality_expression
        ;

logical_or_expression
        : logical_and_expression
        | logical_or_expression OR_OP logical_and_expression
        ;

expression
        : logical_or_expression
        | unary_expression '=' expression {
        char str[10];
        sprintf(str, "%d", $3);
        printf("<-- On affecte %s à %s", str, $1);
        ht_set(hashtable, $1, str);
        char *affect = malloc(sizeof(char) * (strlen($1) + strlen(str) + 2));
        sprintf(affect, "%s = %s", $1, str);
        $$ = affect;
        }
        ;

declaration
        : declaration_specifiers declarator ';' {
                ht_set(hashtable, $2, $1);
                char *code = malloc(sizeof(char) * 50);
                sprintf(code,"%s %s;", $1, $2);
                $$ = code;
        }
        | struct_specifier ';'
        ;

declaration_specifiers
        : EXTERN type_specifier {
                char *code = malloc(sizeof(char) * (strlen($1) + strlen($2) + 1));
                sprintf(code,"%s %s",$1, $2);
                $$ = code;
        }
        | type_specifier
        ;

type_specifier
        : VOID
        | INT
        | struct_specifier
        ;

struct_specifier
        : STRUCT IDENTIFIER '{' struct_declaration_list '}'
        | STRUCT '{' struct_declaration_list '}'
        | STRUCT IDENTIFIER
        ;

struct_declaration_list
        : struct_declaration
        | struct_declaration_list struct_declaration
        ;

struct_declaration
        : type_specifier declarator ';'
        ;

declarator
        : '*' direct_declarator
        | direct_declarator
        ;

direct_declarator
        : IDENTIFIER
        | '(' declarator ')'
        | direct_declarator '(' parameter_list ')' {
                char *code = malloc(sizeof(char) * 50);
                sprintf(code,"%s(%s)", $1, $3);
                $$ = code;
                }
        | direct_declarator '(' ')' {
                char *vide = malloc(sizeof(int) * (strlen($1) + 3));
                sprintf(vide, "%s()", $1);
                $$ = vide;
        }
        ;

parameter_list
        : parameter_declaration
        | parameter_list ',' parameter_declaration
        ;

parameter_declaration
        : declaration_specifiers declarator {
                char *code = malloc(sizeof(char) * 50);
                sprintf(code, "%s %s", $1, $2);
                $$ = code;
        }
        ;

statement
        : compound_statement
        | expression_statement
        | selection_statement
        | iteration_statement
        | jump_statement 
        ;

compound_statement
        : '{' '}'
        | '{' statement_list '}'
        | '{' declaration_list '}'
        | '{' declaration_list statement_list '}' {
                char *cmpstat = malloc(sizeof(char) * (strlen($2) + strlen($3) + 3));
                sprintf(cmpstat, "{\n\t%s\n\t%s\n}",$2, $3);
                $$ = cmpstat;
        }
        ;

declaration_list
        : declaration {printf("<-- On fait une déclaration dans un bloc");}
        | declaration_list declaration {
                printf("<-- On fait une déclaration dans un bloc");
                char *decl = malloc(sizeof(int) * (strlen($1) + strlen($2)));
                sprintf(decl, "%s\n\t%s", $1, $2);
                $$ = decl;
                }
        ;

statement_list
        : statement
        | statement_list statement {
                char *instr = malloc(sizeof(int) * (strlen($1) + strlen($2)));
                sprintf(instr, "%s\n\t%s", $1, $2);
                $$ = instr;
                }
        ;

expression_statement
        : ';'
        | expression ';' {
                char *expr = malloc(sizeof(char) * (strlen($1) + 1));
                sprintf(expr, "%s;", $1);
                $$ = expr;
        }
        ;

selection_statement
        : IF '(' expression ')' statement else_statement {
		char codeStr[500];

		char Labelif[50];
		char Labelendif[50];
		sprintf(Labelif, "Label%s%i", "If", incLabel++);
		sprintf(Labelendif, "Label%s%i", "Endifelse", incLabel++);

		sprintf(codeStr, "\nif (%s) goto %s;\n%s\ngoto %s;\n%s:\n%s\n%s:\n", "$1", Labelif, "$4", Labelendif, Labelif, "$3" , Labelendif);

		gencode(codeStr);
                }
        ;

else_statement
        : %empty
        | ELSE statement
        ;

iteration_statement
        : WHILE '(' expression ')' statement {
		char codeStr[500];

		char LabelWhile[50];
		char LabelWhileCdt[50];
		sprintf(LabelWhile, "Label%s%i", "While", incLabel++);
		sprintf(LabelWhileCdt, "Label%s%i", "WhileCdt", incLabel++);

		sprintf(codeStr, "\ngoto %s;\n%s:\n$3\n%s:\nif (%s) goto %s;\n", LabelWhileCdt, LabelWhile, LabelWhileCdt, "$1" , LabelWhile);

        	gencode(codeStr);
        	}
        | FOR '(' expression_statement expression_statement expression ')' statement {
		char codeStr[500];

		char LabelFor[50];
		char LabelForCdt[50];
		sprintf(LabelFor, "Label%s%i", "For", incLabel++);
		sprintf(LabelForCdt, "Label%s%i", "ForCdt", incLabel++);

		sprintf(codeStr, "\n%s\ngoto %s;\n%s:\n%s\n%s\n%s:\nif (%s) goto %s;\n", $3, LabelForCdt, LabelFor ,"$5", "$3", LabelForCdt, "$2", LabelFor);

        	gencode(codeStr);
        	}
        ;

jump_statement
        : RETURN ';' {printf("<-- On retourne");}
        | RETURN expression ';' {
        	char str[10]; sprintf(str, "%d", $2);
                printf("<-- On retourne %s", str);
                char *ret = malloc(sizeof(char) * (strlen($1) + strlen(str) + 1));
                sprintf(ret, "%s %s;", $1, str);
                $$ = ret;
        	}
        ;

program
        : external_declaration
        | program external_declaration {
                char *prog = malloc(sizeof(char) * (strlen($1) + strlen($2) + 1));
                sprintf(prog, "%s\n\n%s", $1, $2);
                gencode(prog);
        }
        ;

external_declaration
        : function_definition
        | declaration
        ;

function_definition
        : declaration_specifiers declarator {printf("<-- Début définition de la fonction %s qui renvoie un %s", $2, $1);} compound_statement {
                printf("<-- Fin du bloc\n");
                char *function = malloc(sizeof(int) * (strlen($1) + strlen($2) + strlen($4) + 1));
                sprintf(function, "%s %s %s", $1, $2, $4);
                $$ = function;
                }
        ;

%%

