package main

import (
	"bufio"
	"bytes"
	"fmt"
	"os"
)

type pattern [][]rune

func main() {
	ps, _ := readFileInput("input")

	fmt.Println(sumV1(ps))
	fmt.Println(sumV2(ps))
}

func sumV1(patterns []pattern) int {
	var rows []int
	var cols []int
	for _, p := range patterns {
		if x := findVertReflectionV1(p); x != -1 {
			cols = append(cols, x)
		}
		if x := findHorizReflectionV1(p); x != -1 {
			rows = append(rows, x)
		}
	}

	var sum int
	for _, r := range rows {
		sum += (r * 100)
	}

	for _, c := range cols {
		sum += c
	}

	return sum
}

func findVertReflectionV1(p pattern) int {
OUTER:
	for j := 1; j < len(p[0]); j++ {
		c1 := j - 1
		c2 := j
		if diffCols(p, c1, c2) == 0 {
			for {
				c1 = c1 - 1
				c2 = c2 + 1
				if c1 < 0 || c2 >= len(p[0]) {
					break
				}

				if diffCols(p, c1, c2) > 0 {
					continue OUTER
				}
			}

			return j
		}
	}

	return -1
}

func findHorizReflectionV1(p pattern) int {
OUTER:
	for i := 1; i < len(p); i++ {
		r1 := i - 1
		r2 := i
		if diffRows(p, r1, r2) == 0 {
			for {
				r1 = r1 - 1
				r2 = r2 + 1

				if r1 < 0 || r2 >= len(p) {
					break
				}

				if diffRows(p, r1, r2) > 0 {
					continue OUTER
				}
			}

			return i
		}
	}

	return -1
}

func sumV2(patterns []pattern) int {
	var rows []int
	var cols []int
	for _, p := range patterns {
		if x := findHorizReflectionV2(p); x != -1 {
			rows = append(rows, x)
		}
		if x := findVertReflectionV2(p); x != -1 {
			cols = append(cols, x)
		}
	}

	var sum int
	for _, r := range rows {
		sum += (r * 100)
	}

	for _, c := range cols {
		sum += c
	}

	return sum
}

func findHorizReflectionV2(p pattern) int {
OUTER:
	for i := 1; i < len(p); i++ {
		r1 := i - 1
		r2 := i
		d := diffRows(p, r1, r2)
		var smudge bool
		if d <= 1 {
			if d == 1 {
				smudge = true
			}

			for {
				r1 = r1 - 1
				r2 = r2 + 1

				if r1 < 0 || r2 >= len(p) {
					break
				}

				d := diffRows(p, r1, r2)
				if d > 1 {
					continue OUTER
				}
				if d == 1 {
					if !smudge {
						smudge = true
					} else {
						continue OUTER
					}
				}
			}

			if smudge {
				return i
			}
		}
	}

	return -1
}

func findVertReflectionV2(p pattern) int {
OUTER:
	for j := 1; j < len(p[0]); j++ {
		c1 := j - 1
		c2 := j
		d := diffCols(p, c1, c2)
		var smudge bool
		if d <= 1 {
			if d == 1 {
				smudge = true
			}

			for {
				c1 = c1 - 1
				c2 = c2 + 1
				if c1 < 0 || c2 >= len(p[0]) {
					break
				}

				d := diffCols(p, c1, c2)
				if d > 1 {
					continue OUTER
				}
				if d == 1 {
					if !smudge {
						smudge = true
					} else {
						continue OUTER
					}
				}
			}

			if smudge {
				return j
			}
		}
	}

	return -1
}

func diffCols(p pattern, c1, c2 int) int {
	var cnt int
	for i := 0; i < len(p); i++ {
		if p[i][c1] != p[i][c2] {
			cnt++
		}
	}

	return cnt
}

func diffRows(p pattern, r1, r2 int) int {
	var cnt int
	for j := 0; j < len(p[0]); j++ {
		if p[r1][j] != p[r2][j] {
			cnt++
		}
	}

	return cnt
}

func readFileInput(filename string) ([]pattern, error) {
	data, err := os.ReadFile(filename)
	if err != nil {
		return nil, err
	}

	scanner := bufio.NewScanner(bytes.NewReader(data))
	scanner.Split(bufio.ScanLines)

	var patterns []pattern
	var pattern pattern
	for scanner.Scan() {
		line := scanner.Text()
		if line == "" {
			patterns = append(patterns, pattern)
			pattern = nil
			continue
		}

		pattern = append(pattern, []rune(line))
	}

	patterns = append(patterns, pattern)

	return patterns, nil
}
