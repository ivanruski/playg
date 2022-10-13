package main

import (
	"strconv"
	"testing"
)

func TestSplit(t *testing.T) {
	tests := []struct {
		num numberStr
		n   numberStr
		rl  int
	}{
		{num: "1", n: "1", rl: 0},
		{num: "10", n: "10", rl: 0},
		{num: "100", n: "100", rl: 0},

		{num: "1000", n: "1", rl: 3},
		{num: "10000", n: "10", rl: 3},
		{num: "100000", n: "100", rl: 3},

		{num: "1000000", n: "1", rl: 6},
	}

	for i, test := range tests {
		t.Run(strconv.Itoa(i), func(t *testing.T) {
			n, rl := split(test.num)
			if n != test.n || rl != test.rl {
				t.Errorf("want: (%v, %d), got: (%v, %d)", test.n, test.rl, n, rl)
			}
		})
	}
}
