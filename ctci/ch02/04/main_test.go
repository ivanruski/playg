package main

import (
	"fmt"
	"strings"
	"testing"
)

func TestPartition(t *testing.T) {
	tests := map[string]struct {
		input []int
		x     int
		want  []int
	}{
		"OnlySmaller": {
			input: []int{1, 2, 3, 4, 5, 6, 7, 8, 9, 10},
			x:     11,
			want:  []int{1, 2, 3, 4, 5, 6, 7, 8, 9, 10},
		},
		"OnlyLarger": {
			input: []int{1, 2, 3, 4, 5, 6, 7, 8, 9, 10},
			x:     0,
			want:  []int{1, 2, 3, 4, 5, 6, 7, 8, 9, 10},
		},
		"Mixed1": {
			input: []int{3, 5, 8, 5, 10, 2, 1},
			x:     5,
			want:  []int{3, 2, 1, 5, 8, 5, 10},
		},
		"Mixed2": {
			input: []int{1, 4, 3, 2, 5, 2},
			x:     3,
			want:  []int{1, 2, 2, 4, 3, 5},
		},
		"Mixed3": {
			input: []int{2, 1},
			x:     2,
			want:  []int{1, 2},
		},
		"Equals": {
			input: []int{2, 2, 2, 2, 2, 2, 2, 2},
			x:     2,
			want:  []int{2, 2, 2, 2, 2, 2, 2, 2},
		},
	}

	for name, test := range tests {
		t.Run(name, func(t *testing.T) {
			input := CreateLinkedListFromArr(test.input)
			got := Partition(input, test.x)
			want := CreateLinkedListFromArr(test.want)

			gotStr, wantStr := listToString(got), listToString(want)
			if gotStr != wantStr {
				t.Errorf("Got %s, want: %s", gotStr, wantStr)
			}
		})
	}
}

func listToString(a *ListNode) string {
	if a == nil {
		return ""
	}

	var b strings.Builder
	var curr *ListNode
	for curr = a; curr.Next != nil; curr = curr.Next {
		b.WriteString(fmt.Sprintf("%d->", curr.Val))
	}
	b.WriteString(fmt.Sprintf("%d", curr.Val))

	return b.String()
}
