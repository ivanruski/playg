package main

import (
	"testing"
)

func TestSwapNums(t *testing.T) {
	tests := map[string]struct {
		a int
		b int
	}{
		"Positive": {
			a: 5,
			b: 3,
		},
		"Negative": {
			a: -5,
			b: -3,
		},
		"PosNeg": {
			a: 5,
			b: -3,
		},
		"NegPos": {
			a: -5,
			b: 3,
		},
		"Equal": {
			a: 5,
			b: 5,
		},
		"ZeroX": {
			a: 0,
			b: 5,
		},
		"XZero": {
			a: 5,
			b: 0,
		},
		"Zeroes": {
			a: 0,
			b: 0,
		},
	}

	for name, test := range tests {
		t.Run(name, func(t *testing.T) {
			acopy := test.a
			bcopy := test.b

			swapNums(&test.a, &test.b)

			if acopy != test.b || bcopy != test.a {
				t.Errorf("want: a = %d, b = %d, got: a = %d, b = %d", bcopy, acopy, test.a, test.b)
			}
		})
	}
}
