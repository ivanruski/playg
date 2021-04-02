// Exercise 4.4: Write a version of rotate that operates in a signle
// pass.

package main

import (
	"fmt"
)

func main() {
	s := []int{1,2,3,4,5,6}
	rs := rotate(s, 11)

	fmt.Println(rs)
}

// rotate left by i positions
func rotate(s []int, i int) []int {
	if cap(s) < i {
		i = i % cap(s)
	}

	s = append(s, s[:i]...)
	s = s[i:]

	return s
}
