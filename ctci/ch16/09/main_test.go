package main

import (
	"math"
	"testing"
)

func FuzzExt(t *testing.F) {
	testcases := [][]int{
		{5, -5},
		{5, -2},
		{5, 2},
		{-5, 2},
		{0, 0},
		{math.MaxInt, math.MinInt},
	}
	for _, tc := range testcases {
		t.Add(tc[0], tc[1])
	}

	t.Fuzz(func(t *testing.T, a, b int) {
		got := ext(a, b)
		want := a - b

		if got != want {
			t.Errorf("for %d - %d, got: %d, want: %d", a, b, got, want)
		}
	})
}

func FuzzDiv(t *testing.F) {
	testcases := [][]int{
		{5, -5},
		{-25, 2},
		{20, 2},
		{-2, -20},
		{38, 1},
	}
	for _, tc := range testcases {
		t.Add(tc[0], tc[1])
	}

	t.Fuzz(func(t *testing.T, a, b int) {
		got := div(a, b)
		var want int
		if b != 0 {
			want = a / b
		}

		if got != want {
			t.Errorf("for %d / %d, got: %d, want: %d", a, b, got, want)
		}
	})
}

func FuzzMul(t *testing.F) {
	testcases := [][]int{
		{5, -5},
		{-25, 2},
		{20, 2},
		{-2, -20},
		{38, 1},
	}
	for _, tc := range testcases {
		t.Add(tc[0], tc[1])
	}

	t.Fuzz(func(t *testing.T, a, b int) {
		got := mul(a, b)
		want := a * b

		if got != want {
			t.Errorf("for %d / %d, got: %d, want: %d", a, b, got, want)
		}
	})
}
