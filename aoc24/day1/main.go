package main

import (
	"bufio"
	"bytes"
	"fmt"
	"os"
	"sort"
	"strconv"
	"strings"
)

func main() {
	left, right, _ := readInput()
	fmt.Println(computeSimilarity(left, right))
}

func computeDistance(left, right []int) int {
	sort.Ints(left)
	sort.Ints(right)

	d := 0
	for i := 0; i < len(left); i++ {
		d += abs(left[i] - right[i])
	}

	return d
}

func computeSimilarity(left, right []int) int {
	m := map[int]int{}
	for _, n := range right {
		m[n]++
	}

	s := 0
	for _, n := range left {
		s += (n * m[n])
	}

	return s
}

func readInput() ([]int, []int, error) {
	data, err := os.ReadFile("input2")
	if err != nil {
		return nil, nil, fmt.Errorf("reading input: %w", err)
	}

	scanner := bufio.NewScanner(bytes.NewReader(data))
	scanner.Split(bufio.ScanLines)

	left, right := []int{}, []int{}
	for scanner.Scan() {
		line := scanner.Text()
		l, r, _ := strings.Cut(line, " ")
		r = strings.TrimSpace(r)

		ln, _ := strconv.Atoi(l)
		rn, _ := strconv.Atoi(r)

		left = append(left, ln)
		right = append(right, rn)
	}

	return left, right, nil
}

func abs(i int) int {
	if i < 0 {
		return -i
	}

	return i
}
