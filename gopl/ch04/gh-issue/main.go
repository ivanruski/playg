// Exercise 4.11: Build a tool that lets users create, read, update,
// and close GitHub issues from the command line, invoking their
// preferred text editor when substantial text input is required.

package main

import (
	"ivanruski/gopl/ch04/gh-issue/cmd"
)

func main() {
	cmd.Execute()
}
