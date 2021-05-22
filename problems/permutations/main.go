// Given an array nums of distinct integers, return all the possible
// permutations. You can return the answer in any order.
//
// Example 1:
//
// Input: nums = [1,2,3]
// Output: [[1,2,3],[1,3,2],[2,1,3],[2,3,1],[3,1,2],[3,2,1]]
// Example 2:
//
// Input: nums = [0,1]
// Output: [[0,1],[1,0]]
// Example 3:
//
// Input: nums = [1]
// Output: [[1]]
//
//
// Constraints:
//
// 1 <= nums.length <= 6
// -10 <= nums[i] <= 10
// All the integers of nums are unique.

package main

import (
	"flag"
	"fmt"
)

func main() {
	n := flag.Int("n", 0, "")
	flag.Parse()
	play(*n)
}

func play(n int) {
	nums := make([]int, n, n)
	for i := 0; i < n; i++ {
		nums[i] = i + 1
	}

	r := buildpermutationslist(nil, nums, nil)

	for _, p := range r {
		fmt.Println(p)
	}
}

func permute(nums []int) [][]int {
	return buildpermutationslist(nil, nums, nil)
}

func buildpermutationslist(permutation, nums []int, result [][]int) [][]int {
	if len(permutation) == len(nums) {
		return append(result, permutation)
	}

	for _, num := range nums {
		if !isInSlice(num, permutation) {
			result = buildpermutationslist(append(permutation, num), nums, result)
		}
	}
	return result
}

func isInSlice(n int, s []int) bool {
	for _, num := range s {
		if n == num {
			return true
		}
	}
	return false
}

func factorial(n int) (f int) {
	if n < 1 {
		return f
	}

	f = 1
	for i := 2; i <= n; i++ {
		f *= i
	}
	return f
}
