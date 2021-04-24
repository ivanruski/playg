// Exercise 7.2: Write a function CountingWriter with the signature
// below that, given an io.Writer, returns a new Writer that wraps the
// original, and a pointer to an int64 variable that at any moment
// contains the number of bytes written to the new Writer.
// func CountingWriter(w io.Writer) (io.Writer, *int64)
package main

import (
	"fmt"
	"io"
	"os"
)

type countingWriter struct {
	counter       int64
	clientCounter int64
	writer        io.Writer
}

func (cw *countingWriter) Write(p []byte) (int, error) {
	n, err := cw.writer.Write(p)
	if err != nil {
		return 0, err
	}

	cw.counter += int64(n)
	cw.clientCounter = cw.counter
	return n, nil
}

func CountingWriter(w io.Writer) (io.Writer, *int64) {
	cw := &countingWriter{writer: w}

	return cw, &cw.clientCounter
}

func main() {
	w, counter := CountingWriter(os.Stdout)
	fmt.Fprintf(w, "Hello world\n")
	fmt.Println(*counter)
	fmt.Fprintf(w, "Hello world\n")
	fmt.Println(*counter)
}
