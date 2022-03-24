// String Compression: Implement a method to perform basic string compression
// using the counts of repeated characters. For example, the string aabcccccaaa
// would become a2b1c5a3. If the "compressed" string would not become smaller
// than the original string, your method should return the original string.
// You can assume the string has only uppercase and lowercase letters (a-z).

package main

import (
	"strconv"
	"strings"
)

func main() {
}

func StringCompression(s string) string {
	b := strings.Builder{}
	for i := 0; i < len(s); {
		cnt := nextConsecutiveChars(s, i)
		b.WriteByte(s[i])
		b.WriteString(strconv.Itoa(cnt))

		i += cnt
	}

	result := b.String()
	// we could check in the for loop as well
	// if we have 1 000 000 alternating chars (abcabc) we'll exit earlier
	if len(result) >= len(s) {
		return s
	}
	return result
}

func nextConsecutiveChars(s string, from int) int {
	cnt := 1
	// works because we have only ascii
	prev := s[from]
	for i := from + 1; i < len(s); i++ {
		if s[i] != prev {
			break
		}
		cnt++
	}

	return cnt
}
