// Zero Matrix: Write an algorithm such that if an element in an an M x N matrix
// is 0, its entire row and column are set to 0
//
// There are no tests. I've ran it against leetcode(it was accepted).
// https://leetcode.com/problems/set-matrix-zeroes/

package main

func main() {
	m := [][]int{
		{1, 2, 3, 4, 5},
		{0, 1, 2, 4, 4},
		{0, 1, 2, 0, 4},
	}

	ZeroMatrix(m)
}

func ZeroMatrix(m [][]int) {
	rowsToZero := map[int]struct{}{}
	colsToZero := map[int]struct{}{}
	for i := 0; i < len(m); i++ {
		for j := 0; j < len(m[i]); j++ {
			if m[i][j] == 0 {
				rowsToZero[i] = struct{}{}
				colsToZero[j] = struct{}{}
			}
		}
	}

	for r := range rowsToZero {
		zeroRow(r, m)
	}

	for c := range colsToZero {
		zeroCol(c, m)
	}
}

func zeroRow(row int, m [][]int) {
	for j := 0; j < len(m[row]); j++ {
		m[row][j] = 0
	}
}

func zeroCol(col int, m [][]int) {
	for i := 0; i < len(m); i++ {
		m[i][col] = 0
	}
}
