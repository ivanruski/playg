// You are given an integer array nums and you have to return a new counts
// array. The counts array has the property where counts[i] is the number of
// smaller elements to the right of nums[i].
//
// Example 1:
// Input: nums = [5,2,6,1]
// Output: [2,1,1,0]
// Explanation:
// To the right of 5 there are 2 smaller elements (2 and 1).
// To the right of 2 there is only 1 smaller element (1).
// To the right of 6 there is 1 smaller element (1).
// To the right of 1 there is 0 smaller element.
//
// Example 2:
// Input: nums = [-1]
// Output: [0]
//
// Example 3:
// Input: nums = [-1, -1]
// Output: [0, 0]
//
// Example 4:
// Input: nums = [2, 0, 1]
// Output: [2, 0, 0]
//
//
// Constraints:
// 1 <= nums.length <= 10^5
// -10^4 <= nums[i] <= 10^4
//
// link: https://leetcode.com/problems/count-of-smaller-numbers-after-self/

package main

import (
	"fmt"
)

func main() {
	nums := []int{10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0}
	counts := countSmaller(nums)
	fmt.Println(counts)
}

type Cnt struct {
	num        int
	index      int
	smallerCnt int
}

// The naive approach is with 2 nested for loops. However it timeouts because
// the time complexity is O(n^2).
// A faster approach is to perform a merge sort and while comparing each of the
// numbers to keep track of the number of smaller numbers to the right.
// If a number from the right sub-array is less than a number from the left sub-
// array then for the current number in the left sub-array all the way till the
// end of it, the smallerCnt should be incremented
func countSmaller(nums []int) []int {
	counts := make([]Cnt, len(nums))
	for i, n := range nums {
		counts[i] = Cnt{
			num:   n,
			index: i,
		}
	}

	mergeSort(counts, 0, len(counts)-1)
	result := make([]int, len(nums))
	for _, c := range counts {
		result[c.index] = c.smallerCnt
	}

	return result
}

func mergeSort(counts []Cnt, s, e int) {
	if s >= e {
		return
	}
	mid := (s + e) / 2
	mergeSort(counts, s, mid)
	mergeSort(counts, mid+1, e)
	merge(counts, s, mid, e)
}

func merge(counts []Cnt, start, mid, end int) {
	merged := make([]Cnt, end-start+1)
	c, j, i, k := 0, 0, start, mid+1
	for i <= mid && k <= end {
		if counts[i].num <= counts[k].num {
			merged[j] = counts[i]
			merged[j].smallerCnt += c
			i++
		} else {
			c++
			merged[j] = counts[k]
			k++
		}
		j++
	}

	for ; i <= mid; i, j = i+1, j+1 {
		cnt := counts[i]
		cnt.smallerCnt += c
		merged[j] = cnt
	}
	for ; k <= end; k, j = k+1, j+1 {
		merged[j] = counts[k]
	}

	for i, m := range merged {
		counts[start+i] = m
	}
}
