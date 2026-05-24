// This file contains the definitions for the Monkey Abstract Syntax Tree.
package sprak

Statement :: union {
	LetStmt,
}

Expression :: union {
	IdentExpr,
}

stmt_token_literal :: proc(s: Statement) -> string {
	switch stmt in s {
	case LetStmt:
		return stmt.token.literal
	}
	panic("Unknown Statement Type")
}


expr_token_literal :: proc(e: Expression) -> string {
	switch expr in e {
	case IdentExpr:
		return expr.token.literal
	}
	panic("Unknown Expression Type")
}

Program :: struct {
	stmts: [dynamic]Statement,
}

program_destroy :: proc(p: ^Program) {

	delete(p.stmts)
	free(p)
}

prg_token_literal :: proc(p: Program) -> string {

	if len(p.stmts) == 0 {return ""}
	return stmt_token_literal(p.stmts[0])
}

LetStmt :: struct {
	token:      Token, // The .Let token
	identifier: IdentExpr,
	value:      Expression,
}

IdentExpr :: struct {
	token: Token, // The .Ident token
	value: string,
}

