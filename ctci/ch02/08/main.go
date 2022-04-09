// Loop Detection: Given a linked list which might contian a loop, implement
// and algorithm that returns the node at the beginning of the loop (if one
// exists).
//
// https://leetcode.com/problems/linked-list-cycle-ii/

package main

import "fmt"

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

func getNthNode(head *ListNode, n int) *ListNode {
	for i := 0; i <= n; i++ {
		if i == n {
			break
		}
		head = head.Next
	}

	return head
}

func main() {
	head := CreateLinkedListFromArr([]int{3, 2, 0, -4})

	four := getNthNode(head, 3)
	two := getNthNode(head, 1)
	four.Next = two

	fmt.Println(LoopDetection(head).Val)
}

func LoopDetection(head *ListNode) *ListNode {
	if head == nil {
		return nil
	}

	// s moves one node at a time
	// f moves two nodes at a time
	var s, f *ListNode

	s, f = head, head

	for {
		s = s.Next
		if f.Next != nil && f.Next.Next != nil {
			f = f.Next.Next
		} else {
			// no cycle and we reached the end of the list
			return nil
		}

		// cycle, now we need to find it's beginning
		if s == f {
			break
		}
	}

	for {
		if s == head {
			return s
		}
		s = s.Next
		head = head.Next
	}
}
