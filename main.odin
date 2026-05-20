package sprak

import "core:fmt"

main :: proc() {

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
