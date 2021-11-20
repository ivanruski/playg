// Given an unsorted integer array nums, return the smallest missing positive
// integer.
//
// Example 1:
// Input: [1, 3, 6, 4, 1, 2]
// Output: 5
//
// Example 2:
// Input: [1, 2, 3]
// Output: 4
//
// Example 3:
// Input: [-1, -2]
// Input: 1
//
// links:
//  - https://leetcode.com/problems/first-missing-positive/ (this one want solution with O(n))
//  - https://app.codility.com/c/run/demoNW9V87-J29/ (codility programming demo test)

package main

import "sort"

func main() {
}

// The solution is with time complexity O(n*logn) because I am sorting the array.
// Assuming that the sort algorithm is O(n*logn) and contains and insert into a
// a map is O(1)
func firstMissingPositive(A []int) int {
	nums := getPositiveOnly(A)

	// everything in A was a negative nums
	if len(nums) == 0 {
		return 1
	}

	sort.Ints(nums)
	// The smallest num is larger than one
	if nums[0] > 1 {
		return 1
	}

	nm := make(map[int]struct{}, len(nums))
	for _, n := range nums {
		_, ok := nm[n]
		if !ok {
			nm[n] = struct{}{}
		}
	}

	for _, n := range nums {
		_, ok := nm[n+1]
		if !ok {
			return n + 1
		}
	}

	return nums[len(nums)-1] + 1
}

func getPositiveOnly(A []int) []int {
	ns := make([]int, 0, len(A))
	for _, a := range A {
		if a > 0 {
			ns = append(ns, a)
		}
	}
	return ns
}
