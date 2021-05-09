/*  
    Oscar Canongo Vergara
    A01730443
*/

/* Ejercicio.

    El objetivo del ejercicio es que construyan un reconocedor sintáctico descendente predictivo de
    la gramática que se muestra más abahjo y que genera un lenguaje de programación muy básico.
    La gramática tiene que ser convertida a una gramática LL(1), tal como vimos en clase. Los
    sı́mbolos que aparecen en negritas son elementos terminales de la gramática y deben ser reconocidos
    usando flex.
    Los identificadores ( id ) y los números ( num ) deben ser también reconocidos usando flex y
    son como en la tarea anterior. Para esta gramática sólo es necesario reconocer números enteros.
    La entrada a su reconocedor debe ser un archivo de texto cuyo nombre debe ser leı́do como parte
    del comando de llamada al reconocedor en la consola. La salida debe ser un mensaje de aceptación
    si no hay errores de sintaxis o un mensaje de error de sintaxis en caso de encontrar alguno. El
    mensaje de error debe, al menos, decir el número de lı́nea donde el error está.
    Deben documentar su código. Es neceario que me indiquen cómo compilar y correr sus progra-
    mas, esto es, la documentación debe indicar los comandos necesarios para hacer la compilación y
    la ejecución de su reconocedor sintáctico. La documentación lleva un 30   
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
int prevCurrent = 0;
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

//void debug(char *non_terminal);
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
//void debug(char *non_terminal){
  //  printf("*** %s \t\t | text=%s [token: %d] at line: %d\n", non_terminal, yytext, current, yylineno);
//}

//stmt1 -> else stmt | vacio
void stmt1(){
  current = yylex();
  //debug("STMT1");
  if(current == PUNCOM)
     stmt_lst1();   
  else if(current == resELSE){
    current = yylex();
    stmt();
  } else if(current != FINEXP){
    error();
  }
}

//expresion1 -> < expr | = expr | expr <= expr || expr >= expr
void expresion1(){
  //current = yylex();
  //debug("EXPRESION1");
  if(current == MENOR || current == IGUAL || current == MENIGU || current == MAYIGU || current == MAYOR){
    expr();
  } else{
    //debug("error expresion1");
    error();
  }
}

//expresion -> expr expresion1
void expresion(){
  //debug("EXPRESION");
  expr();
  //debug("EXPRESION 1");
  expresion1();  
}

//expr -> term expr1
void expr(){
  //debug("EXPR");
  term();
  //debug("EXPR"); 
  expr1(); 
}

//expr1 -> + term expr1 | - term expr1 | vacio
void expr1(){
  //debug("EXPR1");
  if(current == SUMA || current == RESTA){
    term();
    expr1();
  } else{
    //debug("TERMINA expr1");
  } 
}

//term1 -> *term1 || /term1 || vacio
void term1(){
  current = yylex();
  //debug("TERM1");
  if(current == MULTI || current == DIVIDE){
    term();
  } else{
    return;
  }
}

//factor -> (expr) | id | num
void factor(){
  current = yylex();
  //debug("FACTOR");
  if(current == PARENI){
    expr();
    if(current != PAREND)
        current = yylex();
    //debug("CURRENT FACTOR PARENI");
    if(current != PAREND){
      error();
      //debug("ERROR Factor");
    }
  } else if(current != IDENT && current != NUM){
    //debug("ERROR FACTOR");
    error();
  }
}

//term -> factor term1
void term(){ 
  //debug("TERM");
  factor(); 
  term1();  
}

//stmt_lst1 -> ; stmt_lst | vacio
void stmt_lst1(){
  //debug("STMTLST1");
  if(current == PUNCOM){
    current = yylex();
    //debug("CURRENT STMTLST1");
    stmt_lst();
  } else {
    //debug("TERMINA stmt_lst1");
  }
}

//stmt -> id <- expr | if(expresion)stmt stmt1 | while(expresion)stmt | begin opt_stmts end
void stmt(){
  //debug("STMT");
  if(current == IDENT){
        current = yylex();
        //debug("STMT IDENT");
        if(current == MEGUI){
        //debug("STMT MEGUI");
        expr();
        } else{
        //debug("ERROR iden");
        error();
        }
  } else if(current == resIF){
        current = yylex();
        //debug("DENTRO IF");
        if(current == PARENI){
            expresion();
            if(current != PAREND)
                current == yylex();
            //debug("CURRENT PARENTESIS I");
            if(current == PAREND){
                current = yylex();
                //debug("CURRENT PARENTESIS D");
                stmt();
                //debug("PARA VER COMO ENTRA AL ELSE");
                stmt1();
            } else{
                error();
                //debug("ERROR parentesis derecho"); 
            }
        } else{
        //debug("ERROR parentesis izquierdo"); 
        error();
        }
  } else if(current == resWHILE){
        current = yylex();
        //debug("DENTRO WHILE");
        if(current == PARENI){
            expresion();
            if(current != PAREND)
                current == yylex();
            //debug("CURRENT PARENTESIS I WHILE");
            if(current == PAREND){
                current = yylex();
                //debug("CURRENT PARENTESIS D WHILE");
                stmt();
                //debug("PARA VER COMO ENTRA AL ELSE");
                stmt1();
            } else{
                error();
                //debug("ERROR parentesis derecho WHILE"); 
            }
        } else{
        //debug("ERROR parentesis izquierdo WHILE"); 
        error();
        }
  } else if(current == resBEGIN){
        opt_stmts();
        if(current != FINEXP)
            current = yylex();
        //debug("RES BEGIN");
        if(current != FINEXP){
            //debug("ERROR END");
            error();
        }
  } else{
        //debug("ERROR iden cae en el else");
        error();
  }
}

//stmt_lst -> stmt stmt_lst1;
void stmt_lst(){
  //debug("SMTLST");
  if(current == resBEGIN){
    current = yylex();
    //debug("ENTRANDO");
  }
  stmt();
  //debug("SMTLST antes de stmt_lst1");
  stmt_lst1(); 
}

//opt_stmts -> stmt_lst | vacio.
void opt_stmts(){
  //debug("OPT_STMT");
  if(current == FINEXP){
      return;
  } else {
    stmt_lst();
  }
}

//prog -> begin opt_stmts end.
void prog(){
  current = yylex();
  //debug("PROG");
  if(current == resBEGIN){
    current = yylex();
    //debug("RES BEGIN prog");
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
