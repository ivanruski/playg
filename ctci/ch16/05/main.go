// Factorial Zeros: Write an algorithm which computes the number of trailing
// zeros in n factorial.
//
// https://leetcode.com/problems/factorial-trailing-zeroes/

package main

import (
	"fmt"
	"math/big"
)

func main() {
	for i := 1; i < 41; i++ {
		f := fact(i)
		fmt.Printf("%d = %d (%d)\n", i, f, trailingZeroes(i))
	}
}

func trailingZeroesSlow(n int) int {
	return countTrailingZeroes(fact(n))
}

// This is slow, because it calculates the factorial and counts the zeroes
func countTrailingZeroes(n *big.Int) int {
	str := n.String()
	cnt := 0
	asciiZero := byte(48)
	for i := len(str) - 1; i >= 0; i-- {
		if str[i] == asciiZero {
			cnt++
		} else {
			break
		}
	}

	return cnt
}

func fact(n int) *big.Int {
	prod := big.NewInt(1)

	for i := 1; i <= n; i++ {
		prod.Mul(prod, big.NewInt(int64(i)))
	}

	return prod
}

// After looking at the book's solutions, I wrote this
func trailingZeroes(n int) int {
	var cnt int
	for i := 1; i <= n; i++ {
		num := i
		for num%5 == 0 {
			cnt++
			num /= 5
		}
	}
	return cnt
}
