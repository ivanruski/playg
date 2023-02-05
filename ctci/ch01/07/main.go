// Rotate Matrix: Given an image represented by an N x N matrix, where each
// pixel in the image is represented by an integer, write a method to rotate
// the image by 90 degress. Can you do this in place ?

package main

func main() {
	m := [][]int{
		{1, 2, 3},
		{4, 5, 6},
		{7, 8, 9},
	}
	RotateMatrix(m)
}

// The function doesn't have a test. It was tested in leetcode and it's correct.
// https://leetcode.com/problems/rotate-image/
func RotateMatrix(m [][]int) {
	n := len(m)
	for i := 0; i < n; i++ {
		for j := i; j < n-i-1; j++ {
			singleRotateCycle(m, i, j, m[i][j], 0)
		}
	}
}

func singleRotateCycle(m [][]int, row, col, val, cnt int) {
	// we've done a single rotate cycle
	if cnt == 4 {
		return
	}
	newrow, newcol := col, len(m)-row-1
	newval := m[newrow][newcol]
	m[newrow][newcol] = val
	singleRotateCycle(m, newrow, newcol, newval, cnt+1)
}
