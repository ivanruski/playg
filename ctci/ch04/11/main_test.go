package main

import "testing"

func TestDelete(t *testing.T) {
	tests := map[string]struct {
		insert []int

		// elements to delete
		deletes []int
		// whether delete should be successful
		expectedOK []bool

		expectedElements [][]int

		// expected root after a delete
		roots []int
	}{
		"DeleteLeafs": {
			insert:     []int{8, 4, 6, 5, 12, 10, 9, 11, 14, 15},
			deletes:    []int{5, 9, 11, 15, 14},
			expectedOK: []bool{true, true, true, true, true},
			roots:      []int{8, 8, 8, 8, 8},
			expectedElements: [][]int{
				{4, 6, 8, 9, 10, 11, 12, 14, 15},
				{4, 6, 8, 10, 11, 12, 14, 15},
				{4, 6, 8, 10, 12, 14, 15},
				{4, 6, 8, 10, 12, 14},
				{4, 6, 8, 10, 12},
			},
		},
		"DeleteNodesWithRightSubtrees": {
			insert:     []int{8, 4, 6, 5, 12, 10, 9, 11, 14, 15},
			deletes:    []int{4, 14},
			expectedOK: []bool{true, true},
			roots:      []int{8, 8},
			expectedElements: [][]int{
				{5, 6, 8, 9, 10, 11, 12, 14, 15},
				{5, 6, 8, 9, 10, 11, 12, 15},
			},
		},
		"DeleteNodesWithLeftSubtrees": {
			insert:     []int{8, 4, 6, 5, 12, 10, 9, 11},
			deletes:    []int{6, 12},
			expectedOK: []bool{true, true},
			roots:      []int{8, 8},
			expectedElements: [][]int{
				{4, 5, 8, 9, 10, 11, 12},
				{4, 5, 8, 9, 10, 11},
			},
		},
		"DeleteRootWithRightSubtreeOnly": {
			insert:     []int{8, 12, 10, 9, 11, 14, 15},
			deletes:    []int{8},
			expectedOK: []bool{true},
			roots:      []int{12},
			expectedElements: [][]int{
				{9, 10, 11, 12, 14, 15},
			},
		},
		"DeleteRootWithLeftSubtreeOnly": {
			insert:     []int{8, 4, 3, 2},
			deletes:    []int{8, 4, 3, 2},
			expectedOK: []bool{true, true, true, true},
			roots:      []int{4, 3, 2, 0},
			expectedElements: [][]int{
				{2, 3, 4},
				{2, 3},
				{2},
				{},
			},
		},
		"DeleteNodesWithTwoChildren": {
			insert:     []int{8, 4, 6, 5, 12, 10, 9, 11, 14, 15},
			deletes:    []int{10, 12},
			expectedOK: []bool{true, true},
			roots:      []int{8, 8},
			expectedElements: [][]int{
				{4, 5, 6, 8, 9, 11, 12, 14, 15},
				{4, 5, 6, 8, 9, 11, 14, 15},
			},
		},
		"DeleteRoots": {
			insert:     []int{8, 4, 6, 5, 12, 10, 9, 11, 14, 15},
			deletes:    []int{8, 9, 10, 11, 12, 14, 15, 4, 6, 5, 5},
			expectedOK: []bool{true, true, true, true, true, true, true, true, true, true, false},
			roots:      []int{9, 10, 11, 12, 14, 15, 4, 6, 5, 0, 0},
			expectedElements: [][]int{
				{4, 5, 6, 9, 10, 11, 12, 14, 15},
				{4, 5, 6, 10, 11, 12, 14, 15},
				{4, 5, 6, 11, 12, 14, 15},
				{4, 5, 6, 12, 14, 15},
				{4, 5, 6, 14, 15},
				{4, 5, 6, 15},
				{4, 5, 6},
				{5, 6},
				{5},
				{},
				{},
			},
		},
	}

	for name, test := range tests {
		t.Run(name, func(t *testing.T) {
			b := &BST{}
			for _, v := range test.insert {
				b.Insert(v)
			}

			for i, v := range test.deletes {
				ok := b.Delete(v)
				if ok != test.expectedOK[i] {
					t.Fatalf("Expected delete: %v, got: %v", test.expectedOK[i], ok)
				}

				root, elems := b.InOrder()
				if root != test.roots[i] {
					t.Fatalf("Expected root: %d, got: %d", test.roots[i], root)
				}

				if areSlicesDifferent(elems, test.expectedElements[i]) {
					t.Fatalf("got: %v, want: %v", elems, test.expectedElements[i])
				}
			}
		})
	}
}

func areSlicesDifferent(a, b []int) bool {
	if len(a) != len(b) {
		return true
	}

	for i, x := range a {
		if x != b[i] {
			return true
		}
	}

	return false
}
