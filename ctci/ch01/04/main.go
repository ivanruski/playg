// Palindrome Permutation: Given a string, write a function to check if it is
// a permutation of a palindrome. A palindrome is a word or phrase that is the
// same forwards and backwards. A permutation is a rearrangement of letters.
// The palindrome does not need to be limited to just dictionary words. You can
// ignore casing and non-letter characters.
//
// Example
//
// Input: Tact Coa
// Output: True (permutations: "taco cat", "atco cta", etc.)

package main

import "unicode"

func main() {

}

func PalindromePermutation(s string) bool {
	runeCnt := map[rune]int{}
	letterCnt := 0
	for _, r := range s {
		if unicode.IsLetter(r) {
			letterCnt++
			runeCnt[unicode.ToLower(r)]++
		}
	}

	oddCntAllowed := 1
	if letterCnt == 0 {
		oddCntAllowed = 0
	}

	for _, cnt := range runeCnt {
		if cnt%2 == 0 {
			continue
		}
		if oddCntAllowed == 0 {
			return false
		}
		oddCntAllowed--
	}

	return len(s) > 0
}
