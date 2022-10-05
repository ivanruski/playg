// Number Swapper: Write a function to swap two numbers in place (that is
// without temporary variables).

package main

func main() {
}

func swapNums(a, b *int) {
	// a, b = b, a
	*a = *a ^ *b
	*b = *a ^ *b
	*a = *a ^ *b
}
