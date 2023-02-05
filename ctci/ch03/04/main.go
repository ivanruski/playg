// Queue via Stacks: Implement a MyQueue class which implements a queue using
// two stacks.
//
// The solution passes the tests in leetcode
// https://leetcode.com/problems/implement-queue-using-stacks/

package main

type Node struct {
	Val  int
	Next *Node
}

type Stack struct {
	top  *Node
	size int
}

func (s *Stack) Top() (int, bool) {
	if s.top == nil {
		return 0, false
	}

	return s.top.Val, true
}

func (s *Stack) Pop() (int, bool) {
	if s.top == nil {
		return 0, false
	}

	result := s.top.Val
	s.top = s.top.Next
	s.size--

	return result, true
}

func (s *Stack) Push(v int) {
	if s.top == nil {
		s.top = &Node{Val: v}
	} else {
		newTop := &Node{Val: v, Next: s.top}
		s.top = newTop
	}
	s.size++
}

func (s *Stack) Size() int {
	return s.size
}

type Queue struct {
	popStack  *Stack
	pushStack *Stack
}

func NewQueue() *Queue {
	return &Queue{
		popStack:  &Stack{},
		pushStack: &Stack{},
	}
}

func (q *Queue) Push(x int) {
	q.pushStack.Push(x)
}

func (q *Queue) Pop() int {
	if q.popStack.Size() > 0 {
		v, _ := q.popStack.Pop()
		return v
	}

	if q.pushStack.Size() > 0 {
		for q.pushStack.Size() != 0 {
			v, _ := q.pushStack.Pop()
			q.popStack.Push(v)
		}

		v, _ := q.popStack.Pop()
		return v
	}

	return 0
}

func (q *Queue) Peek() int {
	if q.popStack.Size() > 0 {
		v, _ := q.popStack.Top()
		return v
	}

	if q.pushStack.Size() > 0 {
		for q.pushStack.Size() != 0 {
			v, _ := q.pushStack.Pop()
			q.popStack.Push(v)
		}

		v, _ := q.popStack.Top()
		return v
	}

	return 0
}

func (q *Queue) Empty() bool {
	return q.popStack.Size() == 0 && q.pushStack.Size() == 0
}
