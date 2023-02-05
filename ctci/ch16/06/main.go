// Smallest Difference: Given two arrays of integers, compute the pair of values
// (one value in each array) with the smallest (non-negative) difference. Return
// the difference.

package main

import (
	"fmt"
	"sort"
)

func main() {
	xs := []int{1, 4, 18, 32, 40}
	ys := []int{8, 12, 13, 50, 60}

	fmt.Println(smallestDiff(xs, ys))
}

func smallestDiff(xs, ys []int) int {
	sort.Ints(xs)
	sort.Ints(ys)

	xi := len(xs) - 1
	yi := len(ys) - 1

	var sd, d int = 1 << 62, 0
	for xi >= 0 && yi >= 0 {
		x := xs[xi]
		y := ys[yi]

		if x == y {
			return 0
		}
		if x > y {
			d = x - y
			xi--
		} else {
			d = y - x
			yi--
		}

		if sd > d {
			sd = d
		}
	}

	return sd
}
