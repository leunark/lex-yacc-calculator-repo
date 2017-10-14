%{
#include <stdio.h>
#include <math.h>

void yyerror(char *);
int yylex(void);
double var[26]; /* this array stores the variables from a-z */
%}

%union 
{	
	int intVal;
        double doubleVal;
        char charVal;
}
%token <intVal> INTEGER
%token <doubleVal> DOUBLE
%token <intVal> VARIABLE
%right '='
%left '+' '-' 
%left '*' '/'	/* the order of %left is important, '-','*' and '/' have more priority than '+' */

%%

program:
	program statement '\n'
	| program '\n'
	| /* EMPTY */
	;
statement:
	expression { printf ("%g\n", $<doubleVal>1); }
	| assignment
	;
assignment:
	VARIABLE '=' assignment { var[$<intVal>1] = var[$<intVal>3]; }
	| VARIABLE '=' expression { var[$<intVal>1] = $<doubleVal>3; }
	;
expression:
	DOUBLE
	| INTEGER { $<doubleVal>$ = $<intVal>1; }
	| VARIABLE { $<doubleVal>$ = var[$<intVal>1]; }
	| '-' expression { $<doubleVal>$ = -$<doubleVal>2; }
	| expression '+' expression { $<doubleVal>$ = $<doubleVal>1 + $<doubleVal>3; }
	| expression '-' expression { $<doubleVal>$ = $<doubleVal>1 - $<doubleVal>3; }
	| expression '*' expression { $<doubleVal>$ = $<doubleVal>1 * $<doubleVal>3; }
	| expression '/' expression { $<doubleVal>$ = $<doubleVal>1 / $<doubleVal>3; }
	| '(' expression ')' { $<doubleVal>$ = $<doubleVal>2; }
	;
%%

void yyerror(char *s) 
{
	fprintf(stderr, "%s\n", s);
}

int main(void) 
{
	yyparse();
}
