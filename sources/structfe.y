%{
#include <stdio.h>
#include <string.h>
#include "./sources/hashtable.h"

void yyerror(const char *str) {
        fprintf(stderr,"error: %s\n",str);
}
 
int yywrap() {
        return 1;
}
  
main() {
        yyparse();
}

%}

%token IDENTIFIER CONSTANT SIZEOF
%token SHIFT_R SHIFT_L
%token PTR_OP LE_OP GE_OP EQ_OP NE_OP
%token AND_OP OR_OP
%token EXTERN
%token INT VOID
%token STRUCT 
%token IF ELSE WHILE FOR RETURN
%token INC

/*
%union {
        int number;
}
*/

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
        : shift_expression {$$=$1;}
        | multiplicative_expression '*' unary_expression {$$=$1*$3;}
        | multiplicative_expression '/' unary_expression {$$=$1/$3;}
        ;

additive_expression
        : multiplicative_expression {$$=$1;}
        | additive_expression '+' multiplicative_expression {$$=$1+$3;}
        | additive_expression '-' multiplicative_expression {$$=$1+$3;}
        ;

relational_expression
        : additive_expression {$$=$1;}
        | relational_expression '<' additive_expression
        | relational_expression '>' additive_expression
        | relational_expression LE_OP additive_expression
        | relational_expression GE_OP additive_expression
        ;

equality_expression
        : relational_expression {$$=$1;}
        | equality_expression EQ_OP relational_expression
        | equality_expression NE_OP relational_expression
        ;

logical_and_expression
        : equality_expression {$$=$1;}
        | logical_and_expression AND_OP equality_expression
        ;

logical_or_expression
        : logical_and_expression {$$=$1;}
        | logical_or_expression OR_OP logical_and_expression
        ;

expression
        : logical_or_expression {$$ = $1; printf(" [Result : %d] ", $1);}
        | unary_expression '=' expression {$$ = $3; printf(" [Result : %d] ", $3);}
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

