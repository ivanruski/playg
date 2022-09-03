// Eight Queens: Write an algorithm to print all ways of arranging
// eight queens on an 8x8 chess board so that none of them share the
// same row, column, or diagonal. In this case, "diagonal" means all
// diagonals, not just the two that bisect the board.
//
// https://leetcode.com/problems/n-queens/

package main

import "fmt"

func main() {
	result := solveNQueens(4)
	for _, str := range result {
		fmt.Printf("%v\n\n", str)
	}
}

func solveNQueens(n int) [][]string {
	cols := make([]int, n)
	for i := 0; i < len(cols); i++ {
		cols[i] = i
	}

	colsp := permute(cols)
	result := make([][]string, 0, 64)
	for _, cols := range colsp {
		result = append(result, newBoard(cols))
	}
	return result
}

func newBoard(cols []int) []string {
	board := make([][]rune, len(cols))
	for i := 0; i < len(cols); i++ {
		board[i] = make([]rune, len(cols))
		for j := 0; j < len(cols); j++ {
			board[i][j] = '.'
		}
	}

	for row, c := range cols {
		board[row][c] = 'Q'
	}

	result := make([]string, 0, len(board))
	for _, b := range board {
		result = append(result, string(b))
	}

	return result
}

func isBoardValid(board []int) bool {
	for row, col := range board {
		for i := row + 1; i < len(board); i++ {
			if i-row == board[i]-col ||
				i-row == col-board[i] {
				return false
			}
		}
	}

	return true
}

func permute(nums []int) [][]int {
	result := make([][]int, 0, fact(len(nums)))
	var f func([]int)

	f = func(prefix []int) {
		if !isBoardValid(prefix) {
			return
		}

		if len(prefix) == len(nums) {
			r := make([]int, len(prefix))
			copy(r, prefix)
			result = append(result, r)
			return
		}

		for _, n := range nums {
			if !isInSlice(n, prefix) {
				f(append(prefix, n))
			}
		}
	}

	prefix := make([]int, 0, len(nums))
	f(prefix)

	return result
}

func fact(n int) int {
	result := 1
	for i := 2; i <= n; i++ {
		result *= i
	}

	return result
}

func isInSlice(n int, nums []int) bool {
	for i := 0; i < len(nums); i++ {
		if nums[i] == n {
			return true
		}
	}
	return false
}
