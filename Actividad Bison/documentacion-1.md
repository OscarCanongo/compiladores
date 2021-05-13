# Actividad Bison
Oscar Cañongo - A01730443

## Pasos para ejecutar el programa
	flex calculadora.lex
	bison -d calculadora.y
	gcc lex.yy.c calculadora.tab.c -lfl -lm
	./a.out
