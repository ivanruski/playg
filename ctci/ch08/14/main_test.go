package main

import (
	"sort"
	"strconv"
	"strings"
	"testing"
)

func TestParenExpr(t *testing.T) {
	tests := []struct {
		input string
		want  []string
	}{
		{
			input: "a",
			want: []string{
				"a",
			},
		},
		{
			input: "a|b",
			want: []string{
				"a|b",
			},
		},
		{
			input: "a|b|c",
			want: []string{
				"(a|b)|c",
				"a|(b|c)",
			},
		},
		{
			input: "d|a|b|c",
			want: []string{
				"d|((a|b)|c)",
				"d|(a|(b|c))",

				"(d|a)|(b|c)",

				"((d|a)|b)|c",
				"(d|(a|b))|c",
			},
		},
		{
			input: "f|d|a|b|c",
			want: []string{
				"f|(d|((a|b)|c))",
				"f|(d|(a|(b|c)))",
				"f|((d|a)|(b|c))",
				"f|(((d|a)|b)|c)",
				"f|((d|(a|b))|c)",
				"(f|d)|((a|b)|c)",
				"(f|d)|(a|(b|c))",
				"((f|d)|a)|(b|c)",
				"(f|(d|a))|(b|c)",
				"(f|((d|a)|b))|c",
				"(f|(d|(a|b)))|c",
				"((f|d)|(a|b))|c",
				"(((f|d)|a)|b)|c",
				"((f|(d|a))|b)|c",
			},
		},
	}

	for i, test := range tests {
		t.Run(strconv.Itoa(i), func(t *testing.T) {
			result := parenExpr([]rune(test.input))
			got := make([]string, 0, len(result))
			for _, r := range result {
				got = append(got, string(r))
			}

			sort.Strings(got)
			sort.Strings(test.want)
			if !areSlicesEqual(got, test.want) {
				t.Fatalf("got:\n%s\nwant:\n%s", strings.Join(got, "\n"), strings.Join(test.want, "\n"))
			}
		})
	}
}

func TestEvalExpr(t *testing.T) {
	tests := []struct {
		input string
		want  int
	}{
		{input: "0&0", want: 0},
		{input: "0|0", want: 0},
		{input: "0^1", want: 1},

		{input: "1&1", want: 1},
		{input: "1|1", want: 1},
		{input: "1^0", want: 1},

		{input: "(1&0)^1", want: 1},

		{input: "(((1&0)^1)|0)^1", want: 0},
		{input: "1&((0^(1|0))^1)", want: 0},
		{input: "((1^(1^1))^1)^1", want: 1},
		{input: "((0^(0^0))^0)^0", want: 0},

		{input: "0|((1&(0&1))|(0^1))", want: 1},
		{input: "(0|1)&((0&1)|(0^1))", want: 1},
		{input: "(0|(1&0))&((1|0)^1)", want: 0},
		{input: "(0|(1&(0&(1|0))))^1", want: 1},
		{input: "((0|1)&(0&(1|0)))^1", want: 1},
		{input: "(((0|(1&0))&1)|0)^1", want: 1},

		{input: "((1^((0|((1&0)&1))|0))^1)^0", want: 0},
		{input: "((((((1^0)|1)&0)&1)|0)^1)^0", want: 1},
		{input: "((((((1^0)^0)^0)^0)^0)^0)^0", want: 1},

		{input: "1|(1|(1|(1|(1|(1^(1&(0^1)))))))", want: 1},
	}

	mem = map[string]int{}
	for i, test := range tests {
		t.Run(strconv.Itoa(i), func(t *testing.T) {
			got := evalExpr([]rune(test.input))
			if got != test.want {
				t.Fatalf("got: %d, want: %d", got, test.want)
			}
		})
	}
}

func areSlicesEqual(a, b []string) bool {
	if len(a) != len(b) {
		return false
	}

	for i := 0; i < len(a); i++ {
		if a[i] != b[i] {
			return false
		}
	}
	return true
}
