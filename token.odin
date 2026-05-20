// This file defines the tokens of the Monkey language.
package sprak

TokenType :: enum {
	Illegal,
	End_Of_File,
	Ident,
	Int,
	Assign,
	Plus,
	Comma,
	Semicolon,
	Left_Paren,
	Right_Paren,
	Left_Bracket,
	Right_Bracket,
	Let,
	Function,
}

Token :: struct {
	type:    TokenType,
	literal: string,
}
