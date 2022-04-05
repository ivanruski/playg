// Given the head of a linked list, remove the nth node from the end of the list
// and return its head.
//
// Example 1
// Input: head = [1,2,3,4,5], n = 2
// Output: [1,2,3,5]
//
// Example 2
// Input: head = [1], n = 1
// Output: []
//
// Example 3
// Input: head = [1,2], n = 1
// Output: [1]
//
// Constraints:
//
// The number of nodes in the list is sz.
// 1 <= sz <= 30
// 0 <= Node.val <= 100
// 1 <= n <= sz
//
//
// Follow up: Could you do this in one pass?
//
// https://leetcode.com/problems/remove-nth-node-from-end-of-list/

package main

func main() {

}

type ListNode struct {
	Val  int
	Next *ListNode
}

func removeNthFromEnd(head *ListNode, n int) *ListNode {
	var (
		nth, prev *ListNode
		dist      int
	)

	if head == nil {
		return nil
	}

	dist = -n + 1
	for curr := head; curr != nil; curr = curr.Next {
		if dist == 0 {
			nth = head
		} else if dist > 0 {
			prev = nth
			nth = nth.Next
		}

		dist++
	}

	if nth == head {
		newHead := head.Next
		head.Next = nil
		return newHead
	}
	if nth.Next == nil {
		prev.Next = nil
		return head
	}

	prev.Next = nth.Next
	return head
}
