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
	fmt.Println(Palindrome(head))
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
