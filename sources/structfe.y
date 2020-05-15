%{
#include <stdio.h>
#include <string.h>
#include "./sources/hashtable.h"

hashtable_t *hashtable;

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
        FILE *file;

        file = fopen("./backend/test.c", "w");
        fputs(code, file);
        fclose(file);
}

void yyerror(const char *str) {
        fprintf(stderr,"error: %s\n",str);
}
 
int yywrap() {
        return 1;
}
  
main() {
        hashtable = ht_create(); 
        yyparse(hashtable);
        ht_dump(hashtable);
}

%}

%token <number> CONSTANT
%token <string> IDENTIFIER
%token SIZEOF
%token SHIFT_R SHIFT_L
%token PTR_OP LE_OP GE_OP EQ_OP NE_OP
%token AND_OP OR_OP
%token EXTERN
%token INT VOID
%token STRUCT 
%token IF ELSE WHILE FOR RETURN
%token INC

%type <string> struct_declaration

%union {
        int number;
        char *string;
}

%start program
%%

primary_expression
        : IDENTIFIER {ht_set(hashtable, $1, "");}
        | CONSTANT
        | '(' expression ')'
        ;

postfix_expression
        : primary_expression
        | postfix_expression '(' ')'
        | postfix_expression '(' argument_expression_list ')'
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
        | unary_expression '=' expression
        ;

declaration
        : declaration_specifiers declarator ';'
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
        : type_specifier declarator ';' {printf("BONJOUR"); ht_set(hashtable, "name1", "alessandro"); ht_dump(hashtable);}
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
        | expression ';'
        ;

selection_statement
        : IF '(' expression ')' statement else_statement
/*        {
        if ($$1) goto Lif1;
        $$4
	goto Lendifelse;

	Lif1:
	$$3

	Lendifelse:
        }*/
        ;

else_statement
        : %empty
        | ELSE statement
        ;

iteration_statement
        : WHILE '(' expression ')' statement
/*        	{
        	goto Ltest1;
        	Lwhile1:
        	$$3
		Ltest1:
		if ($$1) goto Lwhile1;
        	}*/
        | FOR '(' expression_statement expression_statement expression ')' statement
/*        	{
        	$$1
        	goto Ltest1;
        	Lfor1:
        	$$5
        	$$3
        	Ltest1:
        	if ($$2) goto Lfor1;
        	}*/
        ;

jump_statement
        : RETURN ';'
        | RETURN expression ';'
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
        : declaration_specifiers declarator compound_statement
        ;

%%

