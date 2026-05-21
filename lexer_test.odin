// This file contains the tests for the Monkey lexer.
package sprak

import "core:testing"

expect_next_token :: proc(
	t: ^testing.T,
	l: ^Lexer,
	type: TokenType,
	literal: string,
	loc := #caller_location,
) {

	token := next_token(l)
	testing.expect_value(t, token.type, type, loc = loc)
	testing.expect_value(t, token.literal, literal, loc = loc)
}

@(test)
test_next_token :: proc(t: ^testing.T) {

	input := `
let five = 5;
let ten = 10;

let add = fn(x,y) {
	x + y;
};

let result = add(five, ten);
!-/*5;
5 < 10 > 5;

if (5 < 10) {
	return true;
} else {
	return false;
}

10 == 10;
10 != 9;
`
	lexer := lexer_create(input)
	defer lexer_destroy(lexer)

	expect_next_token(t, lexer, .Let, "let")
	expect_next_token(t, lexer, .Ident, "five")
	expect_next_token(t, lexer, .Assign, "=")
	expect_next_token(t, lexer, .Int, "5")
	expect_next_token(t, lexer, .Semicolon, ";")
	expect_next_token(t, lexer, .Let, "let")
	expect_next_token(t, lexer, .Ident, "ten")
	expect_next_token(t, lexer, .Assign, "=")
	expect_next_token(t, lexer, .Int, "10")
	expect_next_token(t, lexer, .Semicolon, ";")
	expect_next_token(t, lexer, .Let, "let")
	expect_next_token(t, lexer, .Ident, "add")
	expect_next_token(t, lexer, .Assign, "=")
	expect_next_token(t, lexer, .Function, "fn")
	expect_next_token(t, lexer, .Left_Paren, "(")
	expect_next_token(t, lexer, .Ident, "x")
	expect_next_token(t, lexer, .Comma, ",")
	expect_next_token(t, lexer, .Ident, "y")
	expect_next_token(t, lexer, .Right_Paren, ")")
	expect_next_token(t, lexer, .Left_Bracket, "{")
	expect_next_token(t, lexer, .Ident, "x")
	expect_next_token(t, lexer, .Plus, "+")
	expect_next_token(t, lexer, .Ident, "y")
	expect_next_token(t, lexer, .Semicolon, ";")
	expect_next_token(t, lexer, .Right_Bracket, "}")
	expect_next_token(t, lexer, .Semicolon, ";")
	expect_next_token(t, lexer, .Let, "let")
	expect_next_token(t, lexer, .Ident, "result")
	expect_next_token(t, lexer, .Assign, "=")
	expect_next_token(t, lexer, .Ident, "add")
	expect_next_token(t, lexer, .Left_Paren, "(")
	expect_next_token(t, lexer, .Ident, "five")
	expect_next_token(t, lexer, .Comma, ",")
	expect_next_token(t, lexer, .Ident, "ten")
	expect_next_token(t, lexer, .Right_Paren, ")")
	expect_next_token(t, lexer, .Semicolon, ";")
	expect_next_token(t, lexer, .Bang, "!")
	expect_next_token(t, lexer, .Minus, "-")
	expect_next_token(t, lexer, .Slash, "/")
	expect_next_token(t, lexer, .Star, "*")
	expect_next_token(t, lexer, .Int, "5")
	expect_next_token(t, lexer, .Semicolon, ";")
	expect_next_token(t, lexer, .Int, "5")
	expect_next_token(t, lexer, .Less_Than, "<")
	expect_next_token(t, lexer, .Int, "10")
	expect_next_token(t, lexer, .Greater_Than, ">")
	expect_next_token(t, lexer, .Int, "5")
	expect_next_token(t, lexer, .Semicolon, ";")
	expect_next_token(t, lexer, .If, "if")
	expect_next_token(t, lexer, .Left_Paren, "(")
	expect_next_token(t, lexer, .Int, "5")
	expect_next_token(t, lexer, .Less_Than, "<")
	expect_next_token(t, lexer, .Int, "10")
	expect_next_token(t, lexer, .Right_Paren, ")")
	expect_next_token(t, lexer, .Left_Bracket, "{")
	expect_next_token(t, lexer, .Return, "return")
	expect_next_token(t, lexer, .True, "true")
	expect_next_token(t, lexer, .Semicolon, ";")
	expect_next_token(t, lexer, .Right_Bracket, "}")
	expect_next_token(t, lexer, .Else, "else")
	expect_next_token(t, lexer, .Left_Bracket, "{")
	expect_next_token(t, lexer, .Return, "return")
	expect_next_token(t, lexer, .False, "false")
	expect_next_token(t, lexer, .Semicolon, ";")
	expect_next_token(t, lexer, .Right_Bracket, "}")
	expect_next_token(t, lexer, .Int, "10")
	expect_next_token(t, lexer, .Equal, "==")
	expect_next_token(t, lexer, .Int, "10")
	expect_next_token(t, lexer, .Semicolon, ";")
	expect_next_token(t, lexer, .Int, "10")
	expect_next_token(t, lexer, .Not_Equal, "!=")
	expect_next_token(t, lexer, .Int, "9")
	expect_next_token(t, lexer, .Semicolon, ";")
	expect_next_token(t, lexer, .End_Of_File, "")
}

