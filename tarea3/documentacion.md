# Tarea 3 compiladores
Oscar Cañongo - A01730443
## Grámatica LL1
	prog -> begin opt_stmts and
	stmt -> id <- expr | if(expresion)stmt stmt’ | while(expresion)stmt | begin opt_stmts 	end
	stmt’ -> else stmt | ε
	opt_stmts -> stmt_lst | ε
	smts_lst -> smts smts_lst’
	smts_lst’ -> ;stmt_lst | ε
	expr -> term expr’
	expr’ -> + term expr’ | - term expr’ | ε  
	term -> factor term’
	term’ -> * term | /term | ε
	factor -> (expr)| id| num
	expresion ->   expr expresion’ 
	expresion’ -> < expr | > expr | = expr | <= expr | >= expr

## Pasos para ejecutar el programa
	flex Tarea3v1.lex
	gcc lex.yy.c -lfl
	./a.out nombredetuprograma.txt
