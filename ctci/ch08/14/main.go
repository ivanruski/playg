// Boolean Evaluation: Given a boolean expression consisting of the
// symbols 0 (false), 1 (true), & (AND), | (OR), and ^ (XOR), and a
// desired boolean result value result, implement a function to count
// the number of ways of parenthesizing the expression such that it
// evaluates to result. The expression should be fully parenthesized
// (e.g., (0)^(1)) but not extraneously (e.g. (((0))^(1)))
//
// EXAMPLE
// countEval("1^0|0|1", false) -> 2
// countEval("0&0&0&1^1|0", true) -> 10

package main

import (
	"fmt"
	"strconv"
)

func main() {
	mem = map[string]int{}
	exprs := parenExpr([]rune("1&0^1"))
	for _, expr := range exprs {
		fmt.Printf("%s - d\n", string(expr))
	}

}

var mem map[string]int

func countEval(expr string, v bool) int {
	mem = map[string]int{}
	exprs := parenExpr([]rune(expr))

	var want int
	if v {
		want = 1
	}
	var result int
	for _, expr := range exprs {
		got := evalExpr(expr)
		if want == got {
			result++
		}
	}

	return result
}

func parenExpr(expr []rune) [][]rune {
	if len(expr) == 1 || len(expr) == 3 {
		return [][]rune{expr}
	}

	result := [][]rune{}
	for i, s := range expr {
		if s == '&' || s == '|' || s == '^' {
			pl := parenExpr(expr[:i])
			pr := parenExpr(expr[i+1:])
			for _, l := range pl {
				for _, r := range pr {
					result = append(result, concat(l, r, s))
				}
			}
		}

	}

	return result
}

func evalExpr(expr []rune) int {
	if len(expr) == 1 {
		num, _ := strconv.Atoi(string(expr))
		mem[string(expr)] = num
		return num
	}

	getLeftSubExpr := func(expr []rune) []rune {
		if expr[0] == '0' || expr[0] == '1' {
			return expr[0:1]
		}

		o, c := 1, 0
		for i := 1; i < len(expr); i++ {
			if expr[i] == '(' {
				o++
			} else if expr[i] == ')' {
				c++
			}

			if o == c {
				return expr[0 : i+1]
			}
		}

		panic("invalid expression")
	}

	lo := getLeftSubExpr(expr)
	op := expr[len(lo) : len(lo)+1]
	ro := expr[len(lo)+len(op):]
	assert := func(l, o, r []rune) {
		e := string(l) + string(o) + string(r)
		if e != string(expr) {
			panic(fmt.Sprintf("got: %s, want: %s", e, string(expr)))
		}
	}
	assert(lo, op, ro)

	// reduce the enclosing parenthesis
	if lo[0] == '(' && lo[len(lo)-1] == ')' {
		lo = lo[1 : len(lo)-1]
	}
	if ro[0] == '(' && ro[len(ro)-1] == ')' {
		ro = ro[1 : len(ro)-1]
	}

	l := evalExpr(lo)
	r := evalExpr(ro)
	switch op[0] {
	case '&':
		return l & r
	case '|':
		return l | r
	default:
		return l ^ r
	}
}

func concat(l, r []rune, op rune) []rune {
	var result []rune
	if len(l) == 1 {
		result = append(result, l[0])
	} else {
		result = []rune{'('}
		result = append(result, l...)
		result = append(result, ')')
	}

	result = append(result, op)

	if len(r) == 1 {
		result = append(result, r[0])
	} else {
		result = append(result, '(')
		result = append(result, r...)
		result = append(result, ')')
	}

	return result
}
