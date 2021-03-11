// Exercise 3.12: Write a function that reports whether two strings are anagrams
// of each other, that is, they contain the same letters in a different order.

package main

import (
	"fmt"
	"os"
)

func main() {
	fmt.Println(isAnagram(os.Args[1], os.Args[2]))
}

func isAnagram(a, b string) bool {
	if len(a) != len(b) {
		return false
	}

	am := make(map[rune]int)
	bm := make(map[rune]int)

	for _, r := range a {
		am[r]++
	}
	for _, r := range b {
		bm[r]++
	}

	for r, cnt := range am {
		if cnt != bm[r] {
			return false
		}
	}

	return true
}
