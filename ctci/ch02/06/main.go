// Palindrome: Implement a function to check if a linked list is a palindrome.
// https://leetcode.com/problems/palindrome-linked-list/

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

func main() {
	arr := []int{1, 2, 3, 4, 3, 2, 1}
	head := CreateLinkedListFromArr(arr)
	fmt.Println(Palindrome2(head))
}

func Palindrome(head *ListNode) bool {
	front = head
	return palindrome(head)
}

var front *ListNode

func palindrome(n *ListNode) bool {
	if n == nil {
		return true
	}

	ok := palindrome(n.Next)
	if !ok {
		return false
	}

	ok = n.Val == front.Val
	front = front.Next
	return ok
}

// O(n) time and O(1) space
func Palindrome2(head *ListNode) bool {
	len := listLen(head)
	var reverseFrom, middle *ListNode
	if len%2 == 0 {
		reverseFrom = getKthNode(head, len/2)
	} else {
		// if len == 3 it won't work
		middle = getKthNode(head, len/2)
		reverseFrom = middle.Next
	}

	end := reverseList(reverseFrom)
	for end != nil {
		if end.Val != head.Val {
			return false
		}

		end = end.Next
		head = head.Next
	}

	return true
}

func reverseList(head *ListNode) *ListNode {
	var prev, curr, next *ListNode

	curr = head
	for curr != nil {
		next = curr.Next
		curr.Next = prev
		prev = curr
		curr = next
	}

	return prev
}

func getKthNode(head *ListNode, k int) *ListNode {
	var i int
	for curr := head; curr != nil; curr = curr.Next {
		if i == k {
			return curr
		}
		i++
	}

	return nil
}

func listLen(head *ListNode) int {
	var length int
	for curr := head; curr != nil; curr = curr.Next {
		length++
	}

	return length
}
