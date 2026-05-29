// This file contains the entry point for the Monkey interpreter.
package sprak

import "core:fmt"
import "core:os"

// `main_debug` is a dummy procedure used to host code to debug during development.
// It should be removed from the final product.
main_debug :: proc() {

	program: Program
	stmts := []Statement {
		Let_Stmt {
			token = Token{.Let, "let"},
			identifier = Ident_Expr{token = Token{.Ident, "myVar"}, value = "myVar"},
			value = Ident_Expr{token = Token{.Ident, "anotherVar"}, value = "anotherVar"},
		},
	}
	append(&program.stmts, ..stmts)

	actual := prog_to_string(program)
	fmt.println(actual)
}

// `main_repl` contains the REPL entry point.
main_repl :: proc() {

	fmt.println("Monkey Programming Language.")
	fmt.println("Please enter commands.")
	repl_run(os.stdin, os.stdout)
}

// `main` is the REPL or debug session entry point.
// In the final product this will be replaced by `main_repl`.
main :: proc() {

	//main_debug()
	main_debug()
}

