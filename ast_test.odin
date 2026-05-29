package sprak

import "core:testing"

@(test)
test_prog_to_string :: proc(t: ^testing.T) {

	program := program_create()
	defer program_destroy(program)
	stmts := []Statement {
		Let_Stmt {
			token = Token{.Let, "let"},
			identifier = Ident_Expr{token = Token{.Ident, "myVar"}, value = "myVar"},
			value = Ident_Expr{token = Token{.Ident, "anotherVar"}, value = "anotherVar"},
		},
	}
	append(&program.stmts, ..stmts)

	actual := prog_to_string(program^)
	defer delete(actual)
	expected := "let myVar = anotherVar;"
	testing.expect_value(t, actual, expected)

}

