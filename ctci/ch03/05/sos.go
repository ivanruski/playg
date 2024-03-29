// SetOfStacks is from exercise 3.3 (with an additional Peek)

package main

type Node struct {
	Val  int
	Next *Node
}

type Stack struct {
	top  *Node
	size int
}

func (s *Stack) Peek() (int, bool) {
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

// SetOfStacks is not thread safe
type SetOfStacks struct {
	stacks    []*Stack
	threshold int
	currStack int
}

func NewSetOfStacks(threshold int) *SetOfStacks {
	return &SetOfStacks{
		stacks:    make([]*Stack, 4, 4),
		threshold: threshold,
		currStack: 0,
	}
}

func (ss *SetOfStacks) Peek() (int, bool) {
	v, ok := ss.Pop()
	if !ok {
		return 0, false
	}

	ss.Push(v)
	return v, true
}

func (ss *SetOfStacks) Pop() (int, bool) {
	// Cases:
	// - The current stack has elements /v
	// - The current stack has no elements

	s := ss.stacks[ss.currStack]
	v, ok := s.Pop()

	// The current stack has elements
	if ok {
		return v, ok
	}

	// The current stack is the only stack and is empty
	if ss.currStack == 0 {
		return 0, false
	}

	ss.currStack -= 1

	return ss.Pop()
}

func (ss *SetOfStacks) Push(v int) {
	// Cases:
	// 1. When pushing for the first time
	// 2. When the curr limit is reached
	//    1. When curr should go at the front
	// 3. When the curr limit is reached and stacks slice should be resized

	s := ss.stacks[ss.currStack]
	if s == nil {
		s = &Stack{}
		ss.stacks[ss.currStack] = s
	}

	// current stack has the capcity, just push
	if s.Size() < ss.threshold {
		s.Push(v)
		return
	}

	// we need to create a new stack but we don't have a free slot
	if ss.stacksUsed() == len(ss.stacks) {
		ss.resize()
	}

	if ss.currStack == len(ss.stacks)-1 {
		ss.currStack = 0
	} else {
		ss.currStack += 1
	}

	ss.stacks[ss.currStack] = &Stack{}
	ss.stacks[ss.currStack].Push(v)
}

func (ss *SetOfStacks) Size() int {
	var total int
	for i := 0; i < ss.stacksUsed(); i++ {
		total += ss.stacks[i].Size()
	}

	return total
}

func (ss *SetOfStacks) resize() {
	newLen := len(ss.stacks) * 2
	newStackSlots := make([]*Stack, newLen, newLen)

	copy(newStackSlots, ss.stacks)

	ss.stacks = newStackSlots
}

func (ss *SetOfStacks) stacksUsed() int {
	s := ss.stacks[ss.currStack]
	if (s == nil && ss.currStack == 0) || (s.Size() == 0 && ss.currStack == 0) {
		return 0
	}

	return ss.currStack + 1
}
