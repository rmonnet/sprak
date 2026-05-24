// This file contains the Monkey language parser.
package sprak

Parser :: struct {
	lexer:      ^Lexer,
	cur_token:  Token,
	next_token: Token,
}

parser_create :: proc(l: ^Lexer) -> ^Parser {

	p := new(Parser)
	p.lexer = l
	// Read two tokens so cur_token and next_token are both populated.
	parse_token(p)
	parse_token(p)
	return p
}

parser_destroy :: proc(p: ^Parser) {

	lexer_destroy(p.lexer)
	free(p)
}

parse_token :: proc(p: ^Parser) {
	p.cur_token = p.next_token
	p.next_token = next_token(p.lexer)
}

parse_program :: proc(p: ^Parser) -> ^Program {

	program := new(Program)

	for p.cur_token.type != .End_Of_File {
		stmt := parse_statement(p)
		if stmt != nil {
			append(&program.stmts, stmt)
		}
		parse_token(p)
	}
	return program
}

parse_statement :: proc(p: ^Parser) -> Statement {
	stmt: Statement
	#partial switch p.cur_token.type {
	case .Let:
		stmt = parse_let_statement(p)
	case:
		stmt = nil
	}
	return stmt
}

parse_let_statement :: proc(p: ^Parser) -> Statement {

	stmt := LetStmt {
		token = p.cur_token,
	}
	if !next_token_is(p, .Ident) {
		// TODO: Should really emit an error message.
		return nil
	}
	stmt.identifier = IdentExpr {
		token = p.cur_token,
		value = p.cur_token.literal,
	}

	if !next_token_is(p, .Assign) {
		// TODO: Should really emit an error message.
		return nil
	}

	// TODO: skip to the next semicolon. Will need to add processing to parse the expression.
	for !next_token_is(p, .Semicolon) {
		parse_token(p)
	}

	return stmt
}

next_token_is :: proc(p: ^Parser, type: TokenType) -> bool {

	if p.next_token.type != type {return false}
	parse_token(p)
	return true
}

