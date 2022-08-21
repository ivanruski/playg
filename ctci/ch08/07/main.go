// Permutations without Dups: Write a method to compute all
// permutations of a string of unique characters.
//
// I will use ints, because in this way I can test my solution in
// leetcode.
//
// https://leetcode.com/problems/permutations/

package main

import "fmt"

func main() {
	arr := []int{1, 2, 3}
	perms := permute(arr)
	for i := 0; i < len(perms); i++ {
		fmt.Printf("%v\n", perms[i])
	}
}

func permute(nums []int) [][]int {
	if len(nums) == 1 {
		return [][]int{
			{nums[0]},
		}
	}

	result := make([][]int, 0, factorial(len(nums)))
	suffix := make([]int, len(nums)-1)
	for i := 0; i < len(nums); i++ {
		copy(suffix, nums[:i])
		for j := i + 1; j < len(nums); j++ {
			suffix[j-1] = nums[j]
		}
		sp := permute(suffix)
		for j := 0; j < len(sp); j++ {
			result = append(result, append(sp[j], nums[i]))
		}
	}

	return result
}

func factorial(n int) int {
	if n == 1 {
		return 1
	}

	return n * factorial(n-1)
}
