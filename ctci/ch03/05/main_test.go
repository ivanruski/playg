package main

import (
	"testing"
)

func TestSortStack(t *testing.T) {
	// The top of the stack will be the first elem
	createStack := func(input []int) *SetOfStacks {
		ss := NewSetOfStacks(4)
		for i := len(input) - 1; i >= 0; i-- {
			ss.Push(input[i])
		}

		return ss
	}

	tests := map[string]struct {
		input []int
	}{
		"Sorted": {
			input: []int{1, 2, 3, 4, 5, 6, 7, 8, 9, 10},
		},
		"EqNumbers": {
			input: []int{2, 2, 2, 2, 2, 2, 2, 2, 2, 2},
		},
		"SortedDesc": {
			input: []int{10, 9, 8, 7, 6, 5, 4, 3, 2, 1},
		},
		"Random1": {
			input: []int{5, 2, 4, 3, 1, 10, 8, 500, 400, 600},
		},
		"RandomWithNegatives": {
			input: []int{-3, 1, -8, 8, 9, -99, 33, 66, 0},
		},
		"SortedNegatives": {
			input: []int{-10, -9, -8, -7, -6, -5, -4, -3, -2, -1},
		},
		"NegativesSortedDesc": {
			input: []int{-1, -2, -3, -4, -5, -6, -7, -8, -9, -10},
		},
	}

	for name, test := range tests {
		t.Run(name, func(t *testing.T) {
			ss := createStack(test.input)
			SortStack(ss)

			if ss.Size() != len(test.input) {
				t.Fatalf("Stack size is different than input len: got %d want %d", ss.Size(), len(test.input))
			}

			prev, ok := ss.Pop()
			if !ok {
				return
			}

			for ss.Size() > 0 {
				stop, _ := ss.Pop()
				if prev > stop {
					t.Fatalf("the smallest elements are not on top, prev top: %d, top: %d", prev, stop)
				}
				prev = stop
			}
		})
	}
}
