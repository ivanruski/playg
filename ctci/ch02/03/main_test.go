package main

import "testing"

func TestDeleteMiddleNode(t *testing.T) {
	tests := map[string]struct {
		input   []int
		kthNode int
		want    []int
	}{
		"Delete node at idx 1": {
			input:   []int{1, 2, 3, 4, 5, 6},
			kthNode: 1,
			want:    []int{1, 3, 4, 5, 6},
		},
		"Delete node at idx 4": {
			input:   []int{1, 2, 3, 4, 5, 6},
			kthNode: 4,
			want:    []int{1, 2, 3, 4, 6},
		},
	}

	for name, test := range tests {
		t.Run(name, func(t *testing.T) {
			head := CreateLinkedListFromArr(test.input)
			kth := kthNode(head, test.kthNode)
			DeleteMiddleNode(kth)

			want := CreateLinkedListFromArr(test.want)
			if !compareLists(head, want) {
				t.Errorf("Lists values are not equal")
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

func kthNode(head *Node, k int) *Node {
	for i := 0; i < k; i++ {
		head = head.Next
	}

	return head
}
