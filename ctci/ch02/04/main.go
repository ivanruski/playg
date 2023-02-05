// Partition: Write code to partition a linked list around a value x, such that
// all nodes less than x come before all nodes greater than or equal to x.
// (IMPORTANT: The partition element x can appear anywhere in the "right
// partition"; it does not need to appear between the left and the right
// partitions.
//
// Example
// Input: 3 -> 5 -> 8 -> 5 -> 10 -> 2 -> 1 [partition = 5]
// Output 3 -> 1 -> 2     -> 10 -> 5 -> 5 -> 8
//
// https://leetcode.com/problems/partition-list/

package main

type ListNode struct {
	Val  int
	Next *ListNode
}

func CreateLinkedListFromArr(arr []int) *ListNode {
	if len(arr) == 0 {
		return nil
	}

	head := &ListNode{Val: arr[0]}
	curr := head
	for i := 1; i < len(arr); i++ {
		curr.Next = &ListNode{Val: arr[i]}
		curr = curr.Next
	}

	return head
}

func main() {
}

func Partition(head *ListNode, x int) *ListNode {
	// j is the new head
	// k is the tail of the list with values less than x
	// l is the head of the list with values greater than x
	// m is the tail of the list with values greater than x
	var j, k, l, m *ListNode

	for curr := head; curr != nil; curr = curr.Next {
		if curr.Val < x {
			if j == nil {
				j = curr
				k = curr
			} else {
				k.Next = curr
				k = curr
			}
		} else {
			if l == nil {
				l = curr
				m = curr
			} else {
				m.Next = curr
				m = curr
			}
		}
	}

	// if j is nil the all of the nodes' values were greater than x
	if j == nil {
		return l
	}

	k.Next = l
	if m != nil {
		m.Next = nil
	}

	return j
}
