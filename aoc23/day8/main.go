package main

import (
	"bufio"
	"bytes"
	"fmt"
	"os"
	"sort"
	"strings"
)

type tuple struct {
	left  string
	right string
}

func main() {
	dirs, m, err := readFileInput("input")
	if err != nil {
		fmt.Printf("%s", err)
		os.Exit(1)
	}

	fmt.Println(countV2(dirs, m))
}

func count(dirs []rune, m map[string]tuple) int {
	var cnt, i int
	node := "AAA"
	for {
		// reset
		if i >= len(dirs) {
			i = 0
		}

		if node == "ZZZ" {
			break
		}

		t := m[node]
		if dirs[i] == 'L' {
			node = t.left
		} else {
			node = t.right
		}

		cnt++
		i++
	}

	return cnt
}

func countV2(dirs []rune, m map[string]tuple) int {
	nodes := []string{}
	for node := range m {
		if strings.HasSuffix(node, "A") {
			nodes = append(nodes, node)
		}
	}

	cnts := []int{}
	for _, n := range nodes {
		var cnt, i int
		node := n
		for {
			if i >= len(dirs) {
				i = 0
			}
			if strings.HasSuffix(node, "Z") {
				break
			}

			t := m[node]
			if dirs[i] == 'L' {
				node = t.left
			} else {
				node = t.right
			}

			cnt++
			i++
		}

		cnts = append(cnts, cnt)
	}

	return findCommonDivisor(cnts)
}

func findCommonDivisor(nums []int) int {
	sort.Ints(nums)

	n := nums[len(nums)-1]
	origN := n
	nums = nums[:len(nums)-1]

	for {
		ok := true
		for _, x := range nums {
			if n%x != 0 {
				ok = false
				break
			}
		}

		if ok {
			break
		}

		n += origN
	}

	return n
}

func terminate(nodes []string) bool {
	for _, n := range nodes {
		if !strings.HasSuffix(n, "Z") {
			return false
		}
	}

	return true
}

func readFileInput(filename string) ([]rune, map[string]tuple, error) {
	data, err := os.ReadFile(filename)
	if err != nil {
		return nil, nil, fmt.Errorf("reading %q: %w", filename, err)
	}

	scanner := bufio.NewScanner(bytes.NewReader(data))
	scanner.Split(bufio.ScanLines)

	scanner.Scan()
	directions := []rune(scanner.Text())

	m := map[string]tuple{}
	for scanner.Scan() {
		line := scanner.Text()
		if line == "" {
			continue
		}

		node, destinations, _ := strings.Cut(line, "=")
		node = strings.Trim(node, " ")
		destinations = strings.Trim(destinations, " ()")
		elements := strings.Split(destinations, ", ")

		m[node] = tuple{left: elements[0], right: elements[1]}
	}

	return directions, m, nil
}
