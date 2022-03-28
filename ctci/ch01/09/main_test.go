package main

import "testing"

func TestStringRotation(t *testing.T) {
	tests := map[string]struct {
		s1   string
		s2   string
		want bool
	}{
		"Empty s1 and s2": {},
		"s1: waterbottle, s2: erbottlewat": {
			s1: "watterbotle",
			s2: "erbottlewat",
		},
		"s1: lalal, s2:alall": {
			s1:   "lalal",
			s2:   "alall",
			want: true,
		},
		"s1: lalal, s2: alala": {
			s1: "lalal",
			s2: "alala",
		},
		"s1: abcd, s2: bcda": {
			s1:   "abcd",
			s2:   "bcda",
			want: true,
		},
		"s1: abcd, s2: bdca": {
			s1: "abcd",
			s2: "bdca",
		},
	}

	for name, test := range tests {
		t.Run(name, func(t *testing.T) {
			got := StringRotation(test.s1, test.s2)
			if got != test.want {
				t.Errorf("Got: %v, want: %v", got, test.want)
			}
		})
	}
}
