package main

import (
	"bufio"
	"bytes"
	"fmt"
	"os"
	"slices"
	"strconv"
	"strings"
)

// https://adventofcode.com/2025/day/9
func main() {
	coords, _ := readInput()
	fmt.Println(findLargestRect(coords))
	fmt.Println(findLargestRect2(coords))
}

type point struct {
	x, y int
}

func findLargestRect(coords []point) int {
	max := 0
	for i := 0; i < len(coords); i++ {
		for j := i + 1; j < len(coords); j++ {
			p1 := coords[i]
			p2 := coords[j]

			if a := calcArea(p1, p2); a > max {
				max = a
			}
		}
	}

	return max
}

// EXTREMELY SLOW!
func findLargestRect2(coords []point) int {
	max := 0
	for i := 0; i < len(coords); i++ {
		for j := i + 1; j < len(coords); j++ {
			p1 := coords[i]
			p2 := coords[j]

			if a := calcArea(p1, p2); a > max {
				if isRectValid(p1, p2, coords) {
					max = a
				}
			}
		}
	}

	return max
}

func isRectValid(p1, p2 point, coords []point) bool {
	if p1.x == p2.x {
		if p1.y > p2.y {
			p1, p2 = p2, p1
		}

		for y := p1.y; y <= p2.y; y++ {
			if !pointInPolygon(point{p1.x, y}, coords) {
				return false
			}
		}

	} else if p1.y == p2.y {
		if p1.x > p2.x {
			p1, p2 = p2, p1
		}

		for x := p1.x; x <= p2.x; x++ {
			if !pointInPolygon(point{x, p1.y}, coords) {
				return false
			}
		}

	} else {

		var (
			topLeft     point
			topRight    point
			bottomLeft  point
			bottomRight point
		)

		p3 := point{p1.x, p2.y}
		p4 := point{p2.x, p1.y}

		rectEdges := []point{p1, p2, p3, p4}
		// top left -> smallest x, y
		// bottom left -> smaller x, larger y
		// top right -> larger x, smaller y
		// bottom right -> larger x, larger y
		slices.SortFunc(rectEdges, func(a, b point) int {
			if a.x < b.x {
				return -1
			} else if a.x == b.x {
				if a.y < b.y {
					return -1
				} else if a.y == b.y {
					return 0
				}
				return 1
			}

			return 1
		})

		topLeft = rectEdges[0]
		bottomLeft = rectEdges[1]
		topRight = rectEdges[2]
		bottomRight = rectEdges[3]

		for y := topLeft.y; y <= bottomLeft.y; y++ {
			if !pointInPolygon(point{topLeft.x, y}, coords) {
				return false
			}

			if !pointInPolygon(point{bottomRight.x, y}, coords) {
				return false
			}
		}
		for x := topLeft.x; x <= topRight.x; x++ {
			if !pointInPolygon(point{x, topLeft.y}, coords) {
				return false
			}

			if !pointInPolygon(point{x, bottomLeft.y}, coords) {
				return false
			}
		}
	}

	return true
}

func pointInPolygon(p point, poly []point) bool {
	crosses := 0
	n := len(poly)
	for i := 0; i < n; i++ {
		a := poly[i]
		b := poly[(i+1)%n]

		if pointOnSegment(p, a, b) {
			return true
		}

		if rayIntersectsSegmentRight(p, a, b) {
			crosses++
		}
	}
	return crosses%2 == 1
}

func rayIntersectsSegmentRight(p, a, b point) bool {
	if a.y == b.y {
		return false
	}

	if a.y > b.y {
		a, b = b, a
	}

	if p.y < a.y || p.y >= b.y {
		return false
	}

	py := float64(p.y)
	xInt := float64(a.x) + (py-float64(a.y))*float64(b.x-a.x)/float64(b.y-a.y)

	return xInt > float64(p.x)
}

func pointOnSegment(p, a, b point) bool {
	if a.x == b.x {
		if a.y > b.y {
			a, b = b, a
		}

		return p.x == a.x &&
			a.y <= p.y &&
			p.y <= b.y
	}

	if a.y == b.y {
		if a.x > b.x {
			a, b = b, a
		}

		return p.y == a.y &&
			a.x <= p.x &&
			p.x <= b.x
	}

	// no diagonals in day9's shape
	// should never happen
	panic("diagonal")
}

func calcArea(p1, p2 point) int {
	a := abs(p2.x-p1.x) + 1
	b := abs(p2.y-p1.y) + 1
	return a * b
}

func abs(x int) int {
	if x < 0 {
		return -x
	}

	return x
}

func readInput() ([]point, error) {
	b, err := os.ReadFile("input.txt")
	if err != nil {
		return nil, err
	}

	scanner := bufio.NewScanner(bytes.NewReader(b))
	scanner.Split(bufio.ScanLines)

	coords := []point{}
	for scanner.Scan() {
		xstr, ystr, _ := strings.Cut(scanner.Text(), ",")
		x, _ := strconv.Atoi(xstr)
		y, _ := strconv.Atoi(ystr)

		coords = append(coords, point{x, y})
	}

	return coords, nil
}
