package main

import (
	"bufio"
	"bytes"
	"fmt"
	"os"
	"strconv"
	"strings"
	"unicode"
)

func main() {
	lines, err := readInputFile("input")
	if err != nil {
		fmt.Printf("reading input: %s\n", err)
		os.Exit(1)
	}

	fmt.Println(sumV2(lines))
}

func sumV1(lines [][]rune) int {
	var sum int
	for row := 0; row < len(lines); row++ {
		for col := 0; col < len(lines[row]); col++ {
			if unicode.IsDigit(lines[row][col]) {
				end := col
				for e := end; e < len(lines[row]); e++ {
					if unicode.IsDigit(lines[row][e]) {
						end = e
						continue
					}
					break
				}

				num := lines[row][col : end+1]

				var addToSum bool
			OUTER:
				for r := row - 1; r < row+2; r++ {
					for i := col - 1; i < end+2; i++ {
						if r < 0 || r >= len(lines) || i < 0 || i >= len(lines[row]) {
							continue
						}

						if isSymbol(lines[r][i]) {
							addToSum = true
							break OUTER
						}
					}
				}
				if addToSum {
					n, err := strconv.Atoi(string(num))
					if err != nil {
						fmt.Println(err, "num:", string(num))
					}
					sum += n
				}

				col = end + 1
			}
		}
	}

	return sum
}

func sumV2(lines [][]rune) int {
	type coord struct {
		row int
		s   int
		e   int
	}

	var sum int
	for row := 0; row < len(lines); row++ {
		for col := 0; col < len(lines[row]); col++ {
			if lines[row][col] != '*' {
				continue
			}

			// extract all adjancent nums to the *

			m := map[coord]struct{}{}
			for r := row - 1; r < row+2; r++ {
				for c := col - 1; c < col+2; c++ {
					if r < 0 || r >= len(lines) || r < 0 || r >= len(lines[row]) {
						continue
					}

					if unicode.IsDigit(lines[r][c]) {
						x, y := extractNum(lines[r], c)
						m[coord{row: r, s: x, e: y}] = struct{}{}
					}
				}
			}

			if len(m) == 2 {
				nums := []int{}
				for c := range m {
					num := lines[c.row][c.s:c.e]
					n, err := strconv.Atoi(string(num))
					if err != nil {
						fmt.Println("error", err, string(num))
					}

					nums = append(nums, n)
				}

				sum += (nums[0] * nums[1])
			}
		}
	}

	return sum
}

func extractNum(line []rune, i int) (int, int) {
	var start, end = i, i
	for s := start; s >= 0; s-- {
		if unicode.IsDigit(line[s]) {
			start = s
		} else {
			break
		}
	}

	for e := end; e < len(line); e++ {
		if unicode.IsDigit(line[e]) {
			end = e
		} else {
			break
		}
	}

	return start, end + 1
}

func isSymbol(s rune) bool {
	return s != '.' && !unicode.IsDigit(s)
}

func readInputFile(filename string) ([][]rune, error) {
	data, err := os.ReadFile(filename)
	if err != nil {
		return nil, err
	}

	scanner := bufio.NewScanner(bytes.NewReader(data))
	scanner.Split(bufio.ScanLines)

	parts := [][]rune{}
	for scanner.Scan() {
		line := scanner.Text()

		ls := bufio.NewScanner(strings.NewReader(line))
		ls.Split(bufio.ScanRunes)

		l := []rune{}
		for ls.Scan() {
			l = append(l, rune(ls.Bytes()[0]))
		}

		parts = append(parts, l)
	}

	return parts, nil
}
