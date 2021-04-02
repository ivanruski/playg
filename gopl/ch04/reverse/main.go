// Exercise 4.3: Rewrite reverse to use an array pointer instead of
// slice.

package main

import (
	"fmt"
)

func main() {
	arr := [3]int{1, 2, 3}
	reverse(&arr)
	fmt.Println(arr)
}

func reverse(parr *[3]int) {
	for i, j := 0, len(*parr)-1; i < j; i, j = i+1, j-1 {
		(*parr)[i], (*parr)[j] = (*parr)[j], (*parr)[i]
	}
}
