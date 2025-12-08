package main

import (
	"bufio"
	"bytes"
	"fmt"
	"os"
	"strconv"
	"strings"
)

// https://adventofcode.com/2025/day/5
func main() {
	ranges, ids, _ := readInput()

	fmt.Println(countFreshIDs(ranges, ids))
	fmt.Println(countFreshIDsRanges(ranges))
}

func countFreshIDs(ranges [][]int, ids []int) int {
	cnt := 0

	for _, id := range ids {
		for _, rng := range ranges {
			from := rng[0]
			to := rng[1]
			if from <= id && id <= to {
				cnt++
				break
			}
		}
	}

	return cnt
}

func countFreshIDsRanges(ranges [][]int) int {
	merged := mergeRanges(ranges)
	sum := 0
	for _, r := range merged {
		sum += r[1] - r[0] + 1
	}

	return sum
}

func mergeRanges(ranges [][]int) [][]int {
	result := [][]int{}
	for {

		for _, rng := range ranges {
			merged := false
			for i, joinedRng := range result {
				newrng, ok := joinIntervals(joinedRng, rng)
				if ok {
					merged = true
					result[i] = newrng
				}
			}

			if !merged {
				result = append(result, rng)
			}
		}

		if len(result) == len(ranges) {
			break
		}

		ranges = result
		result = [][]int{}
	}

	return result
}

func joinIntervals(a, b []int) ([]int, bool) {
	if a[0] > b[0] {
		a, b = b, a
	}

	switch {
	// overlap
	case a[0] <= b[0] && b[0] <= a[1] && a[1] <= b[1]:
		return []int{a[0], b[1]}, true

	// a encloses b
	case a[0] <= b[0] && b[1] <= a[1]:
		return a, true
	}

	return nil, false
}

func readInput() ([][]int, []int, error) {
	b, err := os.ReadFile("input.txt")
	if err != nil {
		return nil, nil, err
	}

	scanner := bufio.NewScanner(bytes.NewReader(b))
	scanner.Split(bufio.ScanLines)

	ranges := [][]int{}
	for scanner.Scan() {
		line := scanner.Text()
		if line == "" {
			break
		}

		from, to, _ := strings.Cut(line, "-")
		f, _ := strconv.Atoi(from)
		t, _ := strconv.Atoi(to)

		ranges = append(ranges, []int{f, t})
	}

	ids := []int{}
	for scanner.Scan() {
		n, _ := strconv.Atoi(scanner.Text())
		ids = append(ids, n)
	}

	return ranges, ids, nil
}
