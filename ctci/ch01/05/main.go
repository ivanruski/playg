// One Away: There are three types of edits that can be performed on strings:
// insert a character, remove a character, or replace a character. Given two
// strings, write a function to check if they are one dit (or zero edits) away.

package main

import (
	"fmt"
	"math"
)

func main() {
	fmt.Println(OneAway("ab", "acb"))
}

// Assuming only ascii
func OneAway(one, two string) bool {
	if diffsLen(one, two) > 1 {
		return false
	}

	rone := []rune(one)
	rtwo := []rune(two)
	if len(rone) == len(rtwo) {

		edits := 1
		for i, r := range rone {
			if r != rtwo[i] {
				edits--
			}
		}

		return edits >= 0
	}

	shorter, longer := findShorter(rone, rtwo)
	edits := 1
	for i, j := 0, 0; i < len(shorter); {
		s := shorter[i]
		l := longer[j]
		if s != l {
			if edits == 0 {
				return false
			}
			j++ // remove a char from the longer string
			edits--
			continue
		}
		i++
		j++
	}

	return edits >= 0
}

func findShorter(rone, rtwo []rune) ([]rune, []rune) {
	if len(rone) > len(rtwo) {
		return rtwo, rone
	}
	return rone, rtwo
}

func diffsLen(one, two string) int {
	rone := []rune(one)
	rtwo := []rune(two)
	diff := len(rone) - len(rtwo)
	abs := math.Abs(float64(diff))

	return int(abs)
}
