package main

import (
	"bufio"
	"bytes"
	"fmt"
	"os"
	"slices"
)

type node[T any] struct {
	value T
	next  *node[T]
}

// TODO: implement circular queue using slice
type queue[T any] struct {
	first *node[T]
	last  *node[T]
}

func (q *queue[T]) push(elem T) {
	n := &node[T]{value: elem}

	if q.first == nil {
		q.first = n
		q.last = n

		return
	}

	q.last.next = n
	q.last = n
}

func (q *queue[T]) pop() T {
	var t T
	if q.first == nil {
		return t
	}

	t = q.first.value
	q.first = q.first.next

	return t
}

func (q *queue[T]) empty() bool {
	return q.first == nil
}

func main() {
	m, _ := readFileInput("input")
	fmt.Println(findSteps(m))
}

type pos struct {
	row, col int
}

func findSteps(m [][]rune) int {
	row, col := findStart(m)
	dists := distsM(len(m), len(m[0]))
	visited := visitedM(len(m), len(m[0]))
	q := &queue[pos]{}

	dists[row][col] = 0
	q.push(pos{row, col})

	for !q.empty() {
		p := q.pop()
		row, col := p.row, p.col
		if visited[row][col] {
			continue
		}
		visited[row][col] = true

		switch m[row][col] {
		case 'S':
			var n, e, s, w bool
			// look north
			if row > 0 && slices.Contains([]rune{'|', '7', 'F'}, m[row-1][col]) {
				q.push(pos{row - 1, col})
				dists[row-1][col] = dists[row][col] + 1

				n = true
			}
			// look east
			if col+1 < len(m[0]) && slices.Contains([]rune{'-', 'J', '7'}, m[row][col+1]) {
				q.push(pos{row, col + 1})
				dists[row][col+1] = dists[row][col] + 1

				e = true
			}
			// look south
			if row+1 < len(m) && slices.Contains([]rune{'|', 'J', 'L'}, m[row+1][col]) {
				q.push(pos{row + 1, col})
				dists[row+1][col] = dists[row][col] + 1

				s = true
			}
			// look west
			if col > 0 && slices.Contains([]rune{'-', 'L', 'F'}, m[row][col-1]) {
				q.push(pos{row, col - 1})
				dists[row][col-1] = dists[row][col] + 1

				w = true
			}

			// determine what is S, needed for part two
			if n && s {
				m[row][col] = '|'
			}
			if n && e {
				m[row][col] = 'L'
			}
			if n && w {
				m[row][col] = 'J'
			}
			if s && e {
				m[row][col] = 'F'
			}
			if s && w {
				m[row][col] = '7'
			}
			if e && w {
				m[row][col] = '-'
			}

			fmt.Println(string(m[row][col]))
		case '|':
			// look north
			if row > 0 && slices.Contains([]rune{'|', '7', 'F'}, m[row-1][col]) && !visited[row-1][col] {
				q.push(pos{row - 1, col})
				dists[row-1][col] = dists[row][col] + 1
			}
			// look south
			if row+1 < len(m) && slices.Contains([]rune{'|', 'J', 'L'}, m[row+1][col]) && !visited[row+1][col] {
				q.push(pos{row + 1, col})
				dists[row+1][col] = dists[row][col] + 1
			}
		case '-':
			// look east
			if col+1 < len(m[0]) && slices.Contains([]rune{'-', 'J', '7'}, m[row][col+1]) && !visited[row][col+1] {
				q.push(pos{row, col + 1})
				dists[row][col+1] = dists[row][col] + 1
			}
			// look west
			if col > 0 && slices.Contains([]rune{'-', 'L', 'F'}, m[row][col-1]) && !visited[row][col-1] {
				q.push(pos{row, col - 1})
				dists[row][col-1] = dists[row][col] + 1
			}
		case 'L':
			// look north
			if row > 0 && slices.Contains([]rune{'|', '7', 'F'}, m[row-1][col]) && !visited[row-1][col] {
				q.push(pos{row - 1, col})
				dists[row-1][col] = dists[row][col] + 1
			}
			// look east
			if col+1 < len(m[0]) && slices.Contains([]rune{'-', 'J', '7'}, m[row][col+1]) && !visited[row][col+1] {
				q.push(pos{row, col + 1})
				dists[row][col+1] = dists[row][col] + 1
			}
		case 'J':
			// look north
			if row > 0 && slices.Contains([]rune{'|', '7', 'F'}, m[row-1][col]) && !visited[row-1][col] {
				q.push(pos{row - 1, col})
				dists[row-1][col] = dists[row][col] + 1
			}
			// look west
			if col > 0 && slices.Contains([]rune{'-', 'L', 'F'}, m[row][col-1]) && !visited[row][col-1] {
				q.push(pos{row, col - 1})
				dists[row][col-1] = dists[row][col] + 1
			}
		case '7':
			// look south
			if row+1 < len(m) && slices.Contains([]rune{'|', 'J', 'L'}, m[row+1][col]) && !visited[row+1][col] {
				q.push(pos{row + 1, col})
				dists[row+1][col] = dists[row][col] + 1
			}
			// look west
			if col > 0 && slices.Contains([]rune{'-', 'L', 'F'}, m[row][col-1]) && !visited[row][col-1] {
				q.push(pos{row, col - 1})
				dists[row][col-1] = dists[row][col] + 1
			}
		case 'F':
			// look south
			if row+1 < len(m) && slices.Contains([]rune{'|', 'J', 'L'}, m[row+1][col]) && !visited[row+1][col] {
				q.push(pos{row + 1, col})
				dists[row+1][col] = dists[row][col] + 1
			}
			// look east
			if col+1 < len(m[0]) && slices.Contains([]rune{'-', 'J', '7'}, m[row][col+1]) && !visited[row][col+1] {
				q.push(pos{row, col + 1})
				dists[row][col+1] = dists[row][col] + 1
			}
		}
	}

	// part one
	max := -1
	for _, ds := range dists {
		for _, d := range ds {
			if max < d {
				max = d
			}
		}
	}
	// return m

	// part two
	var tilesCnt int
	for i := 0; i < len(m); i++ {
		for j := 0; j < len(m[0]); j++ {
			if !visited[i][j] {
				m[i][j] = '.'
			}

			if m[i][j] == 'L' {
				for k := j + 1; k < len(m[0]); k++ {
					if m[i][k] == '-' {
						continue
					}
					if m[i][k] == '7' {
						m[i][k] = '|'
					}
					break
				}
			}

			if j < len(m[0]) && m[i][j] == 'F' {
				for k := j + 1; k < len(m[0]); k++ {
					if m[i][k] == '-' {
						continue
					}
					if m[i][k] == 'J' {
						m[i][k] = '|'
					}
					break
				}
			}
		}

		// count
		var cnt int
		for _, c := range m[i] {
			if c == '|' {
				cnt++
			}
			if c == '.' {
				if cnt%2 == 1 {
					tilesCnt++
				}
			}
		}
	}

	return tilesCnt
}

func getNeighbours(row, col int, m [][]rune) []pos {
	coords := []pos{
		//above
		{row: row - 1, col: col},

		// left
		{row: row, col: col - 1},

		// right
		{row: row, col: col + 1},

		// below
		{row: row + 1, col: col},
	}

	res := []pos{}
	for _, coord := range coords {
		newr := coord.row
		newc := coord.col

		if newr >= 0 && newr < len(m) && newc >= 0 && newc < len(m[0]) {
			res = append(res, pos{newr, newc})
		}
	}

	return res
}

// create matrix which keeps distance to each cell from start
func distsM(rows, cols int) [][]int {
	m := make([][]int, 0, rows)
	for i := 0; i < rows; i++ {
		row := make([]int, cols)
		for j := 0; j < cols; j++ {
			row[j] = -1
		}

		m = append(m, row)
	}

	return m
}

func visitedM(rows, cols int) [][]bool {
	m := make([][]bool, 0, rows)
	for i := 0; i < rows; i++ {
		row := make([]bool, cols)
		m = append(m, row)
	}

	return m
}

func findStart(m [][]rune) (int, int) {
	for row, line := range m {
		for col, c := range line {
			if c == 'S' {
				return row, col
			}
		}
	}

	panic("start not found")
}

func readFileInput(filename string) ([][]rune, error) {
	data, err := os.ReadFile(filename)
	if err != nil {
		return nil, err
	}

	scanner := bufio.NewScanner(bytes.NewReader(data))
	scanner.Split(bufio.ScanLines)

	m := [][]rune{}
	for scanner.Scan() {
		line := scanner.Text()
		m = append(m, []rune(line))
	}

	return m, nil
}
