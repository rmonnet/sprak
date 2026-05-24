package sprak

import "core:testing"

@(test)
test_let_statements :: proc(t: ^testing.T) {

	input := `
let x = 5;
let y = 10;
let foobar = 838383;
`

	lexer := lexer_create(input)
	parser := parser_create(lexer)
	defer parser_destroy(parser)

	program := parse_program(parser)
	defer program_destroy(program)
	if program == nil {
		testing.expect(t, false, "parse_program() returned nil")
		return
	}
	if len(program.stmts) != 3 {
		testing.expectf(t, false, "len(program.stmts): expected 3, got %d", len(program.stmts))
		return
	}

	expected := []string{"x", "y", "foobar"}
	for name, i in expected {
		stmt := program.stmts[i]
		test_let_statement(t, stmt, name)
	}
}

test_let_statement :: proc(
	t: ^testing.T,
	stmt: Statement,
	ident_name: string,
	loc := #caller_location,
) {

	testing.expect_value(t, stmt_token_literal(stmt), "let", loc)
	if let_stmt, let_stmt_ok := stmt.(LetStmt); let_stmt_ok {
		testing.expect_value(t, let_stmt.identifier.value, ident_name, loc)
		testing.expect_value(t, let_stmt.identifier.token.literal, ident_name, loc)
	} else {
		testing.expectf(t, false, "expected a LetStmt but got %T", stmt)
	}
}

