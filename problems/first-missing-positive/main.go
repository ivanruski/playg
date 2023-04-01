// Given an unsorted integer array nums, return the smallest missing positive integer.
// 
// You must implement an algorithm that runs in O(n) time and uses constant extra space.
//
// Example 1:
//
// Input: nums = [1,2,0]
// Output: 3
// Explanation: The numbers in the range [1,2] are all in the array.
//
// Example 2:
// 
// Input: nums = [3,4,-1,1]
// Output: 2
// Explanation: 1 is in the array but 2 is missing.
//
// Example 3:
// 
// Input: nums = [7,8,9,11,12]
// Output: 1
// Explanation: The smallest positive integer 1 is missing.
//
// Constraints:
// 1 <= nums.length <= 105
// -2^31 <= nums[i] <= 2^31 - 1
// 
// https://leetcode.com/problems/first-missing-positive/

package main

import "sort"

func main() {
}

func firstMissingPositive(nums []int) int {
	for i := 0; i < len(nums); i++ {
		placeAtI(nums[i], nums)
	}

	for i := 0; i < len(nums); i++ {
		if nums[i] != i+1 {
			return i + 1
		}
	}

	return len(nums) + 1
}

func placeAtI(ni int, nums []int) {
	if ni < 1 {
		return
	}

	if ni > 0 && ni <= len(nums) {
		if nums[ni-1] == ni {
			return
		}

		nj := nums[ni-1]
		nums[ni-1] = ni
		placeAtI(nj, nums)
	}
}
