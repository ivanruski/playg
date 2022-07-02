// Robot in a Grid: Imagine a robot sitting on the upper left corner
// of with r rows and c colmuns. The robot can only move in two
// directions, right and down, but certain cells are "off limits" such
// that the robot cannot step on them. Design an algorithm to find a
// path for the robot from the top left to the bottom right.
//
// I will solve a slightly different problem because I found similar
// one in leetcode and wanted to test my solution against it. In
// leetcode the ask to count all possible paths.
//
// https://leetcode.com/problems/unique-paths-ii/

package main

import "fmt"

func main() {
	grid := [][]int{
		{0, 0, 0, 0},
		{0, 0, 0, 0},
		{0, 0, 1, 0},
		{0, 0, 0, 0},
	}

	fmt.Println(uniquePathsWithObstacles(grid))
}

func uniquePathsWithObstacles(grid [][]int) int {
	for i := 0; i < len(grid); i++ {
		for j := 0; j < len(grid[i]); j++ {
			if grid[i][j] == 1 {
				grid[i][j] = -1
			}
		}
	}

	return findPath(0, 0, grid)
}

func findPath(r, c int, grid [][]int) int {
	if r >= len(grid) {
		return 0
	}
	if c >= len(grid[r]) {
		return 0
	}
	if grid[r][c] == -1 {
		return 0
	}
	if r == len(grid)-1 && c == len(grid[r])-1 {
		return 1
	}

	if grid[r][c] > 0 {
		return grid[r][c]
	}

	cnt := findPath(r, c+1, grid) + findPath(r+1, c, grid)
	grid[r][c] = cnt

	return cnt
}
