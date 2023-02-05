// Is Unique: Implement an algorithm to determine if a string has all unique
// characters. What if you cannot use additional data structures ?

package main

import (
	"sort"
)

func main() {
}

func IsUnique(s string) bool {
	chars := make([]rune, 0, len(s))
	for _, r := range s {
		chars = append(chars, r)
	}

	sort.Slice(chars, func(i, j int) bool {
		return chars[i] < chars[j]
	})

	for i := 1; i < len(chars); i++ {
		if chars[i-1] == chars[i] {
			return false
		}
	}

	return len(s) > 0
}
