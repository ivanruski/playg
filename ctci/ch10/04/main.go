// Sorted Search, No Size: You are given an array-like data structure
// Listy which lacks a size method. It does, however, have an
// elementAt(i) method that returns the element at index i in O(1)
// time. If i is beyond the bounds of the data structure, it returns
// -1. (For this reason, the data structure only supports postivie
// integers) Given a Listy which contains sorted, positive integers,
// find the index at which an element x occurs. If x occurs multiple
// times, you may return any index.

package main

import "fmt"

type listy []int

func (l listy) elementAt(i int) int {
	if i >= len(l) {
		return -1
	}

	return l[i]
}

func main() {
	arr := make([]int, 1000)
	for i := 0; i < len(arr); i++ {
		if i > 700 {
			arr[i] = 1000
			continue
		}
		arr[i] = i + 1

	}
	fmt.Println(search(arr, 1000))
}

func search(a listy, x int) int {
	obi := findOutOfBoundIndex(a)
	r := findRightBound(a, 0, obi, x)
	if r == -1 {
		return -1
	}

	return binarySearch(a, 0, r, x)
}

func binarySearch(a listy, l, r, x int) int {
	if l > r {
		return -1
	}

	m := (l + r) / 2
	if a[m] == x {
		return m
	}
	if x < a[m] {
		return binarySearch(a, l, m-1, x)
	}
	return binarySearch(a, m+1, r, x)
}

func findRightBound(a listy, l, r, x int) int {
	if l > r {
		return -1
	}

	m := (l + r) / 2

	if a.elementAt(m) == -1 {
		return findRightBound(a, l, m-1, x)
	}

	if x <= a.elementAt(m) {
		return m
	}

	return findRightBound(a, m+1, r, x)
}

func findOutOfBoundIndex(a listy) int {
	for i := 2; ; i *= 2 {
		if a.elementAt(i) == -1 {
			return i
		}
	}
}
