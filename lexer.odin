// This files contains the logic for the Monkey lexer
package sprak

import "core:strings"

Lexer :: struct {
	input:    string,
	cur_pos:  int,
	next_pos: int,
	mark:     int,
	ch:       byte,
}

lexer_create :: proc(input: string) -> ^Lexer {

	lexer := new(Lexer)
	lexer.input = input
	read_char(lexer)
	return lexer
}

lexer_destroy :: proc(l: ^Lexer) {

	free(l)
}

next_token :: proc(l: ^Lexer) -> Token {

	skip_whitespace(l)
	mark_token_start(l)

	token: Token
	switch l.ch {
	case '=':
		if peek_char(l^) == '=' {
			read_char(l)
			token = Token{.Equal, cur_literal(l^)}
		} else {
			token = Token{.Assign, cur_literal(l^)}
		}
	case '+':
		token = Token{.Plus, cur_literal(l^)}
	case '-':
		token = Token{.Minus, cur_literal(l^)}
	case '!':
		if peek_char(l^) == '=' {
			read_char(l)
			token = Token{.Not_Equal, cur_literal(l^)}
		} else {
			token = Token{.Bang, cur_literal(l^)}
		}
	case '/':
		token = Token{.Slash, cur_literal(l^)}
	case '*':
		token = Token{.Star, cur_literal(l^)}
	case ';':
		token = Token{.Semicolon, cur_literal(l^)}
	case ',':
		token = Token{.Comma, cur_literal(l^)}
	case '<':
		token = Token{.Less_Than, cur_literal(l^)}
	case '>':
		token = Token{.Greater_Than, cur_literal(l^)}
	case '(':
		token = Token{.Left_Paren, cur_literal(l^)}
	case ')':
		token = Token{.Right_Paren, cur_literal(l^)}
	case '{':
		token = Token{.Left_Bracket, cur_literal(l^)}
	case '}':
		token = Token{.Right_Bracket, cur_literal(l^)}
	case 0:
		token = Token{.End_Of_File, ""}
	case:
		if is_letter(l.ch) {
			token = read_identifier(l)
		} else if is_digit(l.ch) {
			token = read_number(l)
		} else {
			token = Token{.Illegal, cur_literal(l^)}
		}
	}
	read_char(l)
	return token
}

skip_whitespace :: proc(l: ^Lexer) {

	for l.ch == ' ' || l.ch == '\t' || l.ch == '\n' || l.ch == '\r' {
		read_char(l)
	}
}

read_identifier :: proc(l: ^Lexer) -> Token {

	for is_letter(peek_char(l^)) {
		read_char(l)
	}
	literal := cur_literal(l^)
	type := lookup_ident(literal)
	return Token{type, literal}
}

read_number :: proc(l: ^Lexer) -> Token {

	for is_digit(peek_char(l^)) {
		read_char(l)
	}
	literal := cur_literal(l^)
	return Token{.Int, literal}
}

is_letter :: proc(ch: byte) -> bool {

	return 'a' <= ch && ch <= 'z' || 'A' <= ch && ch <= 'Z' || ch == '_'
}

is_digit :: proc(ch: byte) -> bool {

	return '0' <= ch && ch <= '9'
}

cur_literal :: proc(l: Lexer) -> string {

	literal, ok := strings.substring(l.input, l.mark, l.next_pos)
	if !ok {
		panic("Unable to get the current literal out of the lexer input.")
	}
	return literal
}

// Set a mark in the input stream at the current position.
// This is used when starting parsing a new token.
mark_token_start :: proc(l: ^Lexer) {

	l.mark = l.cur_pos
}

peek_char :: proc(l: Lexer) -> byte {

	if l.next_pos >= len(l.input) {return 0}
	return l.input[l.next_pos]
}

read_char :: proc(l: ^Lexer) {

	if l.next_pos >= len(l.input) {
		l.ch = 0
	} else {
		l.ch = l.input[l.next_pos]
	}
	l.cur_pos = l.next_pos
	l.next_pos += 1
}

lookup_ident :: proc(ident: string) -> TokenType {

	type: TokenType
	switch ident {
	case "fn":
		type = .Function
	case "let":
		type = .Let
	case "true":
		type = .True
	case "false":
		type = .False
	case "if":
		type = .If
	case "else":
		type = .Else
	case "return":
		type = .Return
	case:
		type = .Ident
	}
	return type
}
