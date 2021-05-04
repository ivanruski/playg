// Exercise 7.10: The sort.Interface type can be adapted to other
// uses. Write a function IsPalindrome(s sort.Interface) bool that
// reports whether the sequence s is a palindrome, in other words,
// reversing the sequence would not change it. Assume that the
// elements at indices i and j are equal if !s.Less(i, j) &&
// !s.Less(j, i).

package main

import (
	"fmt"
	"os"
	"sort"
	"strings"
)

func IsPalindrome(data sort.Interface) bool {
	for i, j := 0, data.Len()-1; i < j; i, j = i+1, j-1 {
		if !data.Less(i, j) && !data.Less(j, i) {
			continue
		}

		return false
	}

	return true
}

type StringSliceSorter []string

func (ss StringSliceSorter) String() string {
	return strings.Join(ss, "")
}

func (ss StringSliceSorter) Len() int {
	return len(ss)
}

func (ss StringSliceSorter) Less(i, j int) bool {
	return ss[i] < ss[j]
}

func (ss StringSliceSorter) Swap(i, j int) {
	ss[i], ss[j] = ss[j], ss[i]
}

func main() {
	ss := StringSliceSorter(os.Args[1:])

	fmt.Println(ss, IsPalindrome(ss))
}
