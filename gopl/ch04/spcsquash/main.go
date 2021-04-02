// Exercise 4.6: Write an in-place function that squashes each run of
// adjacent Unicode spaces (see unicode.IsSpace) in a UTF-8-encoded
// []byte slice into a single ASCII space

package main

import (
	"fmt"
	"unicode"
	"unicode/utf8"
)

func main() {
	b := []byte("     v世 世 世    界  j           z")
	sb := spcsquash(b)
	fmt.Printf("%v\n%v\n", string(sb), sb)
}

// ivan xxx sexa
func spcsquash(s []byte) []byte {
	var r rune
	var spccnt, ri, rSize = 0, 0, 1

	for i := 0; i < len(s); i+=rSize {
		// TODO: error check
		r, rSize = utf8.DecodeRune(s[i:])
		
		if unicode.IsSpace(r) {
			spccnt++
			continue
		}

		if spccnt != 0 {
			s[ri] = byte(' ')
			ri++
			spccnt = 0
		}

		for j := 0; j < rSize; j++ {
			s[ri] = s[i+j]
			ri++
		}
	}

	return s[:ri]
}
