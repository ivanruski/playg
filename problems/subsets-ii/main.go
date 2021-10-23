// Given an integer array nums that may contain duplicates, return all possible
// subsets (the power set).  The solution set must not contain duplicate
// subsets. Return the solution in any order.
//
// The solution set must not contain duplicate subsets. Return the solution in
// any order.
//
// Example 1:
// Input: nums = [1,2,2]
// Output: [[],[1],[1,2],[1,2,2],[2],[2,2]]
//
// Example 2:
// Input: nums = [0]
// Output: [[],[0]]
//
// link: https://leetcode.com/problems/subsets-ii/
//
// Constraints:
// 1 <= nums.length <= 10
// -10 <= nums[i] <= 10

package main

import (
	"fmt"
	"math"
	"sort"
	"strings"
)

func main() {
	subsetsWithDup([]int{4, 4, 4, 1, 4})
	fmt.Println(allSubsets)
}

var allSubsets [][]int
var sm map[string]struct{}

// subsetsWithDup is almost identical t subsets with the exception
// that every subset is being sorted and then it's checked if it's
// already added to the final result.
//
// TODO: The solution is not the optimal one.
func subsetsWithDup(nums []int) [][]int {
	allSubsetsLen := math.Pow(2.0, (float64)(len(nums)))
	allSubsets = make([][]int, 0, (int)(allSubsetsLen))
	sm = make(map[string]struct{})
	for i := 0; i <= len(nums); i++ {
		subsetsOfLenK(nums, []int{}, 0, i)
	}
	return allSubsets
}

func subsetsOfLenK(nums, curr []int, s, k int) {
	if len(curr) == k {
		dest := make([]int, k)
		copy(dest, curr)
		sort.Ints(dest)
		strArr := stringifyArray(dest)
		if _, ok := sm[strArr]; ok {
			return
		}

		allSubsets = append(allSubsets, dest)
		sm[strArr] = struct{}{}
		return
	}

	for i := s; i < len(nums); i++ {
		subsetsOfLenK(nums, append(curr, nums[i]), i+1, k)
	}
}

func stringifyArray(arr []int) string {
	buf := strings.Builder{}
	for _, n := range arr {
		buf.WriteString(fmt.Sprintf("%d", n))
	}
	return buf.String()
}
