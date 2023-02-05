// Permutations without Dups: Write a method to compute all
// permutations of a string of unique characters.
//
// I will use ints, because in this way I can test my solution in
// leetcode.
//
// https://leetcode.com/problems/permutations/

package main

import (
	"fmt"
)

func main() {
	arr := []int{1, 2, 3, 4}
	perms := permute(arr)
	for i := 0; i < len(perms); i++ {
		fmt.Printf("%v\n", perms[i])
	}
}

func permute(nums []int) [][]int {
	return permute1(nums)
	//var (
	//	permutations = make([][]int, 0, factorial(len(nums)))
	//	prefix       = make([]int, 0, len(nums))
	//)
	//
	//permute2(nums, prefix, &permutations)
	//return permutations
}

func permute1(nums []int) [][]int {
	if len(nums) == 1 {
		return [][]int{
			{nums[0]},
		}
	}

	ps := make([][]int, 0, factorial(len(nums)))
	suffix := make([]int, len(nums)-1)
	for i := 0; i < len(nums); i++ {
		copy(suffix, nums[:i])
		for j := i + 1; j < len(nums); j++ {
			suffix[j-1] = nums[j]
		}
		tmps := permute1(suffix)
		for j := 0; j < len(tmps); j++ {
			ps = append(ps, append(tmps[j], nums[i]))
		}
	}
	return ps
}

func permute2(nums, prefix []int, permutations *[][]int) {
	if len(prefix) == len(nums) {
		p := make([]int, len(nums))
		copy(p, prefix)
		*permutations = append(*permutations, p)
		return
	}

	for _, n := range nums {
		if !sliceContains(prefix, n) {
			permute2(nums, append(prefix, n), permutations)
		}
	}
}

func sliceContains(nums []int, n int) bool {
	for i := 0; i < len(nums); i++ {
		if nums[i] == n {
			return true
		}
	}
	return false
}

func factorial(n int) int {
	if n == 1 {
		return 1
	}

	return n * factorial(n-1)
}
