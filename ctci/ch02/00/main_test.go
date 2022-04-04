package main

import "testing"

func TestCreateLinkedListFromArr(t *testing.T) {
	tests := map[string]struct {
		input []int
		want  *Node
	}{
		"EmptySlice": {},
		"One-to-ten": {
			input: []int{1, 2, 3, 4, 5, 6, 7, 8, 9, 10},
			want: &Node{
				Value: 1,
				Next: &Node{
					Value: 2,
					Next: &Node{
						Value: 3,
						Next: &Node{
							Value: 4,
							Next: &Node{
								Value: 5,
								Next: &Node{
									Value: 6,
									Next: &Node{
										Value: 7,
										Next: &Node{
											Value: 8,
											Next: &Node{
												Value: 9,
												Next: &Node{
													Value: 10,
												},
											},
										},
									},
								},
							},
						},
					},
				},
			},
		},
	}

	for name, test := range tests {
		t.Run(name, func(t *testing.T) {
			head := CreateLinkedListFromArr(test.input)
			if !compareLists(head, test.want) {
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
