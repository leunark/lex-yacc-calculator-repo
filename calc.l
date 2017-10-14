%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "y.tab.h"
void yyerror(char *);
%}

%%

[a-z]			{ yylval.intVal = *yytext - 'a'; return VARIABLE; }	/* ascii conversion from 'a'-'z' to 1-26 */
[0-9]+			{ yylval.intVal = atoi(yytext); return INTEGER; }
([0-9]*[.])?[0-9]+	{ yylval.doubleVal = atof(yytext); return DOUBLE; }
[-+()=*/\n]		{ return *yytext; }				/* variable yytext is a pointer to the matched string */
[ \t]+			;						/* skip whitespace */
.			yyerror("This character is unknown!");		/* any other character throws an error */

%%

/* function yywrap is called by lex when input is exhausted */ 
/* return 1 if you are done or 0 if more processing is required */
int yywrap(void) 
{
	return 1;
}
