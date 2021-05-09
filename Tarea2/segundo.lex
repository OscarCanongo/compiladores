LETRA 	[a-zA-Z]
DIGITO 	[0-9]
BIN 	[0-1]
%%
"10"{BIN}*"01"	{ printf("acepta %s\n", yytext);return 0;}
.* 				{printf("no acepta %s\n",yytext); return 0;}
%%
int main(){
	yylex();
}