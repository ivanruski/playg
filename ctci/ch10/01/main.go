// Sorted Merge: You are given two sorted arrays, A and B, where A has
// a large enough buffer at the end to hold B. Write a method to merge
// B into A in sorted order.

package main

import "fmt"

func main() {
	a := []int{1, 3, 5, 7, 9, 0, 0, 0, 0}
	a = a[:5]
	b := []int{2, 4, 6, 8}

	c := sortedMerge(a, b)
	fmt.Println(c)
}

func sortedMerge(a, b []int) []int {
	c := a[:len(a)+len(b)]

	ai := len(a) - 1
	bi := len(b) - 1
	ci := len(c) - 1
	for bi >= 0 {
		if ai < 0 {
			c[ci] = b[bi]
			ci--
			bi--
			continue
		}

		if a[ai] < b[bi] {
			c[ci] = b[bi]
			bi--
		} else {
			c[ci] = a[ai]
			ai--
		}
		ci--
	}

	return c
}
