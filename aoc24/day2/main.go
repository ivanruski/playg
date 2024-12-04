package main

import (
	"bufio"
	"bytes"
	"fmt"
	"os"
	"strconv"
	"strings"
)

func main() {
	reports, _ := readInput()
	fmt.Println(countSafeReports(reports))
}

func countSafeReports(reports [][]int) int {
	cnt := 0
	for _, report := range reports {
		//if isSafe(report) {
		if isSafe2(report) {
			cnt++
		}
	}

	return cnt
}

func isSafe(report []int) bool {
	if len(report) < 2 {
		return true
	}

	asc := report[0] < report[1]
	for i := 1; i < len(report); i++ {
		prev := report[i-1]
		curr := report[i]
		if asc {
			if prev < curr && curr-prev >= 1 && curr-prev <= 3 {
				continue
			}

			return false
		} else {
			if prev > curr && prev-curr >= 1 && prev-curr <= 3 {
				continue
			}

			return false
		}
	}

	return true
}

func isSafe2(report []int) bool {
	return recur(0, 1, 0, true, report) ||
		recur(0, 1, 0, false, report)
}

func recur(ci, ni, skipped int, asc bool, report []int) bool {
	if skipped > 1 {
		return false
	}
	if ni >= len(report) {
		return skipped < 2
	}

	c := report[ci]
	n := report[ni]
	if areElementsSafe(c, n, asc) {
		// move on
		return recur(ni, ni+1, skipped, asc, report)
	}

	// try skipping n
	sf := recur(ci, ni+1, skipped+1, asc, report)
	if !sf {
		// try skipping c
		if ci == 0 {
			sf = recur(ni, ni+1, skipped+1, asc, report)
		} else {
			sf = recur(ci-1, ni, skipped+1, asc, report)
		}
	}

	return sf
}

func areElementsSafe(c, n int, asc bool) bool {
	if asc {
		return n-c >= 1 && n-c <= 3
	}

	return c-n >= 1 && c-n <= 3
}

func readInput() ([][]int, error) {
	data, err := os.ReadFile("input2")
	if err != nil {
		return nil, fmt.Errorf("reading input: %w", err)
	}

	scanner := bufio.NewScanner(bytes.NewReader(data))
	scanner.Split(bufio.ScanLines)

	reports := [][]int{}
	for scanner.Scan() {
		line := scanner.Text()
		levels := strings.Split(line, " ")

		report := make([]int, 0, len(levels))
		for _, l := range levels {
			n, _ := strconv.Atoi(l)
			report = append(report, n)
		}

		reports = append(reports, report)
	}

	return reports, nil
}
