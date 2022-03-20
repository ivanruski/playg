package main

import "testing"

func TestIsUnique(t *testing.T) {
	tests := map[string]struct {
		input    string
		isUnique bool
	}{
		"EmptyString": {
			input: "",
		},
		"aa": {
			input: "aa",
		},
		"ab": {
			input:    "ab",
			isUnique: true,
		},
		"кирилица": {
			input: "кирилица",
		},
		"asdf!@#$^&*(": {
			input:    "asdf!@#$^&*(",
			isUnique: true,
		},
		"世界世somechars": {
			input: "世界世somechars",
		},
		"界世somechar": {
			input:    "界世somechar",
			isUnique: true,
		},
	}

	for n, test := range tests {
		t.Run(n, func(t *testing.T) {
			got := IsUnique(test.input)
			if got != test.isUnique {
				t.Errorf("Got %v, want: %v", got, test.isUnique)
			}
		})
	}
}
