package main

import (
	"fmt"
	"strings"
	"testing"
)

func TestSumToDigits(t *testing.T) {
	tests := map[string]struct {
		x     int
		y     int
		want  int
		carry int
	}{
		"2+2": {
			x:     2,
			y:     2,
			want:  4,
			carry: 0,
		},
		"5+5": {
			x:     5,
			y:     5,
			want:  0,
			carry: 1,
		},
		"6+7": {
			x:     6,
			y:     7,
			want:  3,
			carry: 1,
		},
	}

	for name, test := range tests {
		t.Run(name, func(t *testing.T) {
			got, carry := SumToDigits(test.x, test.y)
			if got != test.want || carry != test.carry {
				t.Errorf("Want: %d %d, got: %d %d", test.want, test.carry, got, carry)
			}
		})
	}
}

func TestSumLists(t *testing.T) {
	tests := map[string]struct {
		a    []int
		b    []int
		want string
	}{
		"Example": {
			a:    []int{7, 1, 6},
			b:    []int{5, 9, 2},
			want: "2->1->9",
		},
		"Example2": {
			a:    []int{2, 4, 3},
			b:    []int{5, 6, 4},
			want: "7->0->8",
		},
		"Example3": {
			a:    []int{9, 9, 9, 9, 9, 9, 9},
			b:    []int{9, 9, 9, 9},
			want: "8->9->9->9->0->0->0->1",
		},
		"Example4": {
			a:    []int{2},
			b:    []int{0},
			want: "2",
		},
		"Example5": {
			a:    []int{9, 9, 9, 9, 9},
			b:    []int{1},
			want: "0->0->0->0->0->1",
		},
	}

	for name, test := range tests {
		t.Run(name, func(t *testing.T) {
			a := CreateLinkedListFromArr(test.a)
			b := CreateLinkedListFromArr(test.b)
			head := SumLists(a, b)
			str := listToString(head)
			if str != test.want {
				t.Errorf("Got: %s, want: %s", str, test.want)
			}
		})
	}
}

func listToString(a *Node) string {
	if a == nil {
		return ""
	}

	var b strings.Builder
	var curr *Node
	for curr = a; curr.Next != nil; curr = curr.Next {
		b.WriteString(fmt.Sprintf("%d->", curr.Value))
	}
	b.WriteString(fmt.Sprintf("%d", curr.Value))

	return b.String()
}
