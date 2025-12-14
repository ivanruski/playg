package main

import (
	"bufio"
	"bytes"
	"fmt"
	"os"
	"strconv"
	"strings"
)

// https://adventofcode.com/2025/day/6
func main() {
	m, _ := readInput()
	fmt.Println(sum(m))
	fmt.Println(sum2(m))
}

func sum(lines []string) int {
	m := [][]string{}
	for _, line := range lines {
		l := []string{}
		for _, x := range strings.Split(line, " ") {
			if x == "" {
				continue
			}

			l = append(l, x)
		}

		m = append(m, l)
	}

	sum := 0
	for c := 0; c < len(m[0]); c++ {
		operator := m[len(m)-1][c]
		nums := []int{}
		for r := 0; r < len(m)-1; r++ {
			num, _ := strconv.Atoi(m[r][c])
			nums = append(nums, num)
		}

		sum += accumulate(operator, nums)
	}

	return sum
}

func sum2(lines []string) int {
	// start from bottom up, because the +/* helps where to know where the
	// column begin
	operands := lines[len(lines)-1]
	var sum, opIdx int
	for opIdx < len(lines[0]) {
		nextOpIdx := strings.IndexAny(operands[opIdx+1:], "+*")
		if nextOpIdx == -1 {
			nextOpIdx = len(lines[0]) + 1
		} else {
			nextOpIdx += opIdx + 1
		}

		operator := string(operands[opIdx])
		nums := []int{}

		for c := opIdx; c < nextOpIdx-1; c++ {
			var numb []byte
			for r := 0; r < len(lines)-1; r++ {
				numb = append(numb, lines[r][c])
			}

			num, _ := strconv.Atoi(strings.TrimSpace(string(numb)))
			nums = append(nums, num)
		}

		sum += accumulate(operator, nums)
		opIdx = nextOpIdx
	}

	return sum
}

func accumulate(operator string, nums []int) int {
	op := add
	result := 0
	if operator == "*" {
		op = mul
		result = 1
	}

	for _, num := range nums {
		result = op(result, num)
	}

	return result
}

func add(a, b int) int {
	return a + b
}

func mul(a, b int) int {
	return a * b
}

func readInput() ([]string, error) {
	b, err := os.ReadFile("input.txt")
	if err != nil {
		return nil, err
	}

	scanner := bufio.NewScanner(bytes.NewReader(b))
	scanner.Split(bufio.ScanLines)

	result := []string{}
	for scanner.Scan() {
		result = append(result, scanner.Text())
	}

	return result, nil
}
