package main

import "testing"

func TestFindIntersection(t *testing.T) {
	tests := map[string]struct {
		l1   line
		l2   line
		want point
		ok   bool
	}{
		"SameLine": {
			l1: line{point{5, 5}, point{10, 5}},
			l2: line{point{20, 5}, point{40, 5}},
			ok: false,
		},
		"SteepLineWithYParallelLine": {
			l1:   line{point{0, 5}, point{100, 10}},
			l2:   line{point{100, 0}, point{100, 20}},
			want: point{100, 10},
			ok:   true,
		},
		"WhyParallelWithSteepLine": {
			l1:   line{point{100, 0}, point{100, 20}},
			l2:   line{point{0, 5}, point{100, 10}},
			want: point{100, 10},
			ok:   true,
		},
		"SteepLineWithXParallelLine": {
			l1:   line{point{0, 0}, point{100, 100}},
			l2:   line{point{0, 50}, point{100, 50}},
			want: point{50, 50},
			ok:   true,
		},
		"ParallelLines": {
			l1: line{point{0, 0}, point{100, 0}},
			l2: line{point{0, 50}, point{100, 50}},
		},
		"ParallelLines2": {
			l1: line{point{0, 0}, point{-100, 0}},
			l2: line{point{0, 50}, point{100, 50}},
		},
		"ParallelLines3": {
			l1: line{point{0, 0}, point{0, 100}},
			l2: line{point{50, 0}, point{50, 100}},
		},
		"ParallelLines4": {
			l1: line{point{0, 0}, point{0, -100}},
			l2: line{point{50, 0}, point{50, 100}},
		},
		"SamePoints": {
			l1: line{point{0, 0}, point{0, 0}},
			l2: line{point{0, 0}, point{0, 0}},
		},
	}

	// todo +inf, -inf

	for name, test := range tests {
		t.Run(name, func(t *testing.T) {
			got, ok := findIntersection(test.l1, test.l2)
			if ok != test.ok {
				t.Fatalf("want ok %v, got %v", test.ok, got)
			}

			if test.want != got {
				t.Fatalf("want %v, got: %v", test.want, got)
			}
		})
	}
}
