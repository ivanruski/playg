// Word Frequencies:  Design a method to find the frequency of occurrences of
// any given word in a book. What if we were running this algorithm multiple
// times.
//
// NOTE
// After checking with the solution I've realized that I didn't understand the
// problem correctly(I thought I need to keep track of word frequencies per
// book).
// Anyway the problem seems straighforward and easy and this is the hidden
// takeaway. In problems like this the interviewer looks at how careful you
// are.

package main

import (
	"fmt"
	"strings"
)

func main() {
	text := "Add additional file to the F1 report. The purpose of this file is to present the average precision, recall and F1 score of all articles included in the report."
	wordsCnt := countWordFrequencies("tmp", text)
	for word, cnt := range wordsCnt {
		fmt.Println(word, cnt)
	}
}

var (
	booksWordsCnt = map[string]map[string]int{}
)

func countWordFrequencies(bookName string, text string) map[string]int {
	wordsCnt, ok := booksWordsCnt[bookName]
	if ok {
		return wordsCnt
	}

	wordsCnt = map[string]int{}
	words := strings.Split(text, " ")
	for _, w := range words {
		// TODO: word should be cleaned from [. , ]
		wordsCnt[w]++
	}

	booksWordsCnt[bookName] = wordsCnt
	return wordsCnt
}
