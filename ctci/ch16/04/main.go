// Tic Tac Win: Design an algorithm to figure out if someone has won a game of
// tic-tac-toe.
//
// https://leetcode.com/problems/find-winner-on-a-tic-tac-toe-game/

package main

import "fmt"

func main() {
	moves := [][]int{
		{0, 0},
		{2, 0},
		{1, 1},
		{2, 1},
		{2, 2},
	}

	winner := tictactoe(moves)
	fmt.Println(winner)
}

func tictactoe(moves [][]int) string {
	board := make([][]string, 3)
	for i := 0; i < 3; i++ {
		board[i] = make([]string, 3)
	}

	a, b := "A", "B"
	for i, m := range moves {
		player := a
		if i%2 == 1 {
			player = b
		}
		row, col := m[0], m[1]
		board[row][col] = player

		// no point in checking for winner after the first 4 moves
		if i > 3 && checkForWinner(row, col, board) {
			return player
		}
	}

	if len(moves) != 9 {
		return "Pending"
	}
	return "Draw"
}

func checkForWinner(row, col int, board [][]string) bool {
	player := board[row][col]

	var won bool = true

	// check the row
	for i := 0; i < 3; i++ {
		if board[row][i] != player {
			won = false
		}
	}

	if won {
		return true
	}
	won = true

	// check the col
	for i := 0; i < 3; i++ {
		if board[i][col] != player {
			won = false
		}
	}

	if won {
		return true
	}
	won = true

	// check if the point is lying on a diagonal
	ok := isOnDiag(row, col)
	if !ok {
		return false
	}

	for i := 0; i < 3; i++ {
		if board[i][i] != player {
			won = false
		}
	}

	if won {
		return true
	}
	won = true

	for i := 2; i >= 0; i-- {
		if board[i][2-i] != player {
			won = false
		}
	}

	return won
}

func isOnDiag(row, col int) bool {
	// pick point on the diagonal outside the board, to avoid picking the same as row, col
	x := -1
	y := -1

	s := (col - y) / (row - x)
	if s == 1 {
		return true
	}

	x = 3
	s = (col - y) / (row - x)
	if s == -1 {
		return true
	}

	return false
}
