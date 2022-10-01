// Sorted Matrix Search: Given an M x N matrix in which each row and each column
// is sorted in ascending order, write a method to fund an element.
//
// https://leetcode.com/problems/search-a-2d-matrix/

package main

import "fmt"

func main() {
	m := [][]int{
		{1, 3, 5, 7},
		{10, 11, 16, 20},
		{23, 30, 34, 60},
	}

	fmt.Println(searchMatrix(m, 3))
}

func searchMatrix(matrix [][]int, target int) bool {
	rowsToCheck := []int{}
	rlen := len(matrix[0]) - 1
	for i := 0; i < len(matrix); i++ {
		row := matrix[i]
		if row[0] <= target && target <= row[rlen] {
			rowsToCheck = append(rowsToCheck, i)
		}
	}

	for _, ri := range rowsToCheck {
		if binarySearch(matrix[ri], 0, rlen, target) != -1 {
			return true
		}
	}

	return false
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
