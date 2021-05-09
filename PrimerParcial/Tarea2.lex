/* Ejercicio.

   Usando flex implemente un reconocedor léxico de un lenguaje de progra- mación que tiene los siguientes elementos:
   - Números enteros y números de punto flotante como los de 
   - Identificadores como los de Java.
   - Las palabras reservadas: begin, end, while, while, begin, end, int, float, boolean
   - . Los símbolos de operaciones aritméticas {+,-,*,/}, los símbolos de puntuación
acostumbrados (coma, paréntesis, llaves, corchetes, punto, etc.) y los símbolos:
<-, =, <, >, <=, >=. 

   Este ejercicio debe entregarse a mas tardar el dia 22 de marzo de 2021.
   
*/
%{
#include<stdio.h>
#include<stdlib.h>
#include<math.h>

  /* Definimos algunas constantes para identificar fichas */
#define resBEGIN 1
#define resWHILE 2
#define resINT 3
#define resFLOAT 4
#define resBOOLEAN 5
#define IDENT 6
#define NUM 7
#define FLOAT 8
#define SUMA 9
#define RESTA 10
#define MULTI 11
#define DIVIDE 12
#define PARENI 13
#define PAREND 14
#define LLAVEI 15
#define LLAVED 16
#define CORCHI 17
#define CORCHD 18
#define MEGUI 19
#define IGUAL 20
#define MENOR 21
#define MAYOR 22
#define MENIGU 23
#define MAYIGU 24
#define COMA 25
#define PUNTO 26
#define PUNCOM 27
#define DOSPUN 28
#define FINEXP 29

int yylval;
double yylvalF;
char *yylvalI;
%}

LETRA [A-Za-z]
DIGITO [0-9]
DIGITOSINCERO [1-9]
ESPECIAL [_|$]

%%
"end"       {return FINEXP;/* Se encontro un end, que es simbolo de fin de expr */}
<<EOF>>   {return FINEXP;/* Se encontro un espacio vacio, que es simbolo de fin de expr */}
"begin"       {return resBEGIN; /* Palabra reservada begin */} //begin
"while"       {return resWHILE; /* Palabra reservada while */} //while
"int"       {return resINT; /* Palabra reservada int */} //int
"float"       {return resFLOAT; /* Palabra reservada float */} //float
"boolean"       {return resBOOLEAN; /* Palabra reservada boolean */} //boolean
({ESPECIAL}|{LETRA})({ESPECIAL}|{LETRA}|{DIGITO})* { yylvalI = strdup(yytext); return IDENT; }
{DIGITO}{DIGITO}* {yylval = atoi(yytext); return NUM; /* Convierte el NUM a numero */}
{DIGITO}{DIGITO}*"."{DIGITO}{DIGITO}* {yylvalF = atof(yytext); return FLOAT; /* Convierte el NUM a float */}
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
","       {return COMA;/* Se encontro una "," */}
"."       {return PUNTO;/* Se encontro un "." */}
":"       {return DOSPUN;/* Se encontro un "." */}
";"       {return PUNCOM;/* Se encontro un "." */}
"<-"       {return MEGUI;/* Se encontro un "<-" */} 
"="       {return IGUAL;/* Se encontro un "=" */} 
"<"       {return MENOR;/* Se encontro un "<" */} 
">"       {return MAYOR;/* Se encontro un ">" */} 
"<="       {return MENIGU;/* Se encontro un "<=" */}
">="       {return MAYIGU;/* Se encontro un ">=" */}
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
      if (lectura == resBEGIN) printf("El valor de la palabra reservada es: %s\n", yytext);
      if (lectura == resBOOLEAN) printf("El valor de la palabra reservada es: %s\n", yytext);
      if (lectura == resWHILE) printf("El valor de la palabra reservada es: %s\n", yytext);
      if (lectura == resFLOAT) printf("El valor de la palabra reservada es: %s\n", yytext);
      if (lectura == resINT) printf("El valor de la palabra reservada es: %s\n", yytext);
      if (lectura == IDENT) printf("El valor del identificador es %s\n", yylvalI);
      if (lectura == NUM) printf("El valor entero es %d\n", yylval);
      if (lectura == FLOAT) printf("El valor flotante es %f\n", yylvalF);
  }
}
