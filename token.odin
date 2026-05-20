// This file defines the tokens of the Monkey language.
package sprak

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

Token :: struct {
	type:    TokenType,
	literal: string,
}
