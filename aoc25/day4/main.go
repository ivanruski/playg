package main

import (
	"bufio"
	"bytes"
	"fmt"
	"os"
)

// https://adventofcode.com/2025/day/4
func main() {
	grid, _ := readInput()

	fmt.Println(countAccessibleRolls(grid))
	fmt.Println(removeAccessibleRolls(grid))
}

func countAccessibleRolls(grid [][]rune) int {
	cnt := 0

	for r := range len(grid) {
		for c := range len(grid[r]) {
			if grid[r][c] == '@' && countAdjacentRolls(r, c, grid) <= 4 {
				cnt++
			}
		}
	}

	return cnt
}

func removeAccessibleRolls(grid [][]rune) int {
	cnt := 0
	stop := false
	for !stop {
		stop = true
		for r := range len(grid) {
			for c := range len(grid[r]) {
				if grid[r][c] == '@' && countAdjacentRolls(r, c, grid) <= 4 {
					cnt++
					grid[r][c] = 'x'
					stop = false
				}
			}
		}
	}

	return cnt
}

func countAdjacentRolls(r, c int, grid [][]rune) int {
	cnt := 0

	for i := -1; i < 2; i++ {
		for j := -1; j < 2; j++ {
			row := i + r
			col := j + c
			if row < 0 || row >= len(grid) || col < 0 || col >= len(grid[row]) {
				continue
			}

			if grid[row][col] == '@' {
				cnt++
			}
		}
	}

	return cnt
}

func readInput() ([][]rune, error) {
	b, err := os.ReadFile("input.txt")
	if err != nil {
		return nil, err
	}

	scanner := bufio.NewScanner(bytes.NewReader(b))
	scanner.Split(bufio.ScanLines)

	grid := [][]rune{}
	for scanner.Scan() {
		grid = append(grid, []rune(scanner.Text()))
	}

	return grid, nil
}
