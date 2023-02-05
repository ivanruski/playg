// List of Depths: Given a binary tree, design an algorithm which creates a
// linked list of all the nodes at each depth (e.g. if you have a tree with
// depth D, you'll have D linked lists)

package main

import (
	"fmt"
	"strings"
)

type QueueNode[T any] struct {
	Val  T
	Next *QueueNode[T]
}

type Queue[T any] struct {
	front *QueueNode[T]
	tail  *QueueNode[T]
}

func (q *Queue[T]) Enqueue(v T) {
	n := &QueueNode[T]{Val: v}

	if q.tail == nil {
		q.front = n
		q.tail = n
	} else {
		q.tail.Next = n
		q.tail = n
	}
}

func (q *Queue[T]) Dequeue() T {
	var t T
	if q.front == nil {
		return t
	}

	t = q.front.Val
	if q.front == q.tail {
		q.front = nil
		q.tail = nil
	} else {
		q.front = q.front.Next
	}

	return t
}

func (q *Queue[T]) IsEmpty() bool {
	return q.front == nil
}

type TreeNode[T any] struct {
	Val   T
	Left  *TreeNode[T]
	Right *TreeNode[T]
}

type Node[T any] struct {
	Val  T
	Next *Node[T]
}

type LinkedList[T any] struct {
	front *Node[T]
	back  *Node[T]
}

func (ll *LinkedList[T]) Append(v T) {
	n := &Node[T]{Val: v}

	if ll.front == nil {
		ll.front = n
		ll.back = n
	} else {
		ll.back.Next = n
		ll.back = n
	}
}

func (ll *LinkedList[T]) String() string {
	if ll == nil {
		return ""
	}

	var b strings.Builder

	c := ll.front
	for c != nil {
		b.WriteString(fmt.Sprintf("%v", c.Val))
		if c.Next != nil {
			b.WriteString(" -> ")
		}
		c = c.Next
	}

	return b.String()
}

func main() {
}

func ListOfDepths[T any](root *TreeNode[T]) []*LinkedList[T] {
	if root == nil {
		return nil
	}

	var (
		result []*LinkedList[T]
		q      = Queue[*TreeNode[T]]{}
		ll     = &LinkedList[T]{}
	)

	sentinel := &TreeNode[T]{}
	q.Enqueue(root)
	q.Enqueue(sentinel)

	for !q.IsEmpty() {
		n := q.Dequeue()
		if n == sentinel {
			result = append(result, ll)
			if q.IsEmpty() {
				break
			}

			q.Enqueue(n)
			ll = &LinkedList[T]{}
		} else {
			ll.Append(n.Val)
			if n.Left != nil {
				q.Enqueue(n.Left)
			}
			if n.Right != nil {
				q.Enqueue(n.Right)
			}
		}
	}

	return result
}
