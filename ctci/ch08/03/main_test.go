package main

import "testing"

func TestMagicIndex(t *testing.T) {
	tests := map[string]struct {
		input []int
		want  int
	}{
		"NegativeOnly": {
			input: []int{-20, -18, -17, -16, -5, -4, -3, -2, -1},
			want:  -1,
		},
		"NegativeAndPossitve": {
			input: []int{-20, -15, -14, -8, 2, 3, 4, 5},
			want:  -1,
		},
		"LastOneIsMagic": {
			input: []int{-20, -15, -14, -8, 2, 3, 4, 5, 6, 7, 10},
			want:  10,
		},
		"ZeroethOneIsMagic": {
			input: []int{0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75},
			want:  0,
		},
		"FirstOneIsMagit": {
			input: []int{-20, 1, 3, 8, 12, 15, 22, 27, 25, 35},
			want:  1,
		},
		"MiddleOneIsMagic": {
			input: []int{-3, -2, -1, 0, 4, 8, 10, 12, 13},
			want:  4,
		},
		"SecondFromTheLastIsMagic": {
			input: []int{-3, -2, -1, 0, 1, 2, 3, 4, 8, 10},
			want:  8,
		},
	}

	for name, test := range tests {
		t.Run(name, func(t *testing.T) {
			got := magicIndex(test.input)
			if got != test.want {
				t.Errorf("got: %d, want: %d", got, test.want)
			}
		})
	}
}

func TestMagicIndexWithDups(t *testing.T) {
	tests := map[string]struct {
		input []int
		want  int
	}{
		"CaseOne": {
			input: []int{-5, -5, -5, 1, 2, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5},
			want:  5,
		},
		"CaseTwo": {
			input: []int{5, 10, 10, 10, 10, 10, 10, 10, 10, 10, 11, 12, 13, 14, 14},
			want:  14,
		},
	}

	for name, test := range tests {
		t.Run(name, func(t *testing.T) {
			got := magicIndexWithDups(test.input)
			if got != test.want {
				t.Errorf("got: %d, want: %d", got, test.want)
			}
		})
	}
}
