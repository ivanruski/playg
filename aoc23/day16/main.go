package main

import (
	"bufio"
	"bytes"
	"fmt"
	"os"
	"strings"
)

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

func main() {
	m, _ := readFileInput("input")

	fmt.Println(countV1(m, beam{dir: ">", r: 0, c: 0}))
	fmt.Println(countV2(m))
}

type beam struct {
	dir  string
	r, c int
}

func countV2(m [][]string) int {
	ways := []beam{}

	for j := 1; j < len(m[0])-1; j++ {
		ways = append(ways, beam{dir: "v", r: 0, c: j})
		ways = append(ways, beam{dir: "^", r: len(m) - 1, c: j})
	}

	for i := 1; i < len(m)-1; i++ {
		ways = append(ways, beam{dir: ">", r: i, c: 0})
		ways = append(ways, beam{dir: "<", r: i, c: len(m[0]) - 1})
	}

	ways = append(ways, beam{dir: ">", r: 0, c: 0})
	ways = append(ways, beam{dir: "v", r: 0, c: 0})

	ways = append(ways, beam{dir: "<", r: 0, c: len(m[0]) - 1})
	ways = append(ways, beam{dir: "v", r: 0, c: len(m[0]) - 1})

	ways = append(ways, beam{dir: ">", r: len(m) - 1, c: 0})
	ways = append(ways, beam{dir: "^", r: len(m) - 1, c: 0})

	ways = append(ways, beam{dir: "<", r: len(m) - 1, c: len(m[0]) - 1})
	ways = append(ways, beam{dir: "^", r: len(m) - 1, c: len(m[0]) - 1})

	var max int
	for _, w := range ways {
		c := countV1(m, w)
		if c > max {
			max = c
		}
	}

	return max
}

func countV1(m [][]string, start beam) int {
	//enrg := [][]bool{}
	//for i := 0; i < len(m); i++ {
	//	enrg = append(enrg, make([]bool, len(m[0])))
	//}
	enrg := map[beam]bool{}

	q := &queue[beam]{}
	q.push(start)

	for !q.empty() {
		b := q.pop()
		r, c := b.r, b.c

		if r < 0 || r >= len(m) || c < 0 || c >= len(m[0]) {
			continue
		}
		if enrg[b] {
			continue
		}

		enrg[b] = true

		switch b.dir {
		case ">":
			switch m[r][c] {
			case ".", "-":
				q.push(beam{dir: ">", r: r, c: c + 1})
			case "|":
				q.push(beam{dir: "^", r: r - 1, c: c})
				q.push(beam{dir: "v", r: r + 1, c: c})
			case "/":
				q.push(beam{dir: "^", r: r - 1, c: c})
			case "\\":
				q.push(beam{dir: "v", r: r + 1, c: c})
			}
		case "v":
			switch m[r][c] {
			case ".", "|":
				q.push(beam{dir: "v", r: r + 1, c: c})
			case "-":
				q.push(beam{dir: "<", r: r, c: c - 1})
				q.push(beam{dir: ">", r: r, c: c + 1})
			case "/":
				q.push(beam{dir: "<", r: r, c: c - 1})
			case "\\":
				q.push(beam{dir: ">", r: r, c: c + 1})
			}
		case "<":
			switch m[r][c] {
			case ".", "-":
				q.push(beam{dir: "<", r: r, c: c - 1})
			case "|":
				q.push(beam{dir: "^", r: r - 1, c: c})
				q.push(beam{dir: "v", r: r + 1, c: c})
			case "/":
				q.push(beam{dir: "v", r: r + 1, c: c})
			case "\\":
				q.push(beam{dir: "^", r: r - 1, c: c})
			}
		case "^":
			switch m[r][c] {
			case ".", "|":
				q.push(beam{dir: "^", r: r - 1, c: c})
			case "-":
				q.push(beam{dir: "<", r: r, c: c - 1})
				q.push(beam{dir: ">", r: r, c: c + 1})
			case "/":
				q.push(beam{dir: ">", r: r, c: c + 1})
			case "\\":
				q.push(beam{dir: "<", r: r, c: c - 1})
			}
		}
	}

	set := map[beam]struct{}{}
	for b := range enrg {
		set[beam{r: b.r, c: b.c}] = struct{}{}
	}

	return len(set)
}

func emptyM(r, c int) [][]string {
	m := make([][]string, r)
	for i := 0; i < r; i++ {
		m[i] = make([]string, c)
		for j := 0; j < c; j++ {
			m[i][j] = "."
		}
	}

	return m
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
