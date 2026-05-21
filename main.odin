package sprak

import "core:fmt"
import "core:os"

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

main_repl :: proc() {

	fmt.println("Monkey Programming Language.")
	fmt.println("Please enter commands.")
	repl_start(os.stdin, os.stdout)
}

main :: proc() {

	main_repl()
}
