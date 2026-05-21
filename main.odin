// This file contains the entry point for the Monkey interpreter.
package sprak

import "core:fmt"
import "core:os"

// `main_debug` is a dummy procedure used to host code to debug during development.
// It should be removed from the final product.
main_debug :: proc() {

	input := `
let five = 5;
let ten = 10;

let add = fn(x,y) {
	x + y;
};

let result = add(five, ten);
`

	lexer := lexer_create(input)
	defer lexer_destroy(lexer)

	token := next_token(lexer)
	fmt.println(token)

	token = next_token(lexer)
	fmt.println(token)
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
	main_repl()
}

