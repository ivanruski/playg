// Number Max: Write a method that finds the maximum of two numbers. You should
// not use if-else or any other comparison operator.
//
// NOTE: I used help from the book

package main

import (
	"fmt"
	"math"
)

func main() {
	a := -math.MaxInt + 2
	b := 10

	fmt.Println(a, b, numberMax(a, b))
}

func numberMax(a, b int) int {
	sa := sign(a) ^ 1
	sb := sign(b) ^ 1
	sd := sign(a-b) ^ 1

	q := sa ^ sb
	k := (sa * q) + (sd * (q ^ 1))

	return (a * k) + (b * (k ^ 1))
}

func sign(n int) int {
	un := uint64(n)
	signBit := un >> 63

	return int(signBit)
}
