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
	m, _ := readFileInput("input")

	fmt.Println(sumV2(m))
}

func sumV1(m [][]int) int {
	var sum int
	for _, nums := range m {
		sum += findNextNum(nums)
	}

	return sum
}

func sumV2(m [][]int) int {
	var sum int
	for _, nums := range m {
		sum += findFirstNum(nums)
	}

	return sum
}

func findFirstNum(nums []int) int {
	if isDiffConstant(nums) {
		d := nums[1] - nums[0]
		newFirst := nums[0] - d
		return newFirst
	}

	diffs := make([]int, 0, len(nums)-1)
	for i := 1; i < len(nums); i++ {
		diffs = append(diffs, nums[i]-nums[i-1])
	}

	num := findFirstNum(diffs)
	first := nums[0]
	return first - num
}

func findNextNum(nums []int) int {
	if isDiffConstant(nums) {
		d := nums[1] - nums[0]
		last := nums[len(nums)-1]
		return last + d
	}

	diffs := make([]int, 0, len(nums)-1)
	for i := 1; i < len(nums); i++ {
		diffs = append(diffs, nums[i]-nums[i-1])
	}

	num := findNextNum(diffs)
	last := nums[len(nums)-1]
	return last + num
}

func isDiffConstant(nums []int) bool {
	for i := 1; i < len(nums)-1; i++ {
		prev := nums[i-1]
		curr := nums[i]
		next := nums[i+1]

		if curr-prev != next-curr {
			return false
		}
	}

	return true
}

func readFileInput(filename string) ([][]int, error) {
	data, err := os.ReadFile(filename)
	if err != nil {
		return nil, err
	}

	scanner := bufio.NewScanner(bytes.NewReader(data))
	scanner.Split(bufio.ScanLines)

	matrix := [][]int{}
	for scanner.Scan() {
		line := scanner.Text()
		ns := strings.Split(line, " ")
		nums := []int{}
		for _, n := range ns {
			num, err := strconv.Atoi(n)
			if err != nil {
				panic(fmt.Sprintf("parsing %q: %s", n, err))
			}

			nums = append(nums, num)
		}

		matrix = append(matrix, nums)
	}

	return matrix, nil
}
