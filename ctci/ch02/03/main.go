// Delete Middle Node: Implement an algorithm to delete a node in the middle
// (i.e. any node but the first and last node, not necessarily the exact middle)
// of a singly linked list, given only access to that node
//
// EXAMPLE
//
// Input the node 'c' from the linked list a -> b -> c -> d -> e -> f
// Result: nothing is returned, but the new linked list loks like a -> b -> d -> e -> f

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

func main() {
}

func DeleteMiddleNode(n *Node) {
	// check if n is the last node
	// I don't know how to check if n is the first node
	if n == nil || n.Next == nil {
		return
	}

	n.Value = n.Next.Value
	n.Next = n.Next.Next
}
