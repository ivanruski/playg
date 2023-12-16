package main

import (
	"bufio"
	"bytes"
	"fmt"
	"os"
	"strings"
)

func main() {
	m, _ := readFileInput("input")

	fmt.Println(sumV1(m))
	fmt.Println(sumV2(m))
}

func sumV1(m [][]string) int {
	var l = len(m)
	var sum int
	for j := 0; j < len(m[0]); j++ {
		nextEmpty := 0
		for i := 0; i < len(m); i++ {
			if m[i][j] == "O" {
				sum += (l - nextEmpty)
				nextEmpty++
			}
			if m[i][j] == "#" {
				nextEmpty = i + 1
			}
		}
	}

	return sum
}

type pattern struct {
	start int
	end   int
}

func (p pattern) diff() int {
	return p.end - p.start
}

// cycle N times see what is the longest pattern of sums, then find which value
// from that pattern will be at 1_000_000_000.
func sumV2(m [][]string) int {
	patterns, sums := collectPatterns(m)

	var max pattern
	for _, p := range patterns {
		if max.diff() < p.diff() {
			max = p
		}
	}

	x := 1_000_000_000 - max.start
	y := x / max.diff()
	z := x - (y * max.diff())

	return sums[max.start+z-1]
}

func collectPatterns(m [][]string) ([]pattern, []int) {
	patterns := map[int][]pattern{}
	sums := []int{}

	for cnt := 1; cnt <= 1_000; cnt++ {
		cycle(m)

		var sum int
		for i := 0; i < len(m); i++ {
			c := 0
			for j := 0; j < len(m[0]); j++ {
				if m[i][j] == "O" {
					c++
				}
			}

			sum += (len(m) - i) * c
		}

		sums = append(sums, sum)
		ps, ok := patterns[sum]
		if !ok {
			patterns[sum] = []pattern{
				{start: cnt},
			}
		} else {
			// check if we are beginning a new patter
			// or we've found the end of one
			found := false
			for i, p := range ps {
				if p.end == 0 {
					p.end = cnt
					ps[i] = p
					found = true
					break
				}
			}

			if !found {
				ps = append(ps, pattern{start: cnt})
				patterns[sum] = ps
			}
		}
	}

	set := map[int]pattern{}
	for _, ps := range patterns {
		for _, p := range ps {
			if p.end != 0 {
				if _, ok := set[p.diff()]; !ok {
					// this will be the first occurance of the pattern
					set[p.diff()] = p
				}
			}
		}
	}

	var res []pattern
	for _, p := range set {
		res = append(res, p)
	}

	return res, sums
}

func cycle(m [][]string) {
	tiltNorth(m)
	tiltWest(m)
	tiltSouth(m)
	tiltEast(m)
}

func tiltNorth(m [][]string) {
	for j := 0; j < len(m[0]); j++ {
		nextEmpty := 0
		for i := 0; i < len(m); i++ {
			if m[i][j] == "O" {
				if nextEmpty != i {
					m[nextEmpty][j] = "O"
					m[i][j] = "."
				}

				nextEmpty++
			}
			if m[i][j] == "#" {
				nextEmpty = i + 1
			}
		}
	}
}

func tiltSouth(m [][]string) {
	for j := 0; j < len(m[0]); j++ {
		nextEmpty := len(m) - 1
		for i := len(m) - 1; i >= 0; i-- {
			if m[i][j] == "O" {
				if nextEmpty != i {
					m[nextEmpty][j] = "O"
					m[i][j] = "."
				}

				nextEmpty--
			}
			if m[i][j] == "#" {
				nextEmpty = i - 1
			}
		}
	}
}

func tiltWest(m [][]string) {
	for i := 0; i < len(m); i++ {
		nextEmpty := 0
		for j := 0; j < len(m[0]); j++ {
			if m[i][j] == "O" {
				if nextEmpty != j {
					m[i][nextEmpty] = "O"
					m[i][j] = "."
				}

				nextEmpty++
			}
			if m[i][j] == "#" {
				nextEmpty = j + 1
			}
		}
	}
}

func tiltEast(m [][]string) {
	for i := 0; i < len(m); i++ {
		nextEmpty := len(m[0]) - 1
		for j := len(m[0]) - 1; j >= 0; j-- {
			if m[i][j] == "O" {
				if nextEmpty != j {
					m[i][nextEmpty] = "O"
					m[i][j] = "."
				}

				nextEmpty--
			}
			if m[i][j] == "#" {
				nextEmpty = j - 1
			}
		}
	}
}

func readFileInput(filename string) ([][]string, error) {
	data, err := os.ReadFile(filename)
	if err != nil {
		return nil, err
	}

	scanner := bufio.NewScanner(bytes.NewReader(data))
	scanner.Split(bufio.ScanLines)

	var res [][]string

	for scanner.Scan() {
		line := scanner.Text()

		res = append(res, strings.Split(line, ""))
	}

	return res, nil
}
