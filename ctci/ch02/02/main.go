//Return Kth to Last: Implement an algorithm to find the kth to last element of
// a singly linked list

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

func KthToLast(head *Node, k int) *Node {
	var (
		kth, curr *Node
		dist      int
	)

	curr = head
	dist = -k
	for {
		if curr == nil {
			break
		}

		if dist == 0 {
			kth = head
		} else if dist > 0 {
			kth = kth.Next
		}

		curr = curr.Next
		dist++
	}

	return kth
}
