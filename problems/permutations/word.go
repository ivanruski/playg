// Generate all permutations for a given string

package main

import "fmt"

func main() {
	w := "ivan"
	arr := permutation("", w)
	fmt.Println(len(arr))
}

func permutation(word, chars string) []string {
	if len(chars) == 0 {
		return []string{word}
	}

	words := []string{}
	for i := 0; i < len(chars); i++ {
		w := word + chars[i:i+1]
		ch := chars[:i] + chars[i+1:]
		p := permutation(w, ch)
		words = append(words, p...)
	}

	return words
}
