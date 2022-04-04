// Remove Dups: Write code to remove duplicates from unsorted linked list.
//
// FOLLOW UP
//
// How would you solve this problem if a temporary buffer is not allowed ?

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

// O(1) in terms of space and O(n^2) in terms of time
func RemoveDups(head *Node) *Node {
	for c := head; c != nil; c = c.Next {
		p := c
		for n := c.Next; n != nil; n = n.Next {
			if n.Value == c.Value {
				p.Next = n.Next
				continue
			}
			p = n
		}

	}

	return head
}
