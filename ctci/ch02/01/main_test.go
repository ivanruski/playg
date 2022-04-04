package main

import "testing"

func TestRemoveDups(t *testing.T) {
	tests := map[string]struct {
		input []int
		want  []int
	}{
		"RemoveDupsFromEmptyList": {},
		"UniqueNums": {
			input: []int{1, 2, 3, 4, 5, 6, 7, 8, 9, 10},
			want:  []int{1, 2, 3, 4, 5, 6, 7, 8, 9, 10},
		},
		"Duplicates1": {
			input: []int{1, 2, 2, 4, 5},
			want:  []int{1, 2, 4, 5},
		},
		"Duplicates2": {
			input: []int{1, 2, 2, 4, 2, 2, 2, 5},
			want:  []int{1, 2, 4, 5},
		},
		"Duplicates3": {
			input: []int{2, 2, 2, 2, 2, 2, 2},
			want:  []int{2},
		},
		"Duplicates4": {
			input: []int{2, 2, 2, 2, 2, 2, 2, 3},
			want:  []int{2, 3},
		},
		"Duplicates5": {
			input: []int{3, 2, 2, 2, 2, 2, 2, 2},
			want:  []int{3, 2},
		},
		"Duplicates6": {
			input: []int{2, 2, 2, 0, 2, 2, 2, 2},
			want:  []int{2, 0},
		},
		"Duplicates7": {
			input: []int{1, 1, 1, 2, 3, 3, 4, 5, 5, 6},
			want:  []int{1, 2, 3, 4, 5, 6},
		},
	}

	for name, test := range tests {
		t.Run(name, func(t *testing.T) {
			want := CreateLinkedListFromArr(test.want)
			input := CreateLinkedListFromArr(test.input)
			got := RemoveDups(input)
			if !compareLists(want, got) {
				t.Errorf("Lists are not equal")
			}
		})
	}
}

func compareLists(a, b *Node) bool {
	for {
		if a == nil && b == nil {
			return true
		}

		if a == nil && b != nil || a != nil && b == nil {
			return false
		}

		if a.Value != b.Value {
			return false
		}

		a = a.Next
		b = b.Next
	}

	return true
}
