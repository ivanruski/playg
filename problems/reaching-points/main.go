package main

import "fmt"

// https://leetcode.com/problems/reaching-points
func main() {
	fmt.Println(reachingPoints(35, 13, 455955547, 420098884))
	fmt.Println(reachingPoints(1, 1, 1_000_000_000, 1))
	fmt.Println(reachingPoints(1, 1, 2, 2))
	fmt.Println(reachingPoints(1, 15, 999999991, 15))
	fmt.Println(reachingPoints(4, 4, 3, 19))
}

// The solution is slow and it does not pass all test cases.
func reachingPoints(sx, sy, tx, ty int) bool {
	for tx >= sx && ty >= sy {
		if tx == sx && ty == sy {
			return true
		}

		if tx > ty {
			tx = tx - ty
		} else {
			ty = ty - tx
		}
	}

	return false
}
