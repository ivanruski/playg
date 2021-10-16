// Given an integer array nums of unique elements, return all possible subsets
// (the power set).
//
// The solution set must not contain duplicate subsets. Return the solution in
// any order.
//
// Example 1:
// Input: nums = [1,2,3]
// Output: [[],[1],[2],[1,2],[3],[1,3],[2,3],[1,2,3]]
//
// Example 2:
// Input: nums = [0]
// Output: [[],[0]]
//
// link: https://leetcode.com/problems/subsets/

package main

import (
	"fmt"
	"math"
)

func main() {
	subsets([]int{1, 2, 3, 4})
	fmt.Println(allSubsets)
}

var allSubsets [][]int

func subsets(nums []int) [][]int {
	allSubsetsLen := math.Pow(2.0, (float64)(len(nums)))
	allSubsets = make([][]int, 0, (int)(allSubsetsLen))
	for i := 0; i <= len(nums); i++ {
		subsetsOfLenK(nums, []int{}, 0, i)
	}
	return allSubsets
}

func subsetsOfLenK(nums, curr []int, s, k int) {
	if len(curr) == k {
		dest := make([]int, k)
		copy(dest, curr)
		allSubsets = append(allSubsets, dest)
		return
	}

	for i := s; i < len(nums); i++ {
		subsetsOfLenK(nums, append(curr, nums[i]), i+1, k)
	}
}
