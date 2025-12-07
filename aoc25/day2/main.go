package main

import (
	"fmt"
	"log"
	"os"
	"strconv"
	"strings"
)

// https://adventofcode.com/2025/day/2
func main() {
	ranges, err := readInput()
	if err != nil {
		log.Fatal(err)
	}

	fmt.Println(findInvalidIDs(ranges))
	fmt.Println(findInvalidIDsV2(ranges))
}

func findInvalidIDs(ranges [][]int) int {
	sum := 0
	for _, rng := range ranges {
		start := rng[0]
		end := rng[1]
		for i := start; i <= end; i++ {
			str := strconv.Itoa(i)
			if len(str)%2 != 0 {
				continue
			}

			mid := len(str) / 2
			if str[:mid] == str[mid:] {
				sum += i
			}
		}
	}

	return sum
}

func findInvalidIDsV2(ranges [][]int) int {
	sum := 0
	for _, rng := range ranges {
		start := rng[0]
		end := rng[1]
		for i := start; i <= end; i++ {
			str := strconv.Itoa(i)
			for j := 1; j <= len(str)/2; j++ {
				pattern := str[:j]
				rest := str[j:]
				if hasRepeatablePatterns(pattern, rest) {
					sum += i
					break
				}
			}
		}
	}

	return sum
}

func hasRepeatablePatterns(pattern, str string) bool {
	if len(str)%len(pattern) != 0 {
		return false
	}

	for i := 0; i < len(str); i += len(pattern) {
		substr := str[i : i+len(pattern)]
		if pattern != substr {
			return false
		}
	}
	return true
}

func readInput() ([][]int, error) {
	b, err := os.ReadFile("input.txt")
	if err != nil {
		return nil, err
	}

	ranges := strings.Split(string(b), ",")
	result := make([][]int, 0, len(ranges))
	for _, rng := range ranges {
		start, end, _ := strings.Cut(rng, "-")

		s, _ := strconv.Atoi(start)
		e, _ := strconv.Atoi(strings.TrimRight(end, "\n"))

		result = append(result, []int{s, e})
	}

	return result, nil
}
