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
%token <string> SIZEOF
%token SHIFT_R SHIFT_L
%token PTR_OP LE_OP GE_OP EQ_OP NE_OP
%token AND_OP OR_OP
%token <string> EXTERN
%token <string> INT VOID
%token <string> STRUCT 
%token <string> IF ELSE WHILE FOR RETURN
%token INC
%token <string> '*' '-' '&'

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
%type <string> postfix_expression
%type <string> argument_expression_list
%type <string> unary_operator
%type <string> selection_statement
%type <string> iteration_statement
%type <string> else_statement
%type <string> sizeof_expression

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
        | '(' expression ')' {
                printf("<-- Appel de fonction avec arguments");
		char *expr = malloc(sizeof(char) * (strlen($2) + 3));
                sprintf(expr, "(%s)", $2);
                $$ = expr;
        	}
        ;

postfix_expression
        : primary_expression
        | postfix_expression '(' ')' {
        	printf("<-- Appel de fonction sans argument");
		char *funcall = malloc(sizeof(char) * (strlen($1) + 3));
		sprintf(funcall, "%s()", $1);
		$$ = funcall;

        	//$$ = strcat($1, "()");
        	}
        | postfix_expression '(' argument_expression_list ')' {
                printf("<-- Appel de fonction avec arguments");
		char *funcall = malloc(sizeof(char) * (strlen($1) + strlen($3) + 3));
                sprintf(funcall, "%s(%s)", $1, $3);
                $$ = funcall;
                }
        | postfix_expression '.' IDENTIFIER /*{


        		/!\	ROUTINE INUTILE ?!!!	/!\


		printf("<-- Acces a l'identifier d'une expression.");
		char *exprID = malloc(sizeof(char) * (strlen($1) + strlen($3) + 2));
	   	sprintf(exprID, "%s.%s", $1, $3);
	 	$$ = exprID;
	   	}*/
        | postfix_expression PTR_OP IDENTIFIER

        		// /!\	ROUTINE INUTILE ?!!!	/!\
        ;

argument_expression_list
        : expression
        | argument_expression_list ',' expression {
	  	char *listargs = malloc(sizeof(char) * (strlen($1) + strlen($3) + 3));
		sprintf(listargs, "%s, %s", $1, $3);
		$$ = listargs;
		}
        ;

unary_expression
        : postfix_expression
        | unary_operator unary_expression {
                char *unexpr = malloc(sizeof(char) * (strlen($1) + strlen($2) + 1));
                sprintf(unexpr, "%s%s", $1, $2);
                $$ = unexpr;
        }
        | SIZEOF sizeof_expression{
		char *sizeOf = malloc(sizeof(char) * (strlen($1) + strlen($2) + 1));
		sprintf(sizeOf, "%s%s", $1, $2);
		$$ = sizeOf;
        	}
        | unary_expression INC{
		char *incrementor = malloc(sizeof(char) * (strlen($1) + 3));
		sprintf(incrementor, "%s++", $1);
		$$ = incrementor;
        	}
        ;
        
sizeof_expression
        : unary_expression
        | '(' type_specifier ')' {
		char *sizeOfType = malloc(sizeof(char) * (strlen($2) + 3));
		sprintf(sizeOfType, "(%s)", $2);
		$$ = sizeOfType;
		}
        ;

unary_operator
        : '&' {printf("ESPERLUETTE : %s", $1);}
        | '*' {printf("ASTERISQUE : %s", $1);}
        | '-' {printf("NUMBER NEG : %s", $1);}
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
        | logical_and_expression AND_OP equality_expression {
/*
		PSEUDO CODE POUR INDIQUER COMMENT FAIRE
        	if (1er){
        		if (2nd){
        			<true>
        		}else {false}
		}else{false}
*/
        	}

        ;

logical_or_expression
        : logical_and_expression
        | logical_or_expression OR_OP logical_and_expression {
/*
		PSEUDO CODE POUR INDIQUER COMMENT FAIRE
        	if !(1er) {goto then}
        	if !(2nd) {goto then}
        	<true>
        	then:
        	<else>
*/
        	}
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
                char *code = malloc(sizeof(char) * (strlen($1) + strlen($2) + 2));
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
        : '*' direct_declarator {
		char *code = malloc(sizeof(char) * (strlen($2) + 2));
		sprintf(code, "%s%s", $1, $2);
		$$ = code;
		}
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
        : '{' '}' {$$ = "{}";}
        | '{' statement_list '} '{
		char *cmpstat = malloc(sizeof(char) * (strlen($2) + 3));
		sprintf(cmpstat, "{\n\t%s\n}",$2);
		$$ = cmpstat;
		}
        | '{' declaration_list '} '{
		  char *cmpstat = malloc(sizeof(char) * (strlen($2) + 3));
		  sprintf(cmpstat, "{\n\t%s\n}",$2);
		  $$ = cmpstat;
		}
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
		char *codeStr = malloc(sizeof(char) * 7000);

		char Labelif[50];
		char Labelendif[50];
		sprintf(Labelif, "Label%s%i", "If", incLabel++);
		sprintf(Labelendif, "Label%s%i", "Endifelse", incLabel++);

		// On génère le code pour trouver la valeur "valeurCdt" de la condition avant le if, puis on la récupère et on la met dans le if.
		// Rendre unique le nom de la valeur ?

		sprintf(codeStr, "\nif (%s) goto %s;\n%s\ngoto %s;\n%s:\n%s\n%s:\n", "valeurCdt" , Labelif, $6, Labelendif, Labelif, $5, Labelendif);
		$$ = codeStr;

                }
        ;

else_statement
        : %empty {$$ = "";}
        | ELSE statement {$$ = $2;}
        ;

iteration_statement
        : WHILE '(' expression ')' statement {
		char *codeStr = malloc(sizeof(char) * 7000);

		char LabelWhile[50];
		char LabelWhileCdt[50];
		sprintf(LabelWhile, "Label%s%i", "While", incLabel++);
		sprintf(LabelWhileCdt, "Label%s%i", "WhileCdt", incLabel++);

		sprintf(codeStr, "\ngoto %s;\n%s:\n%s\n%s:\nif (%s) goto %s;\n", LabelWhileCdt, LabelWhile, $5, LabelWhileCdt, "Conditon_while($3)", LabelWhile);
		$$ = codeStr;
        	}
        | FOR '(' expression_statement expression_statement expression ')' statement {
		char *codeStr = malloc(sizeof(char) * 7000);

		char LabelFor[50];
		char LabelForCdt[50];
		sprintf(LabelFor, "Label%s%i", "For", incLabel++);
		sprintf(LabelForCdt, "Label%s%i", "ForCdt", incLabel++);

		sprintf(codeStr, "\n%s\ngoto %s;\n%s:\n%s\n%s\n%s:\nif (%s) goto %s;\n", "init_variable($3)", LabelForCdt, LabelFor ,$7, "action_fin_de_boucle($5)", LabelForCdt, "condition_continuation_for($4)", LabelFor);

		$$ = codeStr;
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

