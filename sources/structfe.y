%{
#include <stdio.h>
#include <string.h>
#include "./sources/hashtable.h"

hashtable_t *hashtable;
FILE *output;

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
%token EXTERN
%token <string> INT VOID
%token <string> STRUCT 
%token IF ELSE WHILE FOR RETURN
%token INC

%type <string> declaration_specifiers
%type <string> direct_declarator
%type <string> struct_specifier
%type <string> type_specifier
%type <string> declarator

%union {
        int number;
        char *string;
}

%start program
%%

primary_expression
        : IDENTIFIER
        | CONSTANT
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
        | unary_expression '=' expression {printf(" <-- On fait une affectation");}
        ;

declaration
        : declaration_specifiers declarator ';' {printf(" <-- On fait une déclaration");}
        | struct_specifier ';'
        ;

declaration_specifiers
        : EXTERN type_specifier
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
        | direct_declarator '(' parameter_list ')'
        | direct_declarator '(' ')'
        ;

parameter_list
        : parameter_declaration
        | parameter_list ',' parameter_declaration
        ;

parameter_declaration
        : declaration_specifiers declarator
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
        | '{' declaration_list statement_list '}'
        ;

declaration_list
        : declaration
        | declaration_list declaration
        ;

statement_list
        : statement
        | statement_list statement
        ;

expression_statement
        : ';'
        | expression ';' {printf(" #Fin d'instruction#");}
        ;

selection_statement
        : IF '(' expression ')' statement else_statement
	        {gencode("\nif ($1) goto Lif1;\n$4\ngoto Lendifelse;\nLif1:\n$3\nLendifelse:\n");};

else_statement
        : %empty
        | ELSE statement
        ;

iteration_statement
        : WHILE '(' expression ')' statement
        	{gencode("\ngoto Ltest1;\nLwhile1:\n$3\nLtest1:\nif ($1) goto Lwhile1;\n");};
        | FOR '(' expression_statement expression_statement expression ')' statement
        	{gencode("\n$1\ngoto Ltest1;\nLfor1:\n$5\n$3\nLtest1:\nif ($2) goto Lfor1;\n");};

jump_statement
        : RETURN ';' {printf("<-- On retourne");}
        | RETURN expression ';' {printf("<-- On retourne une valeur");}
        ;

program
        : external_declaration
        | program external_declaration
        ;

external_declaration
        : function_definition
        | declaration
        ;

function_definition
        : declaration_specifiers declarator {printf("<-- On commence la définition de la fonction %s", $2);} compound_statement {printf("<-- Fin du bloc");}
        ;

%%

