package main

import (
	"bytes"
	"fmt"
	"os"
	"strings"
)

func main() {
	for i := 1; i < len(os.Args); i++ {
		fmt.Printf("  %s\n", commaRecursive(os.Args[i]))
		fmt.Printf("  %s\n", commaDecimalsAndSigns(os.Args[i]))
	}
}

// Exercise 3.10: Write a non-recursive version of comma, using bytes.Buffer
// instead of string concatenation.
func commaBuf(s string) string {
	slen := len(s)
	if slen < 4 {
		return s
	}

	// create new buffer with the expected new size
	buf := bytes.NewBuffer([]byte{})
	for i := 0; i < slen; i++ {
		buf.WriteByte(s[i])

		if (slen-i-1)%3 == 0 && i+1 < slen {
			buf.WriteRune(',')
		}
	}

	return buf.String()
}

// 1.456

// Exercise 3.11: Enhance comma so that it deals correctly with floating-point
// numbers and an optional sign.
func commaDecimalsAndSigns(s string) string {
	decimailPointIdx := strings.IndexRune(s, '.')
	isNegative := strings.HasPrefix(s, "-")
	wholePartLen := len(s)
	if decimailPointIdx != -1 {
		wholePartLen = decimailPointIdx
	}

	buf := bytes.NewBuffer([]byte{})
	i := 0
	if isNegative {
		buf.WriteRune('-')
		i = 1
	}

	for ; i < wholePartLen; i++ {
		buf.WriteByte(s[i])

		currPlace := wholePartLen - i - 1
		if currPlace%3 == 0 && i+1 < wholePartLen {
			buf.WriteRune(',')
		}
	}

	if decimailPointIdx != -1 {
		buf.WriteString(s[decimailPointIdx:])
	}

	return buf.String()
}

func commaRecursive(s string) string {
	n := len(s)
	if n <= 3 {
		return s
	}
	return commaRecursive(s[:n-3]) + "," + s[n-3:]
}
