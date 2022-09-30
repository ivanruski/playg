// Peaks and Valleys: In an array of integers, a "peak" is an element which is
// greater than or equal to the adjacent integers and a "valley" is an element
// which is less than or equal to the adjacent integers. For example, in the
// array {5, 8, 6, 2, 3, 4, 6}, {8, 6} are peaks and {5, 2} are valleys. Given
// and array of integers, sort the array into an alternating sequence of peaks
// and valleys.
//
// EXAMPLE
//
// Input: {5, 3, 1, 2, 3}
// Output: {5, 1, 3, 2, 3}

package main

import (
	"fmt"
	"sort"
)

func main() {
	nums := []int{5, 3, 1, 2, 4}
	res := PeeksAndValleys(nums)

	fmt.Println(res)
}

// O(n*logn)
func PeeksAndValleys(nums []int) []int {
	if len(nums) == 0 {
		return nil
	}

	arr := make([]int, len(nums))
	copy(arr, nums)
	sort.Ints(arr)

	res := make([]int, 0, len(arr))
	res = append(res, arr[0])
	for i := 1; i < len(arr)-1; i += 2 {
		res = append(res, arr[i+1])
		res = append(res, arr[i])
	}

	if len(res) < len(arr) {
		res = append(res, arr[len(arr)-1])
	}

	return res
}

// O(n)
func PeeksAndValleys2(nums []int) []int {
	if len(nums) < 3 {
		return nums
	}

	pv := make([]int, 0, len(nums))

	// create initial peek
	s, m, l := sortAsc(nums[0], nums[1], nums[2])
	pv = append(pv, s, l, m)

	// is the last element in pv peek
	var isPeek bool
	for i := 3; i < len(nums)-2; i += 3 {
		s, m, l := sortAsc(nums[i], nums[i+1], nums[i+2])
		if isPeek {
			// last element is smaller than the next three
			// swap the smallest with it
			if pv[i-1] < s {
				s, pv[i-1] = pv[i-1], s
			}

			pv = append(pv, s, l, m)
		} else {
			// last element is greater than the next three
			// swap the largest with it
			if pv[i-1] > l {
				l, pv[i-1] = pv[i-1], l
			}
			pv = append(pv, l, s, m)

		}

		isPeek = !isPeek
	}

	// one or two elements might need to be handled
	if len(pv)+1 == len(nums) {
		lastPV, lastNums := pv[len(pv)-1], nums[len(nums)-1]
		if isPeek {
			last := lastNums
			if lastPV < lastNums {
				// pv = append(pv, lastNums)
				pv[len(pv)-1] = lastNums
				last = lastPV
			}
			pv = append(pv, last)
		} else {
			last := lastNums
			if lastPV > lastNums {
				pv[len(pv)-1] = lastNums
				last = lastPV
			}
			pv = append(pv, last)
		}
	}
	if len(pv)+2 == len(nums) {
		s, m, l := sortAsc(pv[len(pv)-1], nums[len(nums)-2], nums[len(nums)-1])
		if isPeek {
			pv[len(pv)-1] = l
			pv = append(pv, s, m)
		} else {
			pv[len(pv)-1] = s
			pv = append(pv, l, m)
		}
	}

	return pv
}

func sortAsc(a, b, c int) (int, int, int) {
	s := []int{a, b, c}
	sort.Ints(s)

	return s[0], s[1], s[2]
}
