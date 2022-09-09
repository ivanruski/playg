// Stack of Boxes: You have a stack of n boxes, with widths wi,
// heights hi, and depths di. The boxes cannot be rotated and can only
// be stacked on top of one another if each box in the stack is
// strictly larger than the box above it in width, height, and
// depth. Implement a method to compute the height of the tallest
// possible stack. The height of a stack is the sum of the heights of
// each box.
//
// I've implemented slightly different problem, because I found it in
// leetcode and I wanted to test my solution against a judge.
//
// https://leetcode.com/problems/maximum-height-by-stacking-cuboids/

package main

import (
	"fmt"
	"sort"
)

func main() {
	cuboids := [][]int{
		//{38, 25, 45},
		//{76, 35, 3},

		{36, 46, 41},
		{15, 100, 100},
		{75, 91, 59},
		{13, 82, 6},
	}

	fmt.Println(maxHeight(cuboids))

	printcubes(cuboids)
}

func maxHeight(cuboids [][]int) int {
	for _, cube := range cuboids {
		sort.Ints(cube)
	}

	sort.Slice(cuboids, func(i, j int) bool {
		// reverse
		if cuboids[i][2] != cuboids[j][2] {
			return cuboids[i][2] > cuboids[j][2]
		}
		if cuboids[i][1] != cuboids[j][1] {
			return cuboids[i][1] > cuboids[j][1]
		}
		return cuboids[i][0] > cuboids[j][0]
	})

	var max int
	for i := 0; i < len(cuboids); i++ {
		h := findMaxHeight(cuboids, i)
		if h > max {
			max = h
		}
	}

	return max
}

func findMaxHeight(cuboids [][]int, bottom int) int {
	var max int
	for i := bottom + 1; i < len(cuboids); i++ {
		if compareCubes(cuboids[bottom], cuboids[i]) == -1 {
			if h := findMaxHeight(cuboids, i); h > max {
				max = h
			}
		}
	}
	max += cuboids[bottom][2]
	return max
}

func compareCubes(a, b []int) int {
	if a[0] >= b[0] && a[1] >= b[1] && a[2] >= b[2] {
		return -1
	}

	if a[0] < b[0] && a[1] < b[1] && a[2] < b[2] {
		return 1
	}

	return 0
}

func printcubes(cuboids [][]int) {
	for _, c := range cuboids {
		fmt.Println(c)
	}
	fmt.Println(cuboidsHeight(cuboids))
	fmt.Println()
}

func cuboidsHeight(cuboids [][]int) int {
	h := 0
	for _, c := range cuboids {
		h += c[2]
	}
	return h
}
