// Sum Lists: You have two numbers represented by a linked list, where eaach
// node contains a single digit. The digits are stored in reverse order,
// such that the 1's digit is at the head of the list. Write a function that
// adds the two numbers and returns the sum as a linked list. (You are not
// allowed to cheat and just convert he linked list to an integer.)
//
// FOLLOW UP
// Suppose the digits are stored in forward order. Repeat the above problem.
//
// https://leetcode.com/problems/add-two-numbers/

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

func SumLists(a, b *Node) *Node {
	var head, curr *Node
	var sum, carry int
	for ; a != nil && b != nil; a, b = a.Next, b.Next {
		a.Value += carry
		sum, carry = SumToDigits(a.Value, b.Value)

		if head == nil {
			head = &Node{Value: sum}
			curr = head
		} else {
			curr.Next = &Node{Value: sum}
			curr = curr.Next
		}
	}

	for ; a != nil; a = a.Next {
		sum, carry = SumToDigits(a.Value, carry)
		curr.Next = &Node{Value: sum}
		curr = curr.Next
	}

	for ; b != nil; b = b.Next {
		sum, carry = SumToDigits(b.Value, carry)
		curr.Next = &Node{Value: sum}
		curr = curr.Next
	}

	if carry == 1 {
		curr.Next = &Node{Value: 1}
	}

	return head
}

func SumToDigits(x, y int) (int, int) {
	sum := x + y
	if sum == 10 {
		return 0, 1
	} else if sum > 10 {
		return sum % 10, 1
	}

	return sum, 0
}
