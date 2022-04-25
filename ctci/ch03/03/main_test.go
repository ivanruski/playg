package main

import "testing"

func TestStack(t *testing.T) {
	tests := map[string]struct {
		input []int
	}{
		"Test1": {
			input: []int{1, 2, 3, 4, 5, 6, 7, 8, 9, 10},
		},
		"Test2": {
			input: []int{2, 2, 2, 2, 22, 2, 2, 2, 2},
		},
	}

	for name, test := range tests {
		t.Run(name, func(t *testing.T) {
			s := &Stack{}
			for _, num := range test.input {
				s.Push(num)
			}

			for i := len(test.input) - 1; i >= 0; i-- {
				if s.Size() != i+1 {
					t.Fatalf("At index: %d, want size: %d, got: %d", i, i+1, s.Size())
				}
				val, ok := s.Pop()
				if !ok {
					t.Fatalf("At index: %d, want succesfull pop", i)
				}

				if val != test.input[i] {
					t.Fatalf("At index: %d, want: %d, got: %d", i, test.input[i], val)
				}
			}

			for i := 0; i < 5; i++ {
				if s.Size() != 0 {
					t.Fatalf("want empty stack")
				}

				val, ok := s.Pop()
				if ok {
					t.Fatalf("want ok=false, got: %d", val)
				}
			}
		})
	}
}

func TestSetOfStacks(t *testing.T) {
	tests := map[string]struct {
		singleStackThreshold int
		elementsCnt          int
	}{
		"SimpleInsertsWithinThreshold": {
			singleStackThreshold: 4,
			elementsCnt:          3,
		},
		"MultipleStacks": {
			singleStackThreshold: 4,
			elementsCnt:          16,
		},
		"MultipleStacksWithResizing": {
			singleStackThreshold: 4,
			elementsCnt:          150,
		},
		"MultipleStacksWithResizing2": {
			singleStackThreshold: 1,
			elementsCnt:          10001,
		},
	}

	for name, test := range tests {
		t.Run(name, func(t *testing.T) {
			ss := NewSetOfStacks(test.singleStackThreshold)
			populateStack := func() {
				for i := test.elementsCnt - 1; i >= 0; i-- {
					ss.Push(i)
				}

				if ss.Size() != test.elementsCnt {
					t.Fatalf("got size: %d, want: %d", ss.Size(), test.elementsCnt)
				}

				for i := 0; i < test.elementsCnt; i++ {
					v, ok := ss.Pop()
					if !ok {
						t.Fatalf("got !ok from ss.Pop(), want ok")
					}
					if v != i {
						t.Fatalf("got %d, want %d", v, i)
					}
				}
			}

			populateStack()

			// reuse the stack and pop when empty
			for i := 0; i < test.elementsCnt; i++ {
				_, ok := ss.Pop()
				if ok {
					t.Fatalf("got ok from ss.Pop(), want !ok")
				}
			}

			populateStack()
		})
	}
}

func TestPopAt(t *testing.T) {
	ss := NewSetOfStacks(2)
	ss.Push(5)
	ss.Push(4)

	ss.Push(3)
	ss.Push(6)

	ss.Push(10)
	ss.Push(20)

	ss.Push(50)
	ss.Push(60)

	_, ok := ss.PopAt(4)
	if ok {
		t.Fatalf("expected !ok, got ok")
	}

	tests := []struct {
		stackIdx int
		val      int
	}{
		{2, 20},
		{1, 6},
		{0, 4},
		{2, 10},
	}

	for _, ts := range tests {
		val, ok := ss.PopAt(ts.stackIdx)

		if !ok || val != ts.val {
			t.Fatalf("exptected ok with val = %d, got %v with val = %d", ts.val, ok, val)
		}
	}

	wants := []int{60, 50, 3, 5}
	for _, want := range wants {
		val, ok := ss.Pop()
		if !ok || val != want {
			t.Fatalf("exptected ok with val = %d, got %v with val = %d", want, ok, val)
		}
	}

	val, ok := ss.Pop()
	if ok {
		t.Fatalf("exptected !ok, got %d", val)
	}

	for i := 0; i < 10; i++ {
		val, ok = ss.PopAt(i)
		if ok {
			t.Fatalf("exptected !ok, got %d", val)
		}
	}
}
