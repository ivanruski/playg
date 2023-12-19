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
	m, _ := readFileInput("input")

	fmt.Println(sumV1(m))
	fmt.Println(sumV2(m))
}

func sumV1(m [][]int) int {
	return leastHeat(m, 0, 3)
}

func sumV2(m [][]int) int {
	return leastHeat(m, 4, 10)
}

type node[T any] struct {
	value T
	next  *node[T]
}

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

type cell struct {
	row, col, dir, dircnt int
}

const (
	left = iota
	right
	down
	up
)

func leastHeat(m [][]int, minstreak, maxstreak int) int {
	visited := map[cell]int{}

	s := cell{col: 0, row: 0}
	s1 := cell{col: 1, row: 0, dir: right, dircnt: 1}
	s2 := cell{col: 0, row: 1, dir: down, dircnt: 1}
	visited[s] = 0

	// with priority queue will be faster
	q := queue[cell]{}
	q.push(s1)
	q.push(s2)
	visited[s1] = m[s1.row][s1.col]
	visited[s2] = m[s2.row][s2.col]

	for !q.empty() {
		c := q.pop()

		next := []cell{}
		switch c.dir {
		case right, left:
			if c.dircnt < maxstreak {
				d := 1
				if c.dir == left {
					d = -1
				}

				next = append(next, cell{col: c.col + d, row: c.row, dir: c.dir, dircnt: c.dircnt + 1})
			}

			if c.dircnt >= minstreak {
				next = append(next, cell{col: c.col, row: c.row + 1, dir: down, dircnt: 1}) // down
				next = append(next, cell{col: c.col, row: c.row - 1, dir: up, dircnt: 1})   // up
			}

		case down, up:
			if c.dircnt < maxstreak {
				d := 1
				if c.dir == up {
					d = -1
				}

				next = append(next, cell{col: c.col, row: c.row + d, dir: c.dir, dircnt: c.dircnt + 1})
			}

			if c.dircnt >= minstreak {
				next = append(next, cell{col: c.col - 1, row: c.row, dir: left, dircnt: 1})  // left
				next = append(next, cell{col: c.col + 1, row: c.row, dir: right, dircnt: 1}) // right
			}
		}

		for _, n := range next {
			if n.row < 0 || n.row >= len(m) || n.col < 0 || n.col >= len(m[0]) {
				continue
			}

			if val, ok := visited[n]; !ok || val > visited[c]+m[n.row][n.col] {
				visited[n] = visited[c] + m[n.row][n.col]
				q.push(n)
			}
		}
	}

	ways := []int{}
	for k, v := range visited {
		if k.row == len(m)-1 && k.col == len(m[0])-1 && k.dircnt >= minstreak {
			ways = append(ways, v)
		}
	}

	sort.Ints(ways)
	return ways[0]
}

func readFileInput(filename string) ([][]int, error) {
	data, err := os.ReadFile(filename)
	if err != nil {
		return nil, err
	}

	scanner := bufio.NewScanner(bytes.NewReader(data))
	scanner.Split(bufio.ScanLines)

	res := [][]int{}
	for scanner.Scan() {
		line := scanner.Text()

		nums := []int{}
		for _, num := range strings.Split(line, "") {
			n, err := strconv.Atoi(num)
			if err != nil {
				panic(fmt.Sprintf("parsing %q: %s", num, err))
			}

			nums = append(nums, n)
		}

		res = append(res, nums)
	}

	return res, nil
}
