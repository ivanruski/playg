// Paint Fill: Implement the "paint fill" function that one might see
// on many image editing programs. That is, given a screen
// (represented by a two-dimensional array of colors), a point, and a
// new color, fill in the surrounding area until the color changes
// from the original color.
//
// https://leetcode.com/problems/flood-fill/

package main

import "fmt"

func main() {
	area := [][]int{
		{1, 1},
		{1, 1},
		{1, 1},
	}

	printArea(area)
	paintFill(area, 1, 1, 2)

	fmt.Printf("\n\n")
	printArea(area)
}

func printArea(area [][]int) {
	for i := 0; i < len(area); i++ {
		for j := 0; j < len(area[i]); j++ {
			fmt.Printf("%d ", area[i][j])
		}
		fmt.Println()
	}
}

func paintFill(area [][]int, x, y, newColor int) {
	visited := make([][]bool, len(area))
	for i := 0; i < len(area); i++ {
		visited[i] = make([]bool, len(area[i]))
	}

	fill(area, visited, x, y, newColor)
}

// we call solve the problem without using the visited slice
func fill(area [][]int, visited [][]bool, x, y, newColor int) {
	if visited[x][y] {
		return
	}

	oldColor := area[x][y]
	area[x][y] = newColor
	visited[x][y] = true

	// upper
	if pointIsValid(area, x, y-1) && oldColor == area[x][y-1] {
		fill(area, visited, x, y-1, newColor)
	}

	// left
	if pointIsValid(area, x-1, y) && oldColor == area[x-1][y] {
		fill(area, visited, x-1, y, newColor)
	}

	// right
	if pointIsValid(area, x+1, y) && oldColor == area[x+1][y] {
		fill(area, visited, x+1, y, newColor)
	}

	// down
	if pointIsValid(area, x, y+1) && oldColor == area[x][y+1] {
		fill(area, visited, x, y+1, newColor)
	}
}

func pointIsValid(area [][]int, x, y int) bool {
	return !(x < 0 || y < 0 || x >= len(area) || y >= len(area[x]))
}
