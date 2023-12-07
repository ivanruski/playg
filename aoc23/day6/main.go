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
	times, dists, err := readFileInput("input")
	if err != nil {
		fmt.Printf("error reading file: %s", err)
		os.Exit(1)
	}

	fmt.Println(prodV1(times, dists))
}

// for part two I just changed the input file
func prodV1(times, dists []int) int {
	numofways := []int{}
	for i, timelimit := range times {
		var ways int
		for t := 0; t <= timelimit; t++ {
			d := t * (timelimit - t)

			if d > dists[i] {
				ways++
			}
		}

		numofways = append(numofways, ways)
	}

	prod := 1
	for _, n := range numofways {
		prod *= n
	}

	return prod
}

func readFileInput(filename string) ([]int, []int, error) {
	data, err := os.ReadFile(filename)
	if err != nil {
		return nil, nil, err
	}

	scanner := bufio.NewScanner(bytes.NewReader(data))
	scanner.Split(bufio.ScanLines)

	scanner.Scan()
	line := scanner.Text()
	times := parseNums(line)

	scanner.Scan()
	line = scanner.Text()
	dists := parseNums(line)

	return times, dists, nil
}

func parseNums(line string) []int {
	_, time, _ := strings.Cut(line, ":")
	times := strings.Split(strings.Trim(time, " "), " ")
	nums := make([]int, 0, len(times))
	for _, t := range times {
		if t == "" {
			continue
		}

		n, err := strconv.Atoi(t)
		if err != nil {
			panic(fmt.Sprintf("parsing %q: %s", t, err))
		}

		nums = append(nums, n)
	}

	return nums
}
