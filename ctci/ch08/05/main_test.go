package main

import "testing"

func TestMultiply(t *testing.T) {
	tests := map[string]struct {
		a    int
		b    int
		want int
	}{
		"1x1": {
			a:    1,
			b:    1,
			want: 1,
		},
		"2x1": {
			a:    2,
			b:    1,
			want: 2,
		},
		"1x2": {
			a:    1,
			b:    2,
			want: 2,
		},
		"5x5": {
			a:    5,
			b:    5,
			want: 25,
		},
		"100x47": {
			a:    100,
			b:    47,
			want: 4700,
		},
		"21x21": {
			a:    21,
			b:    21,
			want: 441,
		},
	}

	for name, test := range tests {
		t.Run(name, func(t *testing.T) {
			got := multiply(test.a, test.b)
			if got != test.want {
				t.Errorf("got: %d, want: %d", got, test.want)
			}
		})
	}
}
