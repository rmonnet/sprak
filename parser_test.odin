// This file contains the tests for the Monkey parser.
package sprak

import "core:testing"

@(test)
test_let_statement :: proc(t: ^testing.T) {

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
	check_parser_errors(t, parser)

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
		testing.expect_value(t, stmt_token_literal(stmt), "let")
		if let_stmt, let_stmt_ok := stmt.(Let_Stmt); let_stmt_ok {
			testing.expect_value(t, let_stmt.identifier.value, name)
			testing.expect_value(t, let_stmt.identifier.token.literal, name)
		} else {
			testing.expectf(t, false, "expected a LetStmt but got %T", stmt)
		}
	}
}

@(test)
test_return_statement :: proc(t: ^testing.T) {

	input := `
return 5;
return 10;
return 993322;
`

	lexer := lexer_create(input)
	parser := parser_create(lexer)
	defer parser_destroy(parser)

	program := parse_program(parser)
	defer program_destroy(program)
	check_parser_errors(t, parser)

	if program == nil {
		testing.expect(t, false, "parse_program() returned nil")
		return
	}
	if len(program.stmts) != 3 {
		testing.expectf(t, false, "len(program.stmts): expected 3, got %d", len(program.stmts))
		return
	}

	for stmt in program.stmts {

		testing.expect_value(t, stmt_token_literal(stmt), "return")
		// TODO: uncommment once we get expression parser in.
		if _, return_stmt_ok := stmt.(Return_Stmt); return_stmt_ok {
			// testing.expect_value(t, return_stmt.identifier.value, ident_name)
		} else {
			testing.expectf(t, false, "expected a ReturnStmt but got %T", stmt)
		}
	}


}

// -------------------------------
// Utilities
// -------------------------------

check_parser_errors :: proc(t: ^testing.T, p: ^Parser, loc := #caller_location) {

	if len(p.errors) == 0 {return}
	testing.expectf(t, false, "parser has %d errors", len(p.errors), loc = loc)
	for error in p.errors {
		testing.expectf(t, false, "parser error: %s", error, loc = loc)
	}
}

