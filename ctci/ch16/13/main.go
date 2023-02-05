// Bisect Squares: Given two squares on a two-dimensional plane, find
// a line that would cut these two squares in half. Assume that the
// top and the bottom sides of the square run parallel to the x-axis.

package main

import "math"

func main() {
}

type line struct {
	slope float64
	b     float64
}

type square struct {
	a point // a is top-left
	b point // b is top-right
	c point // c is bottom-left
	d point // d is bottom-right
}

func bisectSquares(s1, s2 square) line {
	c1 := squareCenter(s1)
	c2 := squareCenter(s2)

	return lineEquation(c1, c2)
}

type point struct {
	x float64
	y float64
}

func squareCenter(s square) point {
	half := math.Abs(s.a.x-s.b.x) / 2

	x := s.a.x + half
	y := s.a.y - half

	return point{x, y}
}

func lineEquation(p1, p2 point) line {
	var slope, b float64
	if p1.y == p2.y {
		slope = 0
		b = p2.y
	} else if p1.x == p2.x {
		slope = math.MaxFloat64
		b = math.MaxFloat64
	} else {
		slope = (p2.y - p1.y) / (p2.x - p1.x)
		b = p2.y - (slope * p2.x)
	}

	return line{slope: slope, b: b}
}
