package main

import (
	"math"
	"testing"
)

func TestSquareCenter(t *testing.T) {
	tests := map[string]struct {
		s    square
		want point
	}{
		"Case1": {
			s: square{
				a: point{0, 5},
				b: point{5, 5},
				c: point{0, 0},
				d: point{5, 0},
			},
			want: point{2.5, 2.5},
		},
		"Case2": {
			s: square{
				a: point{0, 0},
				b: point{5, 0},
				c: point{0, -5},
				d: point{5, -5},
			},
			want: point{2.5, -2.5},
		},
		"Case3": {
			s: square{
				a: point{-5, 5},
				b: point{0, 5},
				c: point{-5, 0},
				d: point{0, 0},
			},
			want: point{-2.5, 2.5},
		},
		"Case4": {
			s: square{
				a: point{-5, 0},
				b: point{0, 0},
				c: point{-5, -5},
				d: point{0, -5},
			},
			want: point{-2.5, -2.5},
		},
	}

	for name, test := range tests {
		t.Run(name, func(t *testing.T) {
			got := squareCenter(test.s)

			if got != test.want {
				t.Errorf("got: %v, want: %v", got, test.want)
			}
		})
	}
}

func TestLineEquation(t *testing.T) {
	tests := map[string]struct {
		p1   point
		p2   point
		want line
	}{
		"Case1": {
			p1:   point{0, 0},
			p2:   point{10, 10},
			want: line{slope: 1, b: 0},
		},
		"Case2": {
			p1:   point{0, 3},
			p2:   point{1, 6},
			want: line{slope: 3, b: 3},
		},
		"Case3": {
			p1:   point{0, -5},
			p2:   point{100, 0},
			want: line{slope: 0.05, b: -5},
		},
		"Case4": {
			p1:   point{-100, 5},
			p2:   point{100, 5},
			want: line{slope: 0, b: 5},
		},
		"Case5": {
			p1:   point{1, 5},
			p2:   point{1, 250},
			want: line{slope: math.MaxFloat64, b: math.MaxFloat64},
		},
	}

	for name, test := range tests {
		t.Run(name, func(t *testing.T) {
			got := lineEquation(test.p1, test.p2)

			if got != test.want {
				t.Errorf("got: %v, want: %v", got, test.want)
			}
		})
	}
}

func TestBisectSquares(t *testing.T) {
	tests := map[string]struct {
		s1   square
		s2   square
		want line
	}{
		"Case1": {
			s1: square{
				a: point{-1, 0},
				b: point{0, 0},
				c: point{-1, -1},
				d: point{0, -1},
			},
			s2: square{
				a: point{3, 5},
				b: point{5, 5},
				c: point{3, 3},
				d: point{5, 3},
			},
			want: line{slope: 1, b: 0},
		},
	}

	for name, test := range tests {
		t.Run(name, func(t *testing.T) {
			got := bisectSquares(test.s1, test.s2)

			if got != test.want {
				t.Errorf("got: %v, want: %v", got, test.want)
			}
		})
	}
}
