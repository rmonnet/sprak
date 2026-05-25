// This file contains the definitions for the Monkey Abstract Syntax Tree.
package sprak

// -------------------------------
// Statements
// -------------------------------

// `Statement` defines the different types of statements supported by the Monkey language.
Statement :: union {
	Let_Stmt,
	Return_Stmt,
}

// `stmt_token_literal` returns the token literal associated with the statement.
stmt_token_literal :: proc(s: Statement) -> string {
	// TODO: I think we can make token a common field in Statement and get rid of this procedure.
	switch stmt in s {
	case Let_Stmt:
		return stmt.token.literal
	case Return_Stmt:
		return stmt.token.literal
	}
	panic("Unknown Statement Type")
}

// `LetStmt` defines the data for a `let <ident> = <expr>;` statement.
Let_Stmt :: struct {
	token:      Token, // The .Let token
	identifier: Ident_Expr,
	value:      Expression,
}

// `ReturnStmt` defines the data for a `return <expr>;` statement.
Return_Stmt :: struct {
	token:        Token, // The .Return token
	return_value: Expression,
}

// -------------------------------
// Statements
// -------------------------------

// `Expression` defines all the types of expressions supported by the Monkey language.
Expression :: union {
	Ident_Expr,
}

// `expr_token_literal` returns the token literal associated with the expression.
expr_token_literal :: proc(e: Expression) -> string {
	switch expr in e {
	case Ident_Expr:
		return expr.token.literal
	}
	panic("Unknown Expression Type")
}

// `IdentExpr` defines the data for the `<ident>` expression.
Ident_Expr :: struct {
	token: Token, // The .Ident token
	value: string,
}

// -------------------------------
// Program
// -------------------------------

// `Program` defines the state of a parsed unit of source code.
Program :: struct {
	stmts: [dynamic]Statement,
}

// `program_destroy` reclaims the memory associated with a `Program`.
program_destroy :: proc(p: ^Program) {

	delete(p.stmts)
	free(p)
}

// `prg_token_literal` return the token literal of the first element of a program.
prg_token_literal :: proc(p: Program) -> string {

	if len(p.stmts) == 0 {return ""}
	return stmt_token_literal(p.stmts[0])
}

// -------------------------------
// Utilities
// -------------------------------

