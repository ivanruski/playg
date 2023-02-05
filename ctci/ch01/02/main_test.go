package main

import "testing"

func TestCheckPermutation(t *testing.T) {
	tests := map[string]struct {
		s1   string
		s2   string
		want bool
	}{
		"ivan-ivan": {
			s1:   "ivan",
			s2:   "ivan",
			want: true,
		},
		"ivan-navi": {
			s1:   "ivan",
			s2:   "navi",
			want: true,
		},
		"emptyStrings": {
			want: true,
		},
		"ivaaan-ivaan": {
			s1: "ivaaan",
			s2: "ivaan",
		},
		"ivaaan-ivaaam": {
			s1: "ivaaan",
			s2: "ivaaam",
		},
	}

	for n, test := range tests {
		t.Run(n, func(t *testing.T) {
			got := CheckPermutation(test.s1, test.s2)
			if got != test.want {
				t.Errorf("got %v, want: %v", got, test.want)
			}
		})
	}
}
