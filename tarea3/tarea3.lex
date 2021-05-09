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
#define resID 29
#define resIF 30
#define resELSE 31
#define FINEXP 32

int yylval;
double yylvalF;
char *yylvalI;
int current;
int linea=1;

int error();

void prog();
void stmt();
void stmt1();
void opt_stmts();
void stmt_lst();
void stmt_lst1();
void expr();
void expr1();
void term();
void term1();
void factor();
void expresion();
void expresion1();

void firstFactor();

void debug(char *non_terminal);
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
"id"       {return resID;/* Palabra reservada id */} //id
"if"       {return resIF;/* Palabra reservada if */} //if
"else"       {return resELSE;/* Palabra reservada if */} //else
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
"\n"       {linea++;}
%%
//error
int error(){
    printf("Error de sintaxis en: %s en la linea: %d\n", yytext, linea);
    exit(1);
}

//debug
void debug(char *non_terminal){
    printf("*** %s \t\t | text=%s [token: %d] at line: %d\n", non_terminal, yytext, current, yylineno);
}

//FirstFactor para llamar a expr
void firstFactor(){
  current = yylex();
  debug("FIRSTFactor");
  if(current == PARENI || current == IDENT || current == NUM){
    expr();
  }else{
    debug("ERROR FIRSTFactor");
    error();
  }
}

//term1 -> *term1 || /term1 || vacio
void term1(){
  current = yylex();
  debug("TERM1");
  if(current == MULTI || current == DIVIDE){
    term1();
  } else{
    return;
  }
}

//factor -> (expr) | id | num
void factor(){
  debug("FACTOR");
  if(current == PARENI){
    firstFactor();
    current = yylex();
    if(current != PAREND){
      error();
      debug("ERROR Factor");
    }
  } 
}

//expr1 -> + term expr1 | - term expr1 | vacio
void expr1(){
  current = yylex();
  debug("EXPR1");
  if(current == SUMA){
    firstFactor();
    term();
    expr1();
  } else if(current == RESTA){
    firstFactor();
    term();
    expr1();
  } else{
    debug("TERMINA expr1");
  } 
}

//term -> factor term1
void term(){ 
  debug("TERM");
  factor(); 
  term1();  
}

//expresion1 -> < expr | = expr | expr <= expr || expr >= expr
void expresion1(){
  current = yylex();
  debug("EXPRESION1");
  if(current == MENOR){
    expr();
  } else if(current == IGUAL){
    expr();
  } else{
    if(current == PARENI || current == IDENT || current == NUM){
      firstFactor();
      current = yylex();
      if(current == MENIGU || current == MAYIGU){
        firstFactor();
      } else{
        debug("ERROR expresion1");
        error();
      }
    } else{
      debug("ERROR expresion1");
      error();
    }
  }
}

//expr -> term expr1
void expr(){
  debug("EXPR");
  term();
  debug("EXPR"); 
  expr1(); 
}

//stmt1 -> else stmt | vacio
void stmt1(){
  current = yylex();
  debug("STMT1");
  if(current == resELSE){
    stmt();
  } 
}

//expresion -> expr expresion1
void expresion(){
  debug("EXPRESION");
  firstFactor(); 
  expresion1();  
}

//stmt_lst1 -> ; stmt_lst | vacio
void stmt_lst1(){
  debug("STMTLST1");
  current = yylex();
  if(current == PUNCOM){
    stmt_lst();
  } else{
    debug("TERMINA stmt_lst");
  }
}

//stmt -> id <- expr | if(expresion)stmt stmt1 | while(expresion)stmt | begin opt_stmts end
void stmt(){
  debug("STMT");
  if(current == IDENT){
    current = yylex();
    debug("STMT IDENT");
    if(current == MEGUI){
      debug("STMT MEGUI");
      firstFactor();
    } else{
      debug("ERROR iden");
      error();
    }
  } else if(current == resIF){
    current = yylex();
    if(current == PARENI){
      expresion();
      current = yylex();
      if(current == PAREND){
        stmt();
        stmt1(); 
      } else{
        debug("ERROR iden");
        error();
      }
    } else{
      debug("ERROR iden");
      error();
    }
  } else if(current == resWHILE){
    current = yylex();
    if(current == PARENI){
      expresion(); 
      current = yylex();
      if(current == PAREND){
        stmt();
      } else{
        debug("ERROR iden");
        error();
      }
    } else{
      debug("ERROR iden");
      error();
    }
  } if(current == resBEGIN){
    opt_stmts();
    current = yylex();
    if(current != FINEXP){
      debug("ERROR iden");
      error();
    }
  } else{
    debug("ERROR iden cae en el else");
    error();
  }
}

//stmt_lst -> stmt stmt_lst1;
void stmt_lst(){
  debug("SMTLST");
  stmt();
  debug("SMTLST");
  stmt_lst1(); 
}

//opt_stmts -> stmt_lst | vacio.
void opt_stmts(){
  debug("OPT_STMT");
  if(current == FINEXP){
      return;
  } else {
    stmt_lst();
  }
}

//prog -> begin opt_stmts end.
void prog(){
  current = yylex();
  debug("PROG");
  if(current == resBEGIN){
    current = yylex();
    opt_stmts();
    if(current != FINEXP){
      error();
    }
  } else {
    error();
  }
}

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

  prog();
  printf("FELICIDADES! TODO BIEN\n");

}
