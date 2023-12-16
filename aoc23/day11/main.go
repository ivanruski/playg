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
	g, _ := readFileInput("input")

	fmt.Println(sum(g))
}

func sum(g [][]string) int {
	emptyRows := emptyRowsIndicies(g)
	emptyCols := emptyColsIndicies(g)
	cs := coords(g)
	sum := 0
	for i := 0; i < len(cs); i++ {
		from := cs[i]
		for j := i + 1; j < len(cs); j++ {
			to := cs[j]

			x1, y1 := to[0], to[1]
			x2, y2 := from[0], from[1]

			var emptyRowsCnt, emptyColsCnt int
			for _, er := range emptyRows {
				if x2 < er && er < x1 {
					emptyRowsCnt++
				}
			}

			for _, ec := range emptyCols {
				if y2 < ec && ec < y1 {
					emptyColsCnt++
				} else if y1 < ec && ec < y2 {
					emptyColsCnt++
				}
			}

			// part one
			// var dist = 2
			// part two
			var dist = 1_000_000

			// make x, y further away
			if emptyRowsCnt > 0 {
				x1 += ((emptyRowsCnt * dist) - emptyRowsCnt)
			}
			if emptyColsCnt > 0 {
				if y1 > y2 {
					y1 += ((emptyColsCnt * dist) - emptyColsCnt)
				} else {
					y2 += ((emptyColsCnt * dist) - emptyColsCnt)
				}
			}

			x := x1 - x2
			y := y1 - y2

			if x < 0 {
				x = -x
			}
			if y < 0 {
				y = -y
			}

			sum += x + y
		}
	}

	return sum
}

func emptyRowsIndicies(g [][]string) []int {
	rows := []int{}
	for i, line := range g {
		hasG := false
		for _, c := range line {
			if c != "." {
				hasG = true
				break
			}
		}

		if !hasG {
			rows = append(rows, i)
		}
	}

	return rows
}

func emptyColsIndicies(g [][]string) []int {
	cols := []int{}
	for c := 0; c < len(g[0]); c++ {
		hasG := false
		for r := 0; r < len(g); r++ {
			if g[r][c] != "." {
				hasG = true
				break
			}
		}

		if !hasG {
			cols = append(cols, c)
		}
	}

	return cols
}

func coords(g [][]string) [][]int {
	res := [][]int{}
	for i, line := range g {
		for j, c := range line {
			if c != "." {
				res = append(res, []int{i, j})
			}
		}
	}

	return res
}

func readFileInput(filename string) ([][]string, error) {
	data, err := os.ReadFile(filename)
	if err != nil {
		return nil, err
	}

	scanner := bufio.NewScanner(bytes.NewReader(data))
	scanner.Split(bufio.ScanLines)

	gcnt := 1
	m := [][]string{}
	for scanner.Scan() {
		ls := bufio.NewScanner(strings.NewReader(scanner.Text()))
		ls.Split(bufio.ScanRunes)

		l := []string{}
		for ls.Scan() {
			t := ls.Text()
			if t == "#" {
				t = strconv.Itoa(gcnt)
				gcnt++
			}
			l = append(l, t)
		}

		m = append(m, l)
	}

	return m, nil
}
