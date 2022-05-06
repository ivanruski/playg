// Given an array of integers nums which is sorted in ascending order, and an
// integer target, write a function to search target in nums. If target exists,
// then return its index. Otherwise, return -1.
//
// You must write an algorithm with O(log n) runtime complexity.
//
// Constraints:
//
// - 1 <= nums.length <= 104
// - -104 < nums[i], target < 104
// - All the integers in nums are unique.
// - nums is sorted in ascending order.
//
// https://leetcode.com/problems/binary-search/

package main

func main() {
}

func search(nums []int, target int) int {
	return binarySearch(nums, target, 0, len(nums)-1)
}

func binarySearch(nums []int, target, from, to int) int {
	if from > to {
		return -1
	}

	mid := (from + to) / 2
	if nums[mid] == target {
		return mid
	}
	if nums[mid] > target {
		return binarySearch(nums, target, from, mid-1)
	}

	return binarySearch(nums, target, mid+1, to)
}
