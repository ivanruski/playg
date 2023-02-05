package main

import "testing"

func TestPalindromePermutation(t *testing.T) {
	tests := map[string]struct {
		input string
		want  bool
	}{
		"": {
			input: "",
		},
		"ivan": {
			input: "ivan",
		},
		"Tact Coa": {
			input: "Tact Coa",
			want:  true,
		},
		"Ivan aaa navI": {
			input: "Ivan aaa navI",
			want:  true,
		},
		"Str !@#$1234 str r": {
			input: "Str !@#$1234 str r",
			want:  true,
		},
	}

	for n, test := range tests {
		t.Run(n, func(t *testing.T) {
			got := PalindromePermutation(test.input)
			if got != test.want {
				t.Errorf("Got: %v, want: %v", got, test.want)
			}
		})
	}
}
