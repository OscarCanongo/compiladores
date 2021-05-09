/* Ejercicio.

   Modificar este archivo para que reconozca, ademas de lo que ya contiene, las
   siguientes cosas:
   - Llaves: {}
   - Corchetes []
   - Numeros enteros (corregir la definicion actual)
   - Numeros de punto flotante {Tal como lo vimos en clase} Al reconocer un
   numero de punto flotante debe guardar el valor en alguna variable e
   imprimirlo.

   Este ejercicio debe entregarse a mas tardar el dia 11 de marzo.
   
*/
%{
#include<stdio.h>
#include<stdlib.h>
#include<math.h>

  /* Definimos algunas constantes para identificar fichas */
#define NA 1
#define NUM 2
#define FLOAT 3
#define SUMA 4
#define RESTA 5
#define MULTI 6
#define DIVIDE 7
#define PARENI 8
#define PAREND 9
#define LLAVEI 10
#define LLAVED 11
#define CORCHI 12
#define CORCHD 13
#define FINEXP 14

int yylval;
double yylvalF;
%}

LETRA [A-Za-z]
DIGITO [0-9]
DIGITOSINCERO [1-9]

%%
"00"{DIGITO}* {return NA; /* Operacion NO VALIDA */}
"00"{DIGITO}*.{DIGITO}* {return NA; /* Operacion NO VALIDA */}
{DIGITOSINCERO}{DIGITO}* {yylval = atoi(yytext); return NUM; /* Convierte el NUM a numero */}
"0" {yylval = atoi(yytext); return NUM; /* Convierte el NUM a numero */}
"0."{DIGITO}* {yylvalF = atof(yytext); return FLOAT; /* Convierte el NUM a float */}
"+"       {return SUMA; /* Se encontro un simbolo de suma */}
"-"       {return RESTA;/* Se encontro un simbolo de resta */}
"*"       {return MULTI;/* Se encontro un simbolo de multiplicacion */}
"/"       {return DIVIDE;/* Se encontro un simbolo de division */}
"("       {return PARENI;/* Se encontro un "(" */}
")"       {return PAREND;/* Se encontro un ")" */}
"{"       {return LLAVEI;/* Se encontro un "{" */}
"}"       {return LLAVED;/* Se encontro un "}" */}
"["       {return CORCHI;/* Se encontro un "[" */}
"]"       {return CORCHD;/* Se encontro un "]" */}
"$"       {return FINEXP;/* Se encontro un $, que es simbolo de fin de expr */}

%%

int main(int argc, char * argv[]) {

  int lectura;

  if (argc < 2) {
    printf ("Error, falta el nombre de un archivo\n");
    exit(1);
  }

  yyin = fopen(argv[1], "r");

  if (yyin == NULL) {
    printf("Error: el archivo no existe\n");
    exit(1);
  }

  /* yylex es la funcion que flex provee */

  while ((lectura = yylex()) != FINEXP) {
      printf("La ficha encontrada es %d y corresponde a %s\n", lectura, yytext);
      if (lectura == NA) printf("Operacion NO ACEPTADA\n");
      if (lectura == NUM) printf("El valor numerico es %d\n", yylval);
      if (lectura == FLOAT) printf("El valor numerico es %f\n", yylvalF);
  }
}
