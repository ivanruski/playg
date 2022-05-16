package main

import "testing"

func TestCheckRouteDFS(t *testing.T) {
	var (
		zero  = &Node[int]{Val: 0}
		one   = &Node[int]{Val: 1}
		two   = &Node[int]{Val: 2}
		three = &Node[int]{Val: 3}
		four  = &Node[int]{Val: 4}
		five  = &Node[int]{Val: 5}
	)

	zero.Vertices = []*Node[int]{one, four, five}
	one.Vertices = []*Node[int]{three, four}
	two.Vertices = []*Node[int]{one}
	three.Vertices = []*Node[int]{two, four}

	// g := Graph[int]{Nodes: []Node[int]{one, two, three, four, five}}

	ok := CheckRouteDFS(zero, three)
	if !ok {
		t.Errorf("0 is connected to 3, got false")
	}

	ok = CheckRouteDFS(four, five)
	if ok {
		t.Errorf("4 is not connected to 5, got true")
	}

	ok = CheckRouteDFS(three, zero)
	if ok {
		t.Errorf("3 is not connected to 0, got true")
	}
}

func TestCheckRouteBFS(t *testing.T) {
	var (
		zero  = &Node[int]{Val: 0}
		one   = &Node[int]{Val: 1}
		two   = &Node[int]{Val: 2}
		three = &Node[int]{Val: 3}
		four  = &Node[int]{Val: 4}
		five  = &Node[int]{Val: 5}
	)

	zero.Vertices = []*Node[int]{one, four, five}
	one.Vertices = []*Node[int]{three, four}
	two.Vertices = []*Node[int]{one}
	three.Vertices = []*Node[int]{two, four}

	// g := Graph[int]{Nodes: []Node[int]{one, two, three, four, five}}

	ok := CheckRouteBFS(zero, three)
	if !ok {
		t.Errorf("0 is connected to 3, got false")
	}

	ok = CheckRouteBFS(four, five)
	if ok {
		t.Errorf("4 is not connected to 5, got true")
	}

	ok = CheckRouteBFS(three, zero)
	if ok {
		t.Errorf("3 is not connected to 0, got true")
	}
}
