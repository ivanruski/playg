// Simple Node struct used throughout the chapter

package main

type Node struct {
	Value int
	Next  *Node
}

func CreateLinkedListFromArr(arr []int) *Node {
	if len(arr) == 0 {
		return nil
	}

	head := &Node{Value: arr[0]}
	curr := head
	for i := 1; i < len(arr); i++ {
		curr.Next = &Node{Value: arr[i]}
		curr = curr.Next
	}

	return head
}
