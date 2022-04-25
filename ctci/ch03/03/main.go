// Stack of Plates: Imagine a (literal) stack of plates. If the stack gets too
// high, it might topple. Therefore, in real life, we would likely start a new
// stack when the previous stack exceeds some threshold. Implement a data
// structure SteOfStacks that mimics this. SetOfStacks should be composed of
// several stacks and should create a new stack once the previous one exceeds
// capacity. SetOfStacks.push() and SetOfStacks.pop() should behave identically
// to a single stack (that is, pop() should return the same values as it would
// if there wer just a single stack).
//
// FOLLOW UP
// ImplemenT a function popAt(int index) which performs a pop operation on a
// specific sub-stack.

package main

import "fmt"

type Node struct {
	Val  int
	Next *Node
}

type Stack struct {
	top  *Node
	size int
}

func (s *Stack) Pop() (int, bool) {
	if s == nil || s.top == nil {
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
	if s == nil {
		return 0
	}

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

func (ss *SetOfStacks) PopAt(index int) (int, bool) {
	if index >= len(ss.stacks) {
		return 0, false
	}

	s := ss.stacks[index]
	v, ok := s.Pop()
	if !ok {
		return 0, false
	}

	return v, true
}

func (ss *SetOfStacks) Pop() (int, bool) {
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

func main() {
	fmt.Println("asdf")
}
