// This file contains the REPL for Monkey.
package sprak

import "core:bufio"
import "core:fmt"
import "core:io"
import "core:os"
import "core:strings"

PROMPT :: ">> "

repl_start :: proc(input: ^os.File, output: ^os.File) {

	buf_reader: bufio.Reader
	bufio.reader_init(&buf_reader, os.to_stream(input))
	defer bufio.reader_destroy(&buf_reader)

	for {

		fmt.fprint(output, PROMPT)
		line, err := bufio.reader_read_string(&buf_reader, '\n')
		defer delete(line)
		if err == io.Error.EOF {return}
		if err != io.Error.None {
			fmt.fprintf(output, "Error reading input: %s\n", err)
			return
		}

		source := strings.trim_right(line, "\r\n")
		lexer := lexer_create(source)
		defer lexer_destroy(lexer)

		for token := next_token(lexer); token.type != .End_Of_File; token = next_token(lexer) {
			fmt.fprintf(output, "%v\n", token)
		}

	}
}
