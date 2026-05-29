// This file contains the definitions for the Monkey Abstract Syntax Tree.
package sprak

import "core:strings"
// -------------------------------
// Statements
// -------------------------------

// `Statement` defines the different types of statements supported by the Monkey language.
Statement :: union {
	Let_Stmt,
	Return_Stmt,
	Expression_Stmt,
}

// `Let_Stmt` defines the data for a `let <ident> = <expr>;` statement.
Let_Stmt :: struct {
	token:      Token, // The .Let token
	identifier: Ident_Expr,
	value:      Expression,
}

// `Return_Stmt` defines the data for a `return <expr>;` statement.
Return_Stmt :: struct {
	token:        Token, // The .Return token
	return_value: Expression,
}

// `Expression_Stmt` defines the data for an expression when wrapped as a statement.
Expression_Stmt :: struct {
	token: Token, // The .Statement Token
	expr:  Expression,
}

// `stmt_token_literal` returns the token literal associated with the statement.
// TODO; We could consider making the token a common part of Statement and the rest a variant.
stmt_token_literal :: proc(s: Statement) -> string {
	// TODO: I think we can make token a common field in Statement and get rid of this procedure.
	switch stmt in s {
	case Let_Stmt:
		return stmt.token.literal
	case Return_Stmt:
		return stmt.token.literal
	case Expression_Stmt:
		return stmt.token.literal
	}
	panic("Unknown Expression Type")
}

// `stmt_to_string` returns the string representation for a statement.
// It is used for debugging and testing.
stmt_to_string :: proc(s: Statement) -> string {
	buf := strings.builder_make()
	stmt_write(&buf, s)
	return strings.to_string(buf)
}

// `stmt_write` write the string representation of the statement to the buffer.
stmt_write :: proc(buf: ^strings.Builder, s: Statement) {

	write :: proc {
		strings.write_string,
		strings.write_byte,
	}

	switch stmt in s {
	case Let_Stmt:
		write(buf, "let ")
		expr_write(buf, stmt.identifier)
		write(buf, " = ")
		if stmt.value != nil {expr_write(buf, stmt.value)}
		write(buf, ';')
	case Return_Stmt:
		write(buf, "return ")
		expr_write(buf, stmt.return_value)
		write(buf, ';')
	case Expression_Stmt:
		if stmt.expr != nil {
			expr_write(buf, stmt.expr)
		}
	case:
		panic("Unknown Expression Type")
	}
}

// -------------------------------
// Statements
// -------------------------------

// `Expression` defines all the types of expressions supported by the Monkey language.
Expression :: union {
	Ident_Expr,
}

// `IdentExpr` defines the data for the `<ident>` expression.
Ident_Expr :: struct {
	token: Token, // The .Ident token
	value: string,
}

// `expr_token_literal` returns the token literal associated with the expression.
expr_token_literal :: proc(e: Expression) -> string {
	switch expr in e {
	case Ident_Expr:
		return expr.token.literal
	case:
		panic("Unknown Expression Type")
	}
}

expr_write :: proc(buf: ^strings.Builder, e: Expression) {

	write :: proc {
		strings.write_string,
		strings.write_byte,
	}

	switch expr in e {
	case Ident_Expr:
		write(buf, expr.value)
	case:
		panic("Unknown Expression Type")
	}
}

// -------------------------------
// Program
// -------------------------------

// `Program` defines the state of a parsed unit of source code.
Program :: struct {
	stmts: [dynamic]Statement,
}

// `program_create returns a new `Program`.
program_create :: proc() -> ^Program {
	return new(Program)
}

// `program_destroy` reclaims the memory associated with a `Program`.
program_destroy :: proc(p: ^Program) {

	delete(p.stmts)
	// TODO: we have to provide a program_create so that we never try to free a stack variable.
	// One solution would be to rename this program_destroy_fields and let the caller clean the Program var when needed.
	// Or we could let `program_parse()` return a Program instead of a ^Program.
	free(p)
}

// `prog_token_literal` return the token literal of the first element of a program.
prog_token_literal :: proc(p: Program) -> string {

	if len(p.stmts) == 0 {return ""}
	return stmt_token_literal(p.stmts[0])
}

// `prog_to_string` returns the string representation of a program.
prog_to_string :: proc(p: Program) -> string {
	buf := strings.builder_make()
	prog_write(&buf, p)
	return strings.to_string(buf)
}

// `prog_write` write the string representation of the program to the buffer.
prog_write :: proc(buf: ^strings.Builder, p: Program) {
	for stmt in p.stmts {
		stmt_write(buf, stmt)
	}
}

// -------------------------------
// Utilities
// -------------------------------

