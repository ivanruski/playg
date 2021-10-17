// Given an array of integers nums, sort the array in ascending order.
//
// Example 1:
// Input: nums = [5,2,3,1]
// Output: [1,2,3,5]
//
// Example 2:
// Input: nums = [5,1,1,2,0,0]
// Output: [0,0,1,1,2,5]
//
// Constraints:
//
// 1 <= nums.length <= 5 * 10^4
// -5 * 104 <= nums[i] <= 5 * 10^4
//
// link: https://leetcode.com/problems/sort-an-array/

package main

func main() {

}

func mergeSort(nums []int, s, e int) {
	if s >= e {
		return
	}

	mid := (s + e) / 2
	mergeSort(nums, s, mid)
	mergeSort(nums, mid+1, e)
	merge(nums, s, mid, e)
}

func merge(nums []int, start, m, end int) {
	merged := make([]int, end-start+1)
	j, i, k := 0, start, m+1
	for i <= m && k <= end {
		if nums[i] < nums[k] {
			merged[j] = nums[i]
			i++
		} else {
			merged[j] = nums[k]
			k++
		}
		j++
	}

	for ; i <= m; i, j = i+1, j+1 {
		merged[j] = nums[i]
	}
	for ; k <= end; k, j = k+1, j+1 {
		merged[j] = nums[k]
	}

	for i, num := range merged {
		nums[start+i] = num
	}
}
