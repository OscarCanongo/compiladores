/* Este archivo contiene un reconocedor de expresiones aritméticas junto
   con algunas reglas semánticas que calculan los valores de las
   expresiones que se reconocen. Las expresiones son muy sencillas y
   consisten únicamente de sumas, restas, multiplicaciones y divisiones de
   números enteros.

   Para compilar y ejecutar:
   flex calculadora.lex
   bison calculadora.y
   gcc lex.yy.c calculadora.tab.c -lfl
   ./a.out

   Autor: Alberto Oliart Ros */

%{
#include<stdio.h>
#include <math.h>

extern int yylex();
int yyerror(char const * s);

%}

/* Los elementos terminales de la gramática. La declaración de abajo se
   convierte en definición de constantes en el archivo calculadora.tab.h
   que hay que incluir en el archivo de flex. */

%token NUM SUMA RESTA DIVIDE MODU EXPO MULTI PAREND PARENI FINEXP
%start exp

%%

exp : expr FINEXP {printf("Valor = %d\n", $1);}
;

expr : expr SUMA term    {$$ = $1 + $3;}
     | expr RESTA term   {$$ = $1 - $3;}
     | term
;

term : term MULTI factor   {$$ = $1 * $3;}
     | term DIVIDE factor  {$$ = $1 / $3;}
     | term MODU factor  {$$ = $1 % $3;}
     | term EXPO factor  {$$ = pow($1, $3);}
     | factor
;

factor : PARENI expr PAREND  {$$ = $2;}
       | NUM
;

%%

int yyerror(char const * s) {
  fprintf(stderr, "%s\n", s);
}

void main() {

  yyparse();
}

