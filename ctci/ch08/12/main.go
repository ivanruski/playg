// Eight Queens: Write an algorithm to print all ways of arranging
// eight queens on an 8x8 chess board so that none of them share the
// same row, column, or diagonal. In this case, "diagonal" means all
// diagonals, not just the two that bisect the board.
//
// https://leetcode.com/problems/n-queens/

package main

import (
	"flag"
	"fmt"
)

func main() {
	n := flag.Int("n", 0, "")
	flag.Parse()

	result := solveNQueens(*n)
	for _, str := range result {
		fmt.Printf("%v\n", str)
	}
}

func solveNQueens(n int) [][]string {
	board := make([]int, 0, n)
	result := make([][]string, 0, 16)

	for i := 0; i < n; i++ {
		nqueens(i, n, append(board, i), &result)
	}

	return result
}

func nqueens(col, n int, board []int, result *[][]string) {
	if len(board) == n {
		*result = append(*result, newBoard(board))
		return
	}

	for i := 0; i < n; i++ {
		newB := append(board, i)
		if isBoardValid(newB) {
			nqueens(i, n, append(board, i), result)
		}
	}
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
			if col == board[i] {
				return false
			}
			// diagonals check
			if i-row == board[i]-col ||
				i-row == col-board[i] {
				return false
			}
		}
	}

	return true
}
