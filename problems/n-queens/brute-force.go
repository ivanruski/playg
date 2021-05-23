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
// this solution exceeds the time limit constraint, it's correct though

package main

func main() {
}

func solveNQueens(n int) [][]string {
	if n <= 0 {
		return nil
	}

	allSolutions := make([][]string, 0, n)
	for i := 0; i < n; i++ {
		for j := 0; j < n; j++ {
			board := generateEmptyBoard(n)
			placeQueen(board, i, j)
			solutions := findSolutions(board, make([][]string, 0))
			for _, s := range solutions {
				if solutionAlreadyFound(allSolutions, s) {
					continue
				}
				allSolutions = append(allSolutions, s)
			}
		}
	}

	return allSolutions
}

func findSolutions(board [][]rune, solutions [][]string) [][]string {
	if allQueensPlaced(board) {
		boardSs := boardToStringSlice(board)
		if solutionAlreadyFound(solutions, boardSs) {
			return solutions
		}
		return append(solutions, boardSs)
	}
	if isBoardFullyOccupied(board) {
		return nil
	}

	for i := 0; i < len(board); i++ {
		for j := 0; j < len(board); j++ {
			if !canPlaceQueen(board, i, j) {
				continue
			}

			boardCopy := copyBoard(board)
			if placeQueen(boardCopy, i, j) {
				s := findSolutions(boardCopy, solutions)
				if len(s) > 0 {
					solutions = s
				}
			}
		}
	}

	return solutions
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

func copyBoard(board [][]rune) [][]rune {
	newBoard := make([][]rune, len(board), len(board))
	for i := 0; i < len(board); i++ {
		newBoard[i] = make([]rune, len(board), len(board))
		for j := 0; j < len(board); j++ {
			newBoard[i][j] = board[i][j]
		}
	}

	return newBoard
}

func isBoardFullyOccupied(board [][]rune) bool {
	for i := 0; i < len(board); i++ {
		for j := 0; j < len(board); j++ {
			if board[i][j] == '.' {
				return false
			}
		}
	}
	return true
}

func allQueensPlaced(board [][]rune) bool {
	expected := len(board)
	found := 0
	for i := 0; i < len(board); i++ {
		for j := 0; j < len(board); j++ {
			if board[i][j] == 'Q' {
				found++
			}
		}
	}

	return found == expected
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
