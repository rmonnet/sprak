// This file contains Monkey's lexer functionality and token definitions.
package sprak

import "core:strings"

// `TokenType` represents all the possible tokens for the Monkey language.
// `TokenType` variables, thanks to Odin zero value initialization, default to `Illegal`.
TokenType :: enum {
	Illegal,
	End_Of_File,
	Ident,
	Int,
	Assign,
	Plus,
	Minus,
	Bang,
	Star,
	Slash,
	Less_Than,
	Greater_Than,
	Equal,
	Not_Equal,
	Comma,
	Semicolon,
	Left_Paren,
	Right_Paren,
	Left_Bracket,
	Right_Bracket,
	Let,
	Function,
	True,
	False,
	If,
	Else,
	Return,
}

// `Token` represents a token extracted from the Monkey program source.
Token :: struct {
	type:    TokenType,
	literal: string,
}

// `Lexer` contains the state of the Monkey lexer.
// It keeps track of the program source and the progression of the lexer within the source.
Lexer :: struct {
	input:    string,
	cur_pos:  int,
	next_pos: int,
	mark:     int,
	ch:       byte,
}

// `lexer_create` creates a lexer object for the given program source.
lexer_create :: proc(input: string) -> ^Lexer {

	lexer := new(Lexer)
	// Explicitly copy the program source so we own it and can safely deallocate it later.
	lexer.input = strings.clone(input)
	read_char(lexer)
	return lexer
}

// `lexer_destroy` reclaims the memory associated with the lexer object.
lexer_destroy :: proc(l: ^Lexer) {

	delete(l.input)
	free(l)
}

// `next_token` reads the next token from the program source and returns it.
// If we are at the end of the program source, it returns `TokenType.End_Of_File`.
// If the program source is not valid, it returns `Token_Type.Illegal`.
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

// `skip_whitespace` will advance the lexer position after the last consecutive whitespace.
// space, tab, carriage return, and newline are all considered whitespace.
skip_whitespace :: proc(l: ^Lexer) {

	for l.ch == ' ' || l.ch == '\t' || l.ch == '\n' || l.ch == '\r' {
		read_char(l)
	}
}

// `read_identifier` consumes the current "word" as an identifier or a keyword and returns the appropriate token.
read_identifier :: proc(l: ^Lexer) -> Token {

	for is_letter(peek_char(l^)) {
		read_char(l)
	}
	literal := cur_literal(l^)
	type := lookup_keyword(literal)
	return Token{type, literal}
}

// `read_number` consumes the current "word" as a number and returns an Int token.
// Currently, this version of Monkey only supports integer in decimal format.
read_number :: proc(l: ^Lexer) -> Token {

	for is_digit(peek_char(l^)) {
		read_char(l)
	}
	literal := cur_literal(l^)
	return Token{.Int, literal}
}

// `is_letter` checks if the byte is a letter `[a-zA-Z_]`.
is_letter :: proc(ch: byte) -> bool {

	return 'a' <= ch && ch <= 'z' || 'A' <= ch && ch <= 'Z' || ch == '_'
}

// `is_digit` checks if the byte is a digit `[0-9]`.
is_digit :: proc(ch: byte) -> bool {

	return '0' <= ch && ch <= '9'
}

// `cur_literal `returns the literal currently being parsed by the lexer.
// This includes all characters from the last call to `mark_token_start` to the last character read with `read_char`.
cur_literal :: proc(l: Lexer) -> string {

	return string(l.input[l.mark:l.next_pos])
}

// `mark_token_start` sets a mark in the program source at the current position.
// This is set when starting to parse a new token and is used by `cur_literal` to extract
// the literal associated with the current token.
mark_token_start :: proc(l: ^Lexer) {

	l.mark = l.cur_pos
}

// `peek_char` returns the next character in the program source without consuming it.
// The next call to `read_char` will return the same character.
peek_char :: proc(l: Lexer) -> byte {

	if l.next_pos >= len(l.input) {return 0}
	return l.input[l.next_pos]
}

// `read_char` consumes the next character in the program source.
read_char :: proc(l: ^Lexer) {

	if l.next_pos >= len(l.input) {
		l.ch = 0
	} else {
		l.ch = l.input[l.next_pos]
	}
	l.cur_pos = l.next_pos
	l.next_pos += 1
}

// `lookup_keyword` checks if an identifier is a keyword and returns the appropriate `TokenType`.
// If the identifier doesn't match any keyword, then it returns `TokenType.Ident`.
//
// Note: In the book and most other examples of Lexer this is implemented as a Map lookup.
// In Odin, creating and initializing a package Map forces us to deal with allocation during
// package initialization. The lookup procedure solution avoid the allocation and is faster.
lookup_keyword :: proc(ident: string) -> TokenType {

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

