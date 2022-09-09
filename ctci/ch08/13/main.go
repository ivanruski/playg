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

import "fmt"

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

	// fmt.Println(rotateCube([]int{15, 100, 101}))
}

var rotationsMap map[int][][]int

func maxHeight(cuboids [][]int) int {
	var (
		result = new(int)
		used   = make([]int, 0, len(cuboids))
		subset = make([][]int, 0, len(cuboids))
	)

	rotationsMap = make(map[int][][]int, len(cuboids))
	for i := 0; i < len(cuboids); i++ {
		rotationsMap[i] = rotateCube(cuboids[i])
	}

	findMaxHeight(cuboids, subset, used, result)
	return *result
}

func findMaxHeight(cuboids, subset [][]int, used []int, max *int) {
	printcubes(subset)
	if h := cuboidsHeight(subset); h > *max {
		*max = h
	}

	if len(used) == len(cuboids) {
		return
	}

	for i := 0; i < len(cuboids); i++ {
		if isInSlice(i, used) {
			continue
		}
		used := append(used, i)
		rotations := rotationsMap[i]
		for _, rotation := range rotations {
			if len(subset) == 0 || compareCubes(subset[len(subset)-1], rotation) == -1 {
				findMaxHeight(cuboids, append(subset, rotation), used, max)
			}
		}
		used = used[:len(used)-1]
	}
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

func rotateCube(c []int) [][]int {
	mapHasOneKey := func(m map[int]int) bool {
		cnt := 0
		for _, v := range m {
			if v > 0 {
				cnt++
			}
		}
		return cnt == 1
	}

	// permute with dups as some of the dimensions could be equal
	var permute func(map[int]int) [][]int
	permute = func(m map[int]int) [][]int {
		if mapHasOneKey(m) {
			for k, v := range m {
				if v == 0 {
					continue
				}
				r := make([]int, v)
				for i := 0; i < v; i++ {
					r[i] = k
				}
				return [][]int{r}
			}
		}

		result := make([][]int, 0, 4)
		for k, v := range m {
			if v == 0 {
				continue
			}

			m[k]--
			subr := permute(m)
			for _, sr := range subr {
				result = append(result, append(sr, k))
			}
			m[k]++
		}
		return result
	}

	m := map[int]int{}
	for _, num := range c {
		m[num]++
	}
	return permute(m)
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

func isInSlice(x int, nums []int) bool {
	for _, n := range nums {
		if x == n {
			return true
		}
	}
	return false
}
