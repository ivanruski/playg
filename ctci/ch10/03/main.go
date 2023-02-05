// Search in Rotated Array: Given a sorted array of n integers that
// has been rotated an unkown number of times, write code to find an
// element in the array. You may assume that the array was orginally
// sorted in increasing order.
//
// https://leetcode.com/problems/search-in-rotated-sorted-array/

package main

import "fmt"

func main() {
	arr := []int{4, 5, 6, 7, 0, 1, 2}
	fmt.Println(search(arr, 0))

}

func search(nums []int, target int) int {
	var pivot int
	for i := 1; i < len(nums); i++ {
		if nums[i-1] > nums[i] {
			pivot = i
		}
	}

	idx := searchSorted(nums[0:pivot], target)
	if idx != -1 {
		return idx
	}

	idx = searchSorted(nums[pivot:], target)
	if idx != -1 {
		return pivot + idx
	}
	return -1
}

func searchSorted(nums []int, x int) int {
	return binarySearch(nums, 0, len(nums)-1, x)
}

func binarySearch(nums []int, l, r, x int) int {
	if l > r {
		return -1
	}

	m := (l + r) / 2
	if nums[m] == x {
		return m
	}
	if x < nums[m] {
		return binarySearch(nums, l, m-1, x)
	}

	return binarySearch(nums, m+1, r, x)
}
