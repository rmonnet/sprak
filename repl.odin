// This file contains the REPL for Monkey.
package sprak

import "core:bufio"
import "core:fmt"
import "core:io"
import "core:os"
import "core:strings"

PROMPT :: ">> "

// `repl_run` starts the REPL (Read, Eval, Print Loop).
// It takes explicit input and output stream to allow use during testing.
// TODO: We should add an error stream.
repl_run :: proc(stdin: ^os.File, stdout: ^os.File) {

	buf_reader: bufio.Reader
	bufio.reader_init(&buf_reader, os.to_stream(stdin))
	defer bufio.reader_destroy(&buf_reader)

	for {

		fmt.fprint(stdout, PROMPT)
		line, err := bufio.reader_read_string(&buf_reader, '\n')
		defer delete(line)
		if err == io.Error.EOF {return}
		if err != io.Error.None {
			fmt.fprintf(stdout, "Error reading input: %s\n", err)
			return
		}

		source := strings.trim_right(line, "\r\n")
		lexer := lexer_create(source)
		defer lexer_destroy(lexer)

		for token := next_token(lexer); token.type != .End_Of_File; token = next_token(lexer) {
			fmt.fprintf(stdout, "%v\n", token)
		}

	}
}

