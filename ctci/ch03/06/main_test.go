package main

import "testing"

func TestQueueEnqueuAndDequeue(t *testing.T) {
	q := Queue[int]{}

	v, ok := q.Dequeue()
	if ok {
		t.Fatalf("expected ok=false, got ok=true with v=%d", v)
	}

	q.Enqueue(1)
	q.Enqueue(2)
	q.Enqueue(3)

	for i := 1; i < 4; i++ {
		v, ok := q.Dequeue()
		if !ok || v != i {
			t.Fatalf("expected ok=true with v=%d, got ok=%v with v=%d", i, ok, v)
		}
	}

	v, ok = q.Dequeue()
	if ok {
		t.Fatalf("expected ok=false, got ok=true with v=%d", v)
	}
}

func TestAnimalShelter(t *testing.T) {
	s := NewAnimalShelter()

	a, ok := s.DequeueAny()
	if ok {
		t.Fatalf("expected !ok, got %v", a)
	}

	c, ok := s.DequeueCat()
	if ok {
		t.Fatalf("expected !ok, got %v", c)
	}

	d, ok := s.DequeueDog()
	if ok {
		t.Fatalf("expected !ok, got %v", d)
	}

	tests := map[string]struct {
		input []Animal
	}{
		"AlternatingCatsAndDogs": {
			input: []Animal{
				{Name: "Cat0", Type: Cat},
				{Name: "Dog1", Type: Dog},
				{Name: "Cat2", Type: Cat},
				{Name: "Dog3", Type: Dog},
				{Name: "Cat4", Type: Cat},
				{Name: "Dog4", Type: Dog},
			},
		},
	}

	for name, test := range tests {
		t.Run(name, func(t *testing.T) {
			enqueueAll := func() {
				for _, a := range test.input {
					s.Enqueue(a)
				}
			}

			enqueueAll()
			for _, ai := range test.input {
				a, ok := s.DequeueAny()
				if !ok {
					t.Fatalf("want %v, got !ok", ai)
				}
				if a != ai {
					t.Fatalf("want: %v, got: %v", ai, a)
				}
			}

			enqueueAll()
			for _, ai := range test.input {
				if ai.Type == Dog {
					continue
				}

				a, ok := s.DequeueCat()
				if !ok {
					t.Fatalf("want: %v, got !ok", ai)
				}
				if a != ai {
					t.Fatalf("want: %v, got: %v", ai, a)
				}
			}

			for _, ai := range test.input {
				if ai.Type == Cat {
					continue
				}

				a, ok := s.DequeueAny()
				if !ok {
					t.Fatalf("want: %v, got !ok", ai)
				}
				if a != ai {
					t.Fatalf("want: %v, got: %v", ai, a)
				}
			}
		})
	}
}
