// Sort Stack: Write a program to sort a stack such that the samllest items are
// on the top. You can use an additional temporary stack, but you may not copy
// the elements into any other data structure (such as an array). The stack
// supports the following operations: push, pop, peek, and isEmpty.

package main

type stack interface {
	Pop() (int, bool)
	Push(int)
	Size() int
}

// Using SetOfStacks so that I can catch bugs(if any).
func SortStack(s *SetOfStacks) {
	if s.Size() < 2 {
		return
	}

	var stop, ttop int
	temp := NewSetOfStacks(4)
	for s.Size() > 0 {
		stop, _ = s.Pop()

		// move all of the elements larger than stop into s
		for temp.Size() > 0 {
			ttop, _ = temp.Pop()
			if ttop >= stop {
				s.Push(ttop)
			} else {
				temp.Push(ttop)
				break
			}
		}

		temp.Push(stop)

		// move all elements larger than ttop into temp
		for s.Size() > 0 {
			stop, _ = s.Pop()
			if ttop, _ = temp.Peek(); stop >= ttop {
				temp.Push(stop)
			} else {
				s.Push(stop)
				break
			}
		}
	}

	for temp.Size() > 0 {
		ttop, _ = temp.Pop()
		s.Push(ttop)
	}
}
