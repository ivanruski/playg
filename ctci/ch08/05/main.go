// Recursive Multiply: Write a recursive function to multiply two
// positive integers without using the * operator. You can use
// addition, substraction, and bit shifting, but you should minimize
// the number of those operations.

package main

func main() {
}

func multiply(a, b int) int {
	if b == 1 {
		return a
	}

	if b%2 == 0 {
		return multiply(a<<1, b>>1)
	} else {
		return a + multiply(a, b-1)
	}
}
