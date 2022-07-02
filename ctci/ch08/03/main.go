// Magic Index: A magic index in an array A[0...n-1] is defined to e
// an index such that A[i] = i. Given a sorted Array of distinc
// integers, write a method to find a mgic index, if one exists, in
// array A.
//
// FOLLOW UP
//
// What if the values are not distinc ?

package main

func main() {}

func magicIndex(arr []int) int {
	return findMagicIndex(0, len(arr)-1, arr)
}

func findMagicIndex(left, right int, arr []int) int {
	if left > right {
		return -1
	}

	m := (left + right) / 2
	if arr[m] == m {
		return m
	}
	if arr[m] > m {
		return findMagicIndex(left, m-1, arr)
	}
	return findMagicIndex(m+1, right, arr)
}

// FOLLOW UP
func magicIndexWithDups(arr []int) int {
	return findMagicIndexWithDups(0, len(arr)-1, arr)
}

// When we have duplicates we have to look on the both sides of the
// array. We have the same steps as before, but this time if couldn't
// find the magic index in the left/right part we try to find it in
// the right/left part.
// The optimization step we do is we skip elements we know are not the
// answer e.g.
// input: -5, -5, -5, 1, 2, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5
// m: 11, arr[m] < m, we will try to find it in the right part.. we won't
// we will look in the left part but from [left, arr[m]], which is 5 not from m - 1,
// thus skipping 6 elements
func findMagicIndexWithDups(left, right int, arr []int) int {
	if left > right || left < 0 || right >= len(arr) {
		return -1
	}

	m := (left + right) / 2
	if arr[m] == m {
		return m
	}
	if arr[m] > m {
		li := findMagicIndexWithDups(left, m-1, arr)
		if li != -1 {
			return li
		}
		return findMagicIndexWithDups(arr[m], right, arr)
	}

	ri := findMagicIndexWithDups(m+1, right, arr)
	if ri != -1 {
		return ri
	}
	return findMagicIndexWithDups(left, arr[m], arr)
}
