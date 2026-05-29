// This file contains the Monkey language parser.
package sprak

import "core:fmt"

// `Parser` defines the state associated with a parser for Monkey.
Parser :: struct {
	lexer:      ^Lexer,
	errors:     [dynamic]string,
	cur_token:  Token,
	next_token: Token,
}

// `parser_create` allocates and return a `Parser` for the Monkey language.
parser_create :: proc(l: ^Lexer) -> ^Parser {

	p := new(Parser)
	p.lexer = l
	// Read two tokens so cur_token and next_token are both populated.
	parse_token(p)
	parse_token(p)
	return p
}

// `parser_destroy` reclaims the memory associated with a `Parser` object.
parser_destroy :: proc(p: ^Parser) {

	lexer_destroy(p.lexer)
	for &error in p.errors {
		delete(error)
	}
	delete(p.errors)
	free(p)
}

// `parse_token` parses the next token in the source code.
// When the end of the code is reached, the token is set to `TokenType.End_Of_File`.
parse_token :: proc(p: ^Parser) {
	p.cur_token = p.next_token
	p.next_token = next_token(p.lexer)
}

// `parse_program` parse an entire unit of source code.
parse_program :: proc(p: ^Parser) -> ^Program {

	program := program_create()

	for p.cur_token.type != .End_Of_File {
		stmt := parse_statement(p)
		if stmt != nil {
			append(&program.stmts, stmt)
		}
		parse_token(p)
	}
	return program
}

// `log_error` records an error encountered during parsing in the `Parser` state.
log_error :: proc(p: ^Parser, template: string, args: ..any) {

	msg := fmt.aprintf(template, ..args)
	append(&p.errors, msg)
}

// `parse_statement` parses the next statement in the source code.
// This is the entry point for the Recursive Descent Parser.
parse_statement :: proc(p: ^Parser) -> Statement {
	stmt: Statement
	#partial switch p.cur_token.type {
	case .Let:
		stmt = parse_let_statement(p)
	case .Return:
		stmt = parse_return_statement(p)
	case:
		stmt = nil
	}
	return stmt
}

// `parse_let_statement` parses a `let <ident> = <expr>;` statement.
parse_let_statement :: proc(p: ^Parser) -> Statement {

	stmt := Let_Stmt {
		token = p.cur_token,
	}
	if !consume_token(p, .Ident) {return nil}
	stmt.identifier = Ident_Expr {
		token = p.cur_token,
		value = p.cur_token.literal,
	}

	if !consume_token(p, .Assign) {return nil}

	// TODO: skip to the next semicolon. Will need to add processing to parse the expression.
	for p.next_token.type != .Semicolon {
		parse_token(p)
	}

	return stmt
}

// `parse_return_statement` parses a `return <expr>;` statement.
parse_return_statement :: proc(p: ^Parser) -> Statement {

	stmt := Return_Stmt {
		token = p.cur_token,
	}

	// TODO: skip to the next semicolon. Will need to add processing to parse the expression.
	for p.next_token.type != .Semicolon {
		parse_token(p)
	}

	return stmt
}

// `consume_token` consumes the next token if the token type matches the specified
// type. If it doesn't, it logs an error but doesn't consume the token.
consume_token :: proc(p: ^Parser, type: TokenType) -> bool {

	if p.next_token.type != type {
		log_error(p, "expected next token to be %v, got %v instead", type, p.next_token.type)
		return false
	}
	parse_token(p)
	return true
}

