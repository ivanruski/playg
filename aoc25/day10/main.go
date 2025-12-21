package main

import (
	"bufio"
	"bytes"
	"fmt"
	"math"
	"os"
	"slices"
	"strconv"
	"strings"
)

func main() {
	diagrams, _ := readInput()

	fmt.Println(analyzeDiagrams(diagrams))
}

func analyzeDiagrams(diagrams []diagram) int {
	var sum int
	for _, d := range diagrams {
		sum += analyzeDiagram(d)
	}

	return sum
}

func analyzeDiagram(diagram diagram) int {
	target := strings.Builder{}
	for _, c := range diagram.lightsTarget {
		target.WriteString(strconv.Itoa(c))
	}

	targetNum, _ := strconv.ParseInt(target.String(), 2, 64)

	buttonWirings := []int{}
	for _, bw := range diagram.buttonWirings {
		bits := make([]int, target.Len())
		for _, n := range bw {
			bits[n] = 1
		}

		pattern := strings.Builder{}
		for _, n := range bits {
			pattern.WriteString(strconv.Itoa(n))
		}

		num, _ := strconv.ParseInt(pattern.String(), 2, 64)
		buttonWirings = append(buttonWirings, int(num))
	}

	type node struct {
		num       int
		vertecies []*node
	}

	ln := math.Pow(2, float64(target.Len()))
	nodes := make([][]int, int(ln))
	for _, bw := range buttonWirings {
		nodes[bw] = make([]int, 0, 4)
	}

	for {
		nodesAdded := 0

		for node, vertices := range nodes {
			if cap(vertices) == 0 {
				continue
			}

			vs := vertices
			for _, bw := range buttonWirings {
				newNode := node ^ bw
				if nodes[newNode] == nil {
					nodes[newNode] = make([]int, 0, 4)
					nodesAdded++
				}
				vs = append(vs, newNode)
			}

			slices.Sort(vs)
			nodes[node] = slices.Compact(vs)
		}

		if nodesAdded == 0 {
			break
		}
	}

	min := math.MaxInt
	for _, bw := range buttonWirings {
		visited := make([]bool, len(nodes))
		memo := make([]int, len(nodes))
		path := 1 + findShortestPathToNum(bw, int(targetNum), nodes, visited, memo)
		if min > path {
			min = path
		}
	}

	return min
}

func findShortestPathToNum(start, target int, nodes [][]int, visited []bool, memo []int) int {
	if visited[start] {
		return math.MaxInt32
	}

	if start == target {
		return 0
	}

	visited[start] = true
	min := math.MaxInt32

	for _, v := range nodes[start] {
		var path int
		if memo[v] != 0 {
			path = 1 + memo[v]
		} else {
			path = 1 + findShortestPathToNum(v, target, nodes, visited, memo)
		}
		if min > path {
			min = path
		}
	}

	memo[start] = min
	visited[start] = false

	return min
}

type diagram struct {
	lightsTarget        []int
	lightsIndicator     []int
	buttonWirings       [][]int
	joltageRequirements []int
}

func readInput() ([]diagram, error) {
	b, err := os.ReadFile("input.txt")
	if err != nil {
		return nil, err
	}

	scanner := bufio.NewScanner(bytes.NewReader(b))
	scanner.Split(bufio.ScanLines)

	var diagrams []diagram
	for scanner.Scan() {
		line := strings.Split(scanner.Text(), " ")

		lights := line[0]
		wirings := line[1 : len(line)-1]
		joltageReqs := line[len(line)-1]

		lt := []int{}
		for _, state := range strings.Trim(lights, "[]") {
			if state == '.' {
				lt = append(lt, 0)
			} else {
				lt = append(lt, 1)
			}
		}

		bw := [][]int{}
		for _, wiring := range wirings {
			w := []int{}
			for _, n := range strings.Split(strings.Trim(wiring, "()"), ",") {
				num, _ := strconv.Atoi(n)
				w = append(w, num)
			}

			bw = append(bw, w)
		}

		jr := []int{}
		for _, r := range strings.Split(strings.Trim(joltageReqs, "{}"), ",") {
			num, _ := strconv.Atoi(r)
			jr = append(jr, num)
		}

		diagrams = append(diagrams, diagram{
			lightsTarget:        lt,
			lightsIndicator:     make([]int, len(lt)),
			buttonWirings:       bw,
			joltageRequirements: jr,
		})
	}

	return diagrams, nil
}
