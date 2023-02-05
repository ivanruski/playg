// URLify: Write a method to replace all spaces in a string with '%20'.
// You may assume that the string has sufficient space at the end to hold
// the additional characters, and that you are given the "true" length of
// the string.
//
// Example:
//
// Input:  "Mr John Smith    " len=13
// Output: "Mr%20John%20Smith"

package main

import "math"

func main() {
}

func URLify(s []rune, slen int) string {
	const space = ' '
	var spacesToReplace int
	for i := 0; i < slen; i++ {
		if s[i] == space {
			spacesToReplace++
		}
	}

	for i := 0; i < len(s) && spacesToReplace > 0; {
		if s[i] == space {
			spacesToReplace--
			s[i] = '%'
			insertSlice(s, []rune("20"), i+1)
			i += 2
		}
		i++
	}

	return string(s)
}

// insertSlice will insert a given slice into another at specified index.
// The last todo: finish the comment
func insertSlice(r, insert []rune, atIndex int) {
	if atIndex >= len(r) {
		return
	}

	lenr := len(r)
	buf := make([]rune, len(insert))
	to := minInt(atIndex+len(insert), lenr)
	copy(buf, r[atIndex:to])

	for i := 0; i < len(insert); i++ {
		if atIndex+i >= lenr {
			break
		}
		r[atIndex+i] = insert[i]
	}

	insertSlice(r, buf, to)
}

func minInt(a, b int) int {
	af := float64(a)
	bf := float64(b)
	min := math.Min(af, bf)
	return int(min)
}
