// Permutations with Dups: Write a method to compute all permutations
// of a string whose characters are not necessarily unique. The list
// of permutations should not have duplicates.
//
// https://leetcode.com/problems/permutations-ii/

package main

import (
	"fmt"
)

func main() {
	arr := []int{1, 1, 1, 1, 1, 1}
	sp := permuteUnique(arr)
	for i := 0; i < len(sp); i++ {
		fmt.Printf("%+v\n", sp[i])
	}
}

func permuteUnique(nums []int) [][]int {
	numsCnt := map[int]int{}
	for _, n := range nums {
		numsCnt[n]++
	}

	return permute(numsCnt)
}

func permute(nums map[int]int) [][]int {
	if areValuesZero(nums) {
		return [][]int{
			{},
		}
	}

	// create slice with v times k
	if nonZeroKeysCnt(nums) == 1 {
		for k, v := range nums {
			if v > 0 {
				s := make([]int, v)
				for i := 0; i < len(s); i++ {
					s[i] = k
				}

				return [][]int{s}
			}
		}
	}

	result := [][]int{}
	for k, v := range nums {
		if v == 0 {
			continue
		}
		nums[k]--

		ps := permute(nums)
		for j := 0; j < len(ps); j++ {
			result = append(result, append(ps[j], k))
		}

		nums[k]++
	}

	return result
}

func nonZeroKeysCnt(m map[int]int) int {
	var cnt int
	for _, v := range m {
		if v > 0 {
			cnt++
		}
	}

	return cnt
}

func areValuesZero(m map[int]int) bool {
	for _, v := range m {
		if v != 0 {
			return false
		}
	}
	return true
}
