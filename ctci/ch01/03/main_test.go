package main

import (
	"reflect"
	"testing"
)

func TestURLify(t *testing.T) {
	tests := map[string]struct {
		input string
		slen  int
		want  string
	}{
		"Mr John Smith": {
			input: "Mr John Smith    ",
			slen:  13,
			want:  "Mr%20John%20Smith",
		},
		"Ivan Ivanov": {
			input: "Ivan Ivanov  ",
			slen:  11,
			want:  "Ivan%20Ivanov",
		},
		"Ivan Ivanov with more sufficient space": {
			input: "Ivan Ivanov        ",
			slen:  11,
			want:  "Ivan%20Ivanov      ",
		},
		"Ivan Ivanov ": {
			input: "Ivan Ivanov        ",
			slen:  12,
			want:  "Ivan%20Ivanov%20   ",
		},
		"a20spacesb ": {
			input: "a                    b                                             ",
			slen:  23,
			want:  "a%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20b%20  ",
		},
		" ivan": {
			input: " ivan  ",
			slen:  5,
			want:  "%20ivan",
		},
		"ivan": {
			input: "ivan",
			slen:  4,
			want:  "ivan",
		},
	}

	for n, test := range tests {
		t.Run(n, func(t *testing.T) {
			got := URLify([]rune(test.input), test.slen)
			if got != test.want {
				t.Errorf("Got: %s, want: %s", got, test.want)
			}
		})
	}
}

func TestInsertSlice(t *testing.T) {
	tests := map[string]struct {
		r       []rune
		insert  []rune
		startAt int
		want    []rune
	}{
		"Insert 12 into abcd starting at 1": {
			r:       []rune("abcd  "),
			insert:  []rune("12"),
			startAt: 1,
			want:    []rune("a12bcd"),
		},
		"Insert 12 into abcd starting at 0": {
			r:       []rune("abcd  "),
			insert:  []rune("12"),
			startAt: 0,
			want:    []rune("12abcd"),
		},
		"Insert %20 into ab cd starting at 2": {
			r:       []rune("abcd   "),
			insert:  []rune("%20"),
			startAt: 2,
			want:    []rune("ab%20cd"),
		},
		"Insert %20 into Mr John Smith starting at 2": {
			r:       []rune("MrJohn Smith   "),
			insert:  []rune("%20"),
			startAt: 2,
			want:    []rune("Mr%20John Smith"),
		},
		"Insert 345 into 012abc starting at 3": {
			r:       []rune("012abc"),
			insert:  []rune("345"),
			startAt: 3,
			want:    []rune("012345"),
		},
	}

	for n, test := range tests {
		t.Run(n, func(t *testing.T) {
			insertSlice(test.r, test.insert, test.startAt)
			if !reflect.DeepEqual(test.r, test.want) {
				t.Errorf("got: %s, want: %s", string(test.r), string(test.want))
			}
		})
	}
}
