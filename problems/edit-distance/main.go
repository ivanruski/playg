// Given two strings word1 and word2, return the minimum number of operations
// required to convert word1 to word2.
//
// You have the following three operations permitted on a word:
//
// - Insert a character
// - Delete a character
// - Replace a character
//
// Example 1:
//
// Input: word1 = "horse", word2 = "ros"
// Output: 3
// Explanation:
// horse -> rorse (replace 'h' with 'r')
// rorse -> rose (remove 'r')
// rose -> ros (remove 'e')
//
// Example 2:
//
// Input: word1 = "intention", word2 = "execution"
// Output: 5
// Explanation:
// intention -> inention (remove 't')
// inention -> enention (replace 'i' with 'e')
// enention -> exention (replace 'n' with 'x')
// exention -> exection (replace 'n' with 'c')
// exection -> execution (insert 'u')
//
// Constraints:
//
// - 0 <= word1.length, word2.length <= 500
// - word1 and word2 consist of lowercase English letters.
//
// https://leetcode.com/problems/edit-distance/

package main

import (
	"fmt"
	"math"
)

func main() {
	fmt.Println(EditDistance([]rune("zoologicoarchaeologist"), []rune("zoogeologist")))
	fmt.Println(EditDistanceDP([]rune("zoologicoarchaeologist"), []rune("zoogeologist")))
}
func EditDistanceDP(word1, word2 []rune) int {
	mem := make([][]int, len(word1)+1, len(word1)+1)
	rows := len(mem)
	cols := len(word2) + 1
	for i := 0; i < rows; i++ {
		mem[i] = make([]int, cols, cols)
	}
	for i := 0; i < rows; i++ {
		mem[i][0] = i
	}
	for j := 0; j < cols; j++ {
		mem[0][j] = j
	}

	for i := 1; i < rows; i++ {
		for j := 1; j < cols; j++ {
			r := mem[i-1][j-1]
			d := mem[i-1][j]
			a := mem[i][j-1]
			min := minInt(r, a, d) + 1
			if word1[i-1] == word2[j-1] {
				min = r
			}

			mem[i][j] = min
		}
	}

	printArr(mem, word1, word2)
	return mem[rows-1][cols-1]
}

func printArr(arr [][]int, word1, word2 []rune) {
	fmt.Print("      ")
	for i := 0; i < len(word2); i++ {
		fmt.Printf("%2c ", word2[i])
	}
	fmt.Printf("\n")

	for i := 0; i < len(arr); i++ {
		if i > 0 {
			fmt.Printf("%2c ", word1[i-1])
		} else {
			fmt.Print("   ")
		}

		for j := 0; j < len(arr[i]); j++ {
			fmt.Printf("%2d ", arr[i][j])
		}
		fmt.Printf("\n")
	}
}

func EditDistance(word1, word2 []rune) int {
	if len(word1) == 0 {
		return len(word2)
	}
	if len(word2) == 0 {
		return len(word1)
	}

	i := len(word1) - 1
	j := len(word2) - 1
	if word1[i] == word2[j] {
		return EditDistance(word1[:i], word2[:j])
	}

	// add
	add := 1 + EditDistance(word1, word2[:j])
	// replace
	rep := 1 + EditDistance(word1[:i], word2[:j])
	// remove
	del := 1 + EditDistance(word1[:i], word2)

	return minInt(add, rep, del)
}

func minInt(nums ...int) int {
	min := math.MaxInt
	for _, n := range nums {
		if min > n {
			min = n
		}
	}

	return min
}
