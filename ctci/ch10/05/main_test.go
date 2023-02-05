package main

import (
	"strconv"
	"testing"
)

func TestSearch(t *testing.T) {
	tests := []struct {
		input []string
		s     string
		want  int
	}{
		{
			input: []string{"a", "", "", "", "", "", "z"},
			s:     "b",
			want:  -1,
		},
		{
			input: []string{"a", "", "", "", "", "", "z"},
			s:     "a",
			want:  0,
		},
		{
			input: []string{"a", "", "", "", "", "", "z"},
			s:     "z",
			want:  6,
		},
		{
			input: []string{"a"},
			s:     "a",
			want:  0,
		},
		{
			input: []string{"a", "b", "c", "d", "e", "f", "g"},
			s:     "g",
			want:  6,
		},
		{
			input: []string{"a", "b", "c", "d", "e", "f", "g"},
			s:     "g",
			want:  6,
		},
		{
			input: []string{"b", "c", "d", "e", "f", "g"},
			s:     "a",
			want:  -1,
		},
		{
			input: []string{"a", "b", "c", "d", "e", "f", "g"},
			s:     "z",
			want:  -1,
		},
	}

	for i, test := range tests {
		t.Run(strconv.Itoa(i), func(t *testing.T) {
			got := search(test.input, test.s)
			if got != test.want {
				t.Errorf("got: %d, want: %d", got, test.want)
			}
		})
	}
}
