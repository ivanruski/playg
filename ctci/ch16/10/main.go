// Living People: Given a list of people with their birth and death
// years, implement a method to compute the year with the most number
// of people alive. You may assume that all people were born between
// 1900 and 2000 (inclusive). If aperson was alive during any portion
// of that year, they should be included in that year's count. For
// example. Person (birth = 1908, death = 1909) is included in the
// counts for both 1908 and 1909.
//
// https://leetcode.com/problems/maximum-population-year/

package main

func main() {
}

func maximumPopulation(logs [][]int) int {
	years := make([]int, 101)
	for _, l := range logs {
		born := l[0]
		died := l[1]
		for i := born; i < died; i++ {
			years[i-1950]++
		}
	}

	var max, year int
	for i, y := range years {
		if max < y {
			max = y
			year = 1950 + i
		}
	}

	return year
}

// I didn't came up with the idea by myself
func maximumPopulation2(logs [][]int) int {
	years := make([]int, 101)
	for _, l := range logs {
		born := l[0] - 1950
		died := l[1] - 1950
		years[born]++
		years[died]--

	}

	var max, year = years[0], 0
	for i := 1; i < 101; i++ {
		years[i] += years[i-1]
		if years[i-1] > max {
			max = years[i-1]
			year = i-1
		}
	}

	return year + 1950
}
