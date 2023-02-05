// Check Permutation: Given two strings, write a method to decide if one is a
// permutation of the other.

package main

import "sort"

func main() {
}

func CheckPermutation(s1, s2 string) bool {
	if len(s1) != len(s2) {
		return false
	}

	r1, r2 := []rune(s1), []rune(s2)

	sort.Slice(r1, func(i, j int) bool {
		return r1[i] < r1[j]
	})

	sort.Slice(r2, func(i, j int) bool {
		return r2[i] < r2[j]
	})

	for i := 0; i < len(r1); i++ {
		if r1[i] != r2[i] {
			return false
		}
	}

	return true
}
