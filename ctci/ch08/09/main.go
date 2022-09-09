// Parens: Implement an algorithm to print all valid (e.g., properly
// opened and closed) combinations of n pairs of parentheses.
//
// EXAMPLE:
// Input: 3
// Output: ((())), (()()), (())(), ()(()), ()()()

// leetcode: https://leetcode.com/problems/generate-parentheses/

package main

import (
	"fmt"
)

func main() {
	parens := generateParenthesis(4)
	for i := 0; i < len(parens); i++ {
		fmt.Println(parens[i])
	}
}

func generateParenthesis(n int) []string {
	result := []string{}
	prefix := make([]rune, 0, 2*n)
	genParens(n, n, prefix, &result)

	return result
}

func genParens(opened, closed int, prefix []rune, result *[]string) {
	if opened > closed {
		return
	}

	if opened == 0 && closed == 0 {
		*result = append(*result, string(prefix))
		return
	}

	if opened > 0 {
		genParens(opened-1, closed, append(prefix, '('), result)
	}

	if closed > 0 {
		genParens(opened, closed-1, append(prefix, ')'), result)
	}
}
