// Intersection: Given two (singly) linked lists, determine if the two lists
// intersect. Return the intersecting node. Note that the intersection is
// defined based on reference, not value.
//
// https://leetcode.com/problems/intersection-of-two-linked-lists/

package main

type ListNode struct {
	Val  int
	Next *ListNode
}

func main() {
}

func Intersection(a, b *ListNode) *ListNode {
	alen := listLen(a)
	blen := listLen(b)

	if alen > blen {
		for i := 0; i < alen-blen; i++ {
			a = a.Next
		}
	} else if blen > alen {
		for i := 0; i < blen-alen; i++ {
			b = b.Next
		}
	}

	for a != b && a != nil {
		a = a.Next
		b = b.Next
	}

	return a
}

func listLen(a *ListNode) int {
	var i int
	for c := a; c != nil; c = c.Next {
		i++
	}

	return i
}
