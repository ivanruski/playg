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
	tasks, _ := readFileInput("input")

	fmt.Println(sumV1(tasks))
	fmt.Println(sumV2(tasks))
}

func sumV2(tasks []task) int {
	for i := 0; i < len(tasks); i++ {
		num, _ := strconv.ParseInt(tasks[i].color[1:6], 16, 62)
		tasks[i].steps = int(num)

		switch tasks[i].color[6] {
		case '0':
			tasks[i].dir = "R"
		case '1':
			tasks[i].dir = "D"
		case '2':
			tasks[i].dir = "L"
		case '3':
			tasks[i].dir = "U"
		}
	}

	return sumV1(tasks)
}

func sumV1(tasks []task) int {
	_, _, row, col := lagoonSides(tasks)

	var coords [][]int
	var cnt int
	for _, t := range tasks {
		switch t.dir {
		case "R":
			col += t.steps

		case "L":
			col -= t.steps

		case "D":
			row += t.steps

		case "U":
			row -= t.steps
		}

		cnt += t.steps
		coords = append(coords, []int{col, row})
	}

	coords = append(coords, coords[0])

	//shoelace
	xy := []int{}
	yx := []int{}
	for i := 0; i < len(coords)-1; i++ {
		xy = append(xy, coords[i][0]*coords[i+1][1])
		yx = append(yx, coords[i][1]*coords[i+1][0])
	}

	var xysum, yxsum int
	for i := 0; i < len(xy); i++ {
		xysum += xy[i]
		yxsum += yx[i]
	}

	r := xysum - yxsum
	if r < 0 {
		r = -r
	}
	r += cnt

	return r/2 + 1
}

func lagoonSides(tasks []task) (int, int, int, int) {
	var (
		maxWidth, width     int = 0, 0
		maxHeight, height   int = 0, 0
		minWidth, minHeight int = 0, 0
	)

	for _, t := range tasks {
		switch t.dir {
		case "R":
			width += t.steps
		case "L":
			width -= t.steps

			if minWidth > width {
				minWidth = width
			}
		case "D":
			height += t.steps
		case "U":
			height -= t.steps

			if minHeight > height {
				minHeight = height
			}
		}

		if maxWidth < width {
			maxWidth = width
		}
		if maxHeight < height {
			maxHeight = height
		}
	}

	startRow := -minHeight
	startCol := -minWidth

	return maxWidth - minWidth + 1, maxHeight - minHeight + 1, startRow, startCol
}

type task struct {
	dir, color string
	steps      int
}

func readFileInput(filename string) ([]task, error) {
	data, err := os.ReadFile(filename)
	if err != nil {
		return nil, err
	}

	scanner := bufio.NewScanner(bytes.NewReader(data))
	scanner.Split(bufio.ScanLines)

	tasks := []task{}
	for scanner.Scan() {
		line := scanner.Text()
		s := strings.Split(line, " ")

		n, err := strconv.Atoi(s[1])
		if err != nil {
			panic(fmt.Sprintf("parsing %q: %s", s[1], err))
		}

		tasks = append(tasks, task{
			dir:   s[0],
			steps: n,
			color: strings.Trim(s[2], "()"),
		})
	}

	return tasks, nil
}
