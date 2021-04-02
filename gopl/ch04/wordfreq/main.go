// Exercise 4.9: Write a program wordfreq to report the frequency of
// each word in an input text file. Call input.Split(bufio.ScanWords)
// before the first call to Scan to break the input into words instead
// of lines.

package main

import (
	"bufio"
	"fmt"
	"os"
)

func main() {
	file, err := os.Open("words.txt")

	if err != nil {
		fmt.Fprintf(os.Stderr, "%v\n", err)
		return
	}
	
	input := bufio.NewScanner(file)
	input.Split(bufio.ScanWords)
	words := make(map[string]int)

	for input.Scan() {
		words[input.Text()]++
	}
	if err := input.Err(); err != nil {
		fmt.Fprintf(os.Stderr, "%v\n", err)
	}
	fmt.Printf("word\tcount\n")
	for word, count := range words {
		fmt.Printf("%v\t%d\n", word, count)
	}
}

