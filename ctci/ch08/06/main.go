// Towers of Hanoi

package main

import "fmt"

type Node struct {
	Val  int
	Next *Node
}

type Stack struct {
	size int
	top  *Node
}

func (s *Stack) Push(val int) {
	n := &Node{Val: val}
	if s.top == nil {
		s.top = n
	} else {
		n.Next = s.top
		s.top = n
	}

	s.size++
}

func (s *Stack) IsEmpty() bool {
	return s.top == nil
}

func (s *Stack) Size() int {
	return s.size
}

func (s *Stack) Pop() int {
	if s.top == nil {
		return 0
	}

	val := s.top.Val
	s.top = s.top.Next
	s.size--

	return val
}

func (s *Stack) Peek() int {
	if s.top == nil {
		return 0
	}

	return s.top.Val
}

func main() {
	m := towersOfHanoi(15)
	fmt.Println(m)
}

func towersOfHanoi(n int) int {
	s1 := &Stack{}
	s2 := &Stack{}
	s3 := &Stack{}

	for i := n; i > 0; i-- {
		s1.Push(i)
	}

	// set some initial value that will result in moving the a disk from
	// the first stack
	lastPushed := 2
	moves = 0
	moveDisks(s1, s2, s3, lastPushed, n)

	for !s3.IsEmpty() {
		fmt.Println(s3.Pop())
	}
	fmt.Println()
	return moves
}

var moves int

// This must be one of the ugliest solutions to the problem.
func moveDisks(s1, s2, s3 *Stack, lastPushed, n int) {
	if n == s3.Size() {
		return
	}
	moves++

	lp := 0
	switch lastPushed {
	case 1:
		if s2.IsEmpty() {
			lp = popFromS3(s1, s2, s3)
		} else if s3.IsEmpty() {
			lp = popFromS2(s1, s2, s3)
		} else {
			v2 := s2.Peek()
			v3 := s3.Peek()
			if v2 < v3 {
				lp = popFromS2(s1, s2, s3)
			} else {
				lp = popFromS3(s1, s2, s3)
			}
		}
	case 2:
		if s1.IsEmpty() {
			lp = popFromS3(s1, s2, s3)
		} else if s3.IsEmpty() {
			lp = popFromS1(s1, s2, s3)
		} else {
			v1 := s1.Peek()
			v3 := s3.Peek()
			if v1 < v3 {
				lp = popFromS1(s1, s2, s3)
			} else {
				lp = popFromS3(s1, s2, s3)
			}
		}
	case 3:
		if s1.IsEmpty() {
			lp = popFromS2(s1, s2, s3)
		} else if s2.IsEmpty() {
			lp = popFromS1(s1, s2, s3)
		} else {
			v1 := s1.Peek()
			v2 := s2.Peek()
			if v1 < v2 {
				lp = popFromS1(s1, s2, s3)
			} else {
				lp = popFromS2(s1, s2, s3)
			}
		}
	}

	moveDisks(s1, s2, s3, lp, n)
}

func popFromS1(s1, s2, s3 *Stack) int {
	if s1.Size()%2 == 1 {
		s3.Push(s1.Pop())
		return 3
	} else {
		s2.Push(s1.Pop())
		return 2
	}
}

func popFromS2(s1, s2, s3 *Stack) int {
	if s2.Size()%2 == 1 {
		s3.Push(s2.Pop())
		return 3
	} else {
		s1.Push(s2.Pop())
		return 1
	}
}

func popFromS3(s1, s2, s3 *Stack) int {
	if s3.Size()%2 == 1 {
		s2.Push(s3.Pop())
		return 2
	} else {
		s1.Push(s3.Pop())
		return 1
	}
}
