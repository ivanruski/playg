// Exercise 4.5: Write an in-place function to eliminate adjacent
// duplicates in a []string slice

package main

import (
	"fmt"
)

func main() {
	s := []string{"1", "1"}
	fmt.Println(dedup(s))
}

func dedup(s []string) []string {
	var i, j int = 1, 0

	for ; i < len(s); i++ {
		if s[i-1] != s[i] {
			s[j+1] = s[i]
			j++
		}
	}

	return s[:j+1]
}
