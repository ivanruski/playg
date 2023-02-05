// Intersection: Given two straight line segments (represented as a start point
// and an end point), compute the point of intersection, if any.

package main

import (
	"fmt"
	"math"
)

func main() {
	l1 := line{point{100, 0}, point{100, 0}}

	fmt.Println(l1.slope())

	l2 := line{point{100, 0}, point{100, 20}}

	ix, ok := findIntersection(l1, l2)

	if !ok {
		fmt.Println("Prallel")
	} else {
		fmt.Println(ix)
	}
}

// findIntersection computes the intersection of two lines.
//
// The returned boolean indicates whether the two lines intersect.
func findIntersection(l1, l2 line) (point, bool) {
	var (
		s1 = l1.slope()
		s2 = l2.slope()
	)

	// one could be +Inf and the other -Inf
	if s1 == s2 ||
		math.IsNaN(s1) ||
		math.IsNaN(s2) ||
		(math.IsInf(s1, 0) && math.IsInf(s2, 0)) {
		return point{}, false
	}

	var (
		b1 = bCoef(s1, l1[0])
		b2 = bCoef(s2, l2[0])

		x = (b2 - b1) / (s1 - s2)
		y = (s1 * x) + b1
	)

	if math.IsInf(s2, 0) {
		x = l2[0][0]
		y = (s1 * x) + b1
	}

	if math.IsInf(s1, 0) {
		x = l1[0][0]
		y = (s2 * x) + b2
	}

	return point{x, y}, true
}

type point [2]float64

type line [2]point

func (l line) slope() float64 {
	var (
		p1 = l[0]
		p2 = l[1]

		x1 = p1[0]
		y1 = p1[1]

		x2 = p2[0]
		y2 = p2[1]
	)

	return (y2 - y1) / (x2 - x1)
}

func bCoef(slope float64, p point) float64 {
	// b = y - mx
	return p[1] - (slope * p[0])
}
