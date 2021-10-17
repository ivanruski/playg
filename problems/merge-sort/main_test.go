package main

import (
	"reflect"
	"testing"
)

func TestMerge(t *testing.T) {
	tests := map[string]struct {
		nums     []int
		expected []int
	}{
		"mergeCase1": {
			nums:     []int{0, 4, 5, 7, 8, 1, 2, 3, 6, 9},
			expected: []int{0, 1, 2, 3, 4, 5, 6, 7, 8, 9},
		},
		"mergeCase2": {
			nums:     []int{5, 6, 7, 8, 9, 0, 1, 2, 3, 4},
			expected: []int{0, 1, 2, 3, 4, 5, 6, 7, 8, 9},
		},
		"mergeCase3": {
			nums:     []int{0, 2, 4, 6, 8, 1, 3, 5, 7, 9},
			expected: []int{0, 1, 2, 3, 4, 5, 6, 7, 8, 9},
		},
	}

	for name, test := range tests {
		t.Run(name, func(t *testing.T) {
			end := len(test.nums) - 1
			start, mid := 0, end/2
			merge(test.nums, start, mid, end)
			if !reflect.DeepEqual(test.nums, test.expected) {
				t.Errorf("got: %v, want: %v", test.nums, test.expected)
			}
		})
	}
}

func TestMergeSort(t *testing.T) {
	tests := map[string]struct {
		nums     []int
		expected []int
	}{
		"case1": {
			nums:     []int{0, 4, 5, 7, 8, 1, 2, 3, 6, 9},
			expected: []int{0, 1, 2, 3, 4, 5, 6, 7, 8, 9},
		},
		"case2": {
			nums:     []int{5, 6, 7, 8, 9, 0, 1, 2, 3, 4},
			expected: []int{0, 1, 2, 3, 4, 5, 6, 7, 8, 9},
		},
		"case3": {
			nums:     []int{0, 2, 4, 6, 8, 1, 3, 5, 7, 9},
			expected: []int{0, 1, 2, 3, 4, 5, 6, 7, 8, 9},
		},
		"case4": {
			nums:     []int{9, 8, 7, 6, 5, 4, 3, 2, 1, 0},
			expected: []int{0, 1, 2, 3, 4, 5, 6, 7, 8, 9},
		},
	}

	for name, test := range tests {
		t.Run(name, func(t *testing.T) {
			mergeSort(test.nums, 0, len(test.nums)-1)
			if !reflect.DeepEqual(test.nums, test.expected) {
				t.Errorf("got: %v, want: %v", test.nums, test.expected)
			}
		})
	}
}
