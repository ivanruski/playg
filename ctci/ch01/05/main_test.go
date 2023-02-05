package main

import "testing"

func TestOneAway(t *testing.T) {
	tests := map[string]struct {
		one  string
		two  string
		want bool
	}{
		// same lengths
		"two empty strings": {
			one:  "",
			two:  "",
			want: true,
		},
		"one: ivan, two: ivan": {
			one:  "ivan",
			two:  "ivan",
			want: true,
		},
		"one: pale, two: bale": {
			one:  "pale",
			two:  "bale",
			want: true,
		},
		"one: pale, two: bake": {
			one: "pale",
			two: "bake",
		},
		"one: string, two: strink": {
			one:  "string",
			two:  "strink",
			want: true,
		},
		"one: ztring, two: string": {
			one:  "ztring",
			two:  "string",
			want: true,
		},
		"one: Иvan, two: Ivan": {
			one:  "Иvan",
			two:  "Ivan",
			want: true,
		},
		"one: ivan, two: vani": {
			one:  "ivan",
			two:  "vani",
			want: false,
		},
		// more than 1 diff length
		"one: ivan, two: ivannn": {
			one: "ivan",
			two: "ivannn",
		},
		// 1 diff length
		"one: pale, two: ple": {
			one:  "pale",
			two:  "ple",
			want: true,
		},
		"one: pales, two: pale": {
			one:  "pales",
			two:  "pale",
			want: true,
		},
		"one: pale, two: pales": {
			one:  "pale",
			two:  "pales",
			want: true,
		},
		"one: acd, two: abcd": {
			one:  "acd",
			two:  "abcd",
			want: true,
		},
		"one: abcd, two: zbcy": {
			one: "abcd",
			two: "zbcy",
		},
	}

	for name, test := range tests {
		t.Run(name, func(t *testing.T) {
			got := OneAway(test.one, test.two)
			if got != test.want {
				t.Errorf("Got: %v, want: %v", got, test.want)
			}
		})
	}
}
