// Power Set: Write a method to return all subsets of a set.
//
// https://leetcode.com/problems/subsets/

package main

import "fmt"

func main() {
	ss := subsets([]int{1, 2, 3, 4, 5})
	for _, s := range ss {
		fmt.Println(s)
	}
}

func subsets(nums []int) [][]int {
	ss := make([][]int, 0, 2<<len(nums))
	ss = append(ss, []int{})

	for i := 1; i <= len(nums); i++ {
		ss = append(ss, subsetsOfLen(0, i, nil, nums)...)
	}

	return ss
}

func subsetsOfLen(s, k int, prefix, arr []int) [][]int {
	subsets := [][]int{}
	for i := s; i < len(arr); i++ {
		subset := make([]int, len(prefix)+1)
		copy(subset, prefix)
		subset[len(prefix)] = arr[i]

		if len(subset) == k {
			subsets = append(subsets, subset)
		} else {
			ss := subsetsOfLen(i+1, k, subset, arr)
			subsets = append(subsets, ss...)
		}
	}

	return subsets
}
