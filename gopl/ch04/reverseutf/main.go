// Exercise 4.7: Modify reverse func to reverse the characters of a
// []byte slice that represents UTF-8-encoded string, in place. Can
// you do it without allocating new memory?

package main

import (
	"fmt"
	"unicode/utf8"
)

func main() {
	s := []byte("界 v 世 界 世 j") // "界 v 世 界 世 界 j"
	fmt.Println(string(s))
	reverse(s)
	fmt.Printf("%v\n", string(s))
}

// In place swaping of runes. Very ugly.
func reverse(s []byte) {
	var runei, runej int
	var lr, rr rune
	for i, j := 0, len(s); i < j; {
		lr, runei = utf8.DecodeRune(s[i:])
		rr, runej = utf8.DecodeLastRune(s[:j])

		if runei < runej {
			rStart := j - runej + (runej - runei)
			for k := 0; k < runei; k++ {
				s[rStart] = s[i + k]
				rStart++
			}

			rStart = j - runej + (runej - runei) - 1
			shiftStart := j - runej - 1
			for k := rStart; k >= i + runej; k-- {
				s[k] = s[shiftStart]
				shiftStart--
			}

			rlBytes := make([]byte, runej)
			// err check missing
			utf8.EncodeRune(rlBytes, rr)
			for k := 0; k < runej; k++ {
				s[i + k] = rlBytes[k]
			}

			i += runej
			j -= runei

		} else if runei > runej {
			for k := 0; k < runej; k++ {
				s[i + k] = s[j - runej + k]
			}
			for k := i + runej; k < j - runej - 1; k++ {
				s[k] = s[k + runei - 1]
			}

			lrBytes := make([]byte, runei)
			// err check missing
			utf8.EncodeRune(lrBytes, lr)
			for k := 0; k < runei; k++ {
				s[j - runei + k] = lrBytes[k]
			}

			i += runej
			j -= runei
		} else {
			lrBytes := make([]byte, runei)
			// err check missing
			utf8.EncodeRune(lrBytes, lr)

			for k := 0; k < runei; k++ {
				s[i+k] = s[j-runej+k]
			}
			for k := 0; k < runei; k++ {
				s[j-runej+k] = lrBytes[k]
			}

			i+= runei
			j-= runej
		}
	}
}

// Reverse using additional memory
func reverse1(s []byte) {
	rev := make([]byte, len(s))
	revi := 0

	for i := len(s); i > 0; {
		_, rs := utf8.DecodeLastRune(s[:i])
		for j := 0; j < rs; j++ {
			rev[revi] = s[i-rs+j]
			revi++
		}

		i -= rs
	}

	for i := 0; i < len(s); i++ {
		s[i] = rev[i]
	}
}
