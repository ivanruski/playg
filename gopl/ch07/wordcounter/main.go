// Exercise 7.1: Using the ideas from ByteCounter, implement counters
// for words and for lines. You will find bufio.ScanWords useful.

package main

import (
	"bufio"
	"bytes"
	"fmt"
)

type WordCounter struct {
	counter int
}

func (wc *WordCounter) Write(p []byte) (int, error) {
	scanner := bufio.NewScanner(bytes.NewReader(p))
	scanner.Split(bufio.ScanWords)

	for scanner.Scan() {
		wc.counter++
	}

	return len(p), nil
}

func main() {
	wc := WordCounter{}
	fmt.Fprintf(&wc, "hello motto, how are you doing?")
	fmt.Println(wc)
}
