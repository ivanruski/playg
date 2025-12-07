package main

import (
	"bufio"
	"bytes"
	"fmt"
	"os"
	"strconv"
	"strings"
)

// https://adventofcode.com/2025/day/3
func main() {
	nums, _ := readInput()

	fmt.Println(turn2Batteries(nums))
	fmt.Println(turn12Batteries(nums))
}

func turn2Batteries(banks [][]int) int {
	sum := 0
	for _, bank := range banks {
		sum += formJoltage(bank, 2)
	}

	return sum
}

func turn12Batteries(banks [][]int) int {
	sum := 0
	for _, bank := range banks {
		sum += formJoltage(bank, 12)
	}

	return sum
}

func formJoltage(bank []int, length int) int {
	batteries := make([]int, 0, length)
	i := 0
	for len(batteries) < length {
		// Do not search the entire bank, because the largest joltage must allow
		// for subsequent searches
		max, idx := indexOfMax(bank[i : len(bank)-(length-len(batteries)-1)])
		batteries = append(batteries, max)
		// idx is the index of the subslice, we need to shift it by i + 1
		i = idx + i + 1
	}

	return concatenateBatteries(batteries)
}

func indexOfMax(s []int) (int, int) {
	idx := -1
	max := -1
	for i, n := range s {
		if n > max {
			max = n
			idx = i
		}
	}

	return max, idx
}

func concatenateBatteries(s []int) int {
	b := strings.Builder{}
	for _, n := range s {
		b.WriteString(strconv.Itoa(n))
	}

	num, _ := strconv.Atoi(b.String())
	return num
}

func readInput() ([][]int, error) {
	b, err := os.ReadFile("input.txt")
	if err != nil {
		return nil, err
	}

	scanner := bufio.NewScanner(bytes.NewReader(b))
	scanner.Split(bufio.ScanLines)

	result := [][]int{}
	for scanner.Scan() {
		line := scanner.Text()
		nums := []int{}
		for _, r := range line {
			nums = append(nums, int(r-'0'))
		}

		result = append(result, nums)
	}

	return result, nil
}
