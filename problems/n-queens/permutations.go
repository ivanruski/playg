// The n-queens puzzle is the problem of placing n queens on an n x n
// chessboard such that no two queens attack each other.
//
// Given an integer n, return all distinct solutions to the n-queens
// puzzle.
//
// Each solution contains a distinct board configuration of the
// n-queens' placement, where 'Q' and '.' both indicate a queen and an
// empty space, respectively.
//
// https://leetcode.com/problems/n-queens/
//
// leetcode accepts this solution but it's faster than only 15% of all
// submissions

package main

import (
	"flag"
	"fmt"
	"math"
)

func main() {
	n := flag.Int("n", 0, "")
	flag.Parse()
	cs := getPossibleQueensPlacements(*n)
	fmt.Println(len(cs))
}

type coord struct {
	row int
	col int
}

func solveNQueens(n int) [][]string {
	qs := getPossibleQueensPlacements(n)
	solutions := make([][]string, 0)
	for _, q := range qs {
		board := generateEmptyBoard(len(q))
		for _, coord := range q {
			placeQueen(board, coord.row, coord.col)
		}
		solutions = append(solutions, boardToStringSlice(board))
	}

	return solutions
}

func getPossibleQueensPlacements(n int) [][]coord {
	qp := make([][]coord, 0, factorial(n))
	permutations := permute(n)
	for _, permutation := range permutations {
		c := make([]coord, 0)
		for i, p := range permutation {
			c = append(c, coord{row: i, col: p})
		}

		if !checkForQueensOnSameDiagonal(c) {
			qp = append(qp, c)
		}
	}
	return qp
}

func checkForQueensOnSameDiagonal(coords []coord) bool {
	for i := 0; i < len(coords); i++ {
		for j := i + 1; j < len(coords); j++ {
			c1 := coords[i]
			c2 := coords[j]
			if math.Abs(float64(c1.row-c2.row)) == math.Abs(float64(c1.col-c2.col)) {
				return true
			}
		}
	}
	return false
}

func solutionAlreadyFound(solutions [][]string, solution []string) bool {
	for _, s := range solutions {
		if sliceAreEqual(s, solution) {
			return true
		}
	}
	return false
}

func sliceAreEqual(s1, s2 []string) bool {
	if len(s1) != len(s2) {
		return false
	}
	for i, s := range s1 {
		if s != s2[i] {
			return false
		}
	}
	return true
}

func boardToStringSlice(board [][]rune) []string {
	boardSs := make([]string, 0, len(board))
	for i := 0; i < len(board); i++ {
		boardSs = append(boardSs, string(board[i]))
	}
	return boardSs
}

func canPlaceQueen(board [][]rune, row, col int) bool {
	return board[row][col] == '*'
}

func placeQueen(board [][]rune, row, col int) bool {
	if board[row][col] == '.' || board[row][col] == 'Q' {
		return false
	}

	board[row][col] = 'Q'
	for i := 0; i < len(board); i++ {
		if board[row][i] == '.' || i == col {
			continue
		}
		board[row][i] = '.'
	}
	for i := 0; i < len(board); i++ {
		if board[i][col] == '.' || i == row {
			continue
		}
		board[i][col] = '.'
	}
	for i := 1; i < len(board); i++ {
		// down & right
		r1 := row + i
		c1 := col + i
		// up & left
		r2 := row - i
		c2 := col - i
		// down & left
		r3 := row + i
		c3 := col - i
		// up & right
		r4 := row - i
		c4 := col + i

		if r1 < len(board) && c1 < len(board) {
			board[r1][c1] = '.'
		}
		if r2 >= 0 && c2 >= 0 {
			board[r2][c2] = '.'
		}
		if r3 < len(board) && c3 >= 0 {
			board[r3][c3] = '.'
		}
		if r4 >= 0 && c4 < len(board) {
			board[r4][c4] = '.'
		}
	}

	return true
}

func generateEmptyBoard(n int) [][]rune {
	board := make([][]rune, n)
	for i := 0; i < n; i++ {
		row := make([]rune, 0, n)
		for j := 0; j < n; j++ {
			row = append(row, '*')
		}
		board[i] = row
	}
	return board
}

func permute(n int) [][]int {
	nums := make([]int, 0)
	for i := 0; i < n; i++ {
		nums = append(nums, i)
	}
	return buildpermutationslist(nil, nums, nil)
}

func buildpermutationslist(permutation, nums []int, result [][]int) [][]int {
	if len(permutation) == len(nums) {
		s := make([]int, len(nums), len(nums))
		copy(s, permutation)
		return append(result, s)
	}

	for _, num := range nums {
		if !isInSlice(num, permutation) {
			result = buildpermutationslist(append(permutation, num), nums, result)
		}
	}
	return result
}

func isInSlice(n int, s []int) bool {
	for _, num := range s {
		if n == num {
			return true
		}
	}
	return false
}

func factorial(n int) (f int) {
	if n < 1 {
		return f
	}

	f = 1
	for i := 2; i <= n; i++ {
		f *= i
	}
	return f
}
