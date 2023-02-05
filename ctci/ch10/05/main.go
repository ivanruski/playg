// Sparse Search: given a sorted array of strings that is interspersed
// with empty strings, write a method to find the location of a given
// string.

package main

import "fmt"

func main() {
	strs := []string{"at", "", "", "", "ball", "", "", "car", "", "", "dad", "", ""}
	s := "dad"

	fmt.Println(search(strs, s))
}

func search(strs []string, s string) int {
	return binsearch(strs, s, 0, len(strs)-1)
}

func binsearch(strs []string, s string, l, r int) int {
	if l > r {
		return -1
	}

	m := (l + r) / 2

	// Go in left and right directions to find non-empty words
	// This approach has a drawback. If we have really long array and
	// the closest element is m+1 and everything less than m is "",
	// this version will go left till the end.
	var w string
	var i int
	for i = m; i >= 0; i-- {
		if strs[i] != "" {
			w = strs[i]
			break
		}
	}

	if s == w {
		return i
	}

	if s < w {
		return binsearch(strs, s, l, i-1)
	}

	for i = m; i < len(strs); i++ {
		if strs[i] != "" {
			w = strs[i]
			break
		}
	}

	if s == w {
		return i
	}

	// s is larger than the left word and smaller than the right
	if s < w {
		return -1
	}

	return binsearch(strs, s, i+1, r)
}
