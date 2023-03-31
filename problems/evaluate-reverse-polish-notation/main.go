// You are given an array of strings tokens that represents an arithmetic
// expression in a Reverse Polish Notation.
// 
// Evaluate the expression. Return an integer that represents the value
// of the expression.
// 
// Note that:
// - The valid operators are '+', '-', '*', and '/'.
// - Each operand may be an integer or another expression.
// - The division between two integers always truncates toward zero.
// - There will not be any division by zero.
// - The input represents a valid arithmetic expression in a reverse polish notation.
// - The answer and all the intermediate calculations can be represented in a 32-bit integer.
//
// Example 1:
// 
// Input: tokens = ["2","1","+","3","*"]
// Output: 9
// Explanation: ((2 + 1) * 3) = 9
//
// Example 2:
// 
// Input: tokens = ["4","13","5","/","+"]
// Output: 6
// Explanation: (4 + (13 / 5)) = 6
// Example 3:
// 
// Input: tokens = ["10","6","9","3","+","-11","*","/","*","17","+","5","+"]
// Output: 22
// Explanation: ((10 * (6 / ((9 + 3) * -11))) + 17) + 5
// = ((10 * (6 / (12 * -11))) + 17) + 5
// = ((10 * (6 / -132)) + 17) + 5
// = ((10 * 0) + 17) + 5
// = (0 + 17) + 5
// = 17 + 5
// = 22
//
// https://leetcode.com/problems/evaluate-reverse-polish-notation/

package main

import "strconv"

func main() {

}

func evalRPN(tokens []string) int {
	s := newStack()

	for _, t := range tokens {
		num, err := strconv.Atoi(t)

		// if err != nil then it is an operator
		if err != nil {
			op1 := s.pop()
			op2 := s.pop()
			res := applyOperator(t, op2, op1)
			s.push(res)
		} else {
			s.push(num)
		}
	}

	return s.pop()
}

func applyOperator(operator string, operand1, operand2 int) int {
	switch operator {
	case "*":
		return operand1 * operand2
	case "/":
		return operand1 / operand2
	case "-":
		return operand1 - operand2
	default: // +
		return operand1 + operand2
	}
}

type node struct {
	val  int
	next *node
}

type stack struct {
	top *node
}

func newStack() *stack {
	return &stack{}
}

func (s *stack) push(val int) {
	n := &node{
		val:  val,
		next: s.top,
	}

	s.top = n
}

func (s *stack) pop() int {
	if s.top == nil {
		return 0
	}

	val := s.top.val
	s.top = s.top.next

	return val
}
