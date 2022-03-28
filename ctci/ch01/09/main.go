// String Rotation: Assume you have a method `isSubstring` which checks if one
// word is substring of another. Given two strings, s1 and s2, write code to
// check if s2 is a rotation of s1 using only one call to isSubstring.
//
// Example
// s1: waterbottle, s2: erbottlewat

package main

import (
	"fmt"
	"strings"
)

func main() {
	s1 := "hellomynameis"
	s2 := "nameishellomy"

	fmt.Println(StringRotation(s1, s2))
}

// This is not the solution they've wanted.
// The real solution is far more clever.
func StringRotation(s1, s2 string) bool {
	if len(s1) != len(s2) {
		return false
	}

	r1, r2 := []rune(s1), []rune(s2)
	for i := 0; i < len(r2); i++ {
		subword := r2[i:]
		if isStartOfWord(r1, subword) {
			startOfs2 := string(r2[:i])
			return strings.HasSuffix(s1, startOfs2)
		}
	}

	return false
}

func isStartOfWord(word, subword []rune) bool {
	var i int
	for i = 0; i < len(subword); i++ {
		if subword[i] != word[i] {
			break
		}
	}

	return i == len(subword)
}
