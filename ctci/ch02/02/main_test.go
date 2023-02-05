package main

import "testing"

func TestKthToLast(t *testing.T) {
	tests := map[string]struct {
		input []int
		k     int
		want  *Node
	}{
		"NilList": {
			k: 1,
		},
		"0th to the last": {
			input: []int{1, 2, 3, 4, 5},
			k:     0,
			want:  &Node{Value: 5},
		},
		"1th to the last": {
			input: []int{1, 2, 3, 4, 5},
			k:     1,
			want:  &Node{Value: 4},
		},
		"2th to the last": {
			input: []int{1, 2, 3, 4, 5},
			k:     2,
			want:  &Node{Value: 3},
		},
		"3th to the last": {
			input: []int{1, 2, 3, 4, 5},
			k:     3,
			want:  &Node{Value: 2},
		},
		"4th to the last": {
			input: []int{1, 2, 3, 4, 5},
			k:     1,
			want:  &Node{Value: 4},
		},
		"5th to the last": {
			input: []int{1, 2, 3, 4, 5},
			k:     5,
		},
	}

	for name, test := range tests {
		t.Run(name, func(t *testing.T) {
			head := CreateLinkedListFromArr(test.input)
			got := KthToLast(head, test.k)

			if got == nil && test.want == nil {
				return
			}

			if got != nil && test.want == nil || got == nil && test.want != nil {
				t.Fatalf("want: %v, got: %v", test.want, got)
			}

			if got.Value != test.want.Value {
				t.Fatalf("want: %d, got: %d", test.want.Value, got.Value)
			}
		})
	}
}

func TestKthToLast_Pointers(t *testing.T) {
	head := CreateLinkedListFromArr([]int{3, 3, 3, 3, 3, 3, 3, 3, 3, 3})

	want := head.Next.Next.Next
	got := KthToLast(head, 6)

	if want != got {
		t.Errorf("want: %v, got: %v", want, got)
	}
}
