package main

import (
	"fmt"
	"os"
	"strings"
	"strconv"
)

func main() {
	b, err := os.ReadFile("input.txt")
  if err != nil {
		fmt.Println(err)
	}
  
	fmt.Println(mul2(string(b), true))
	
}

func mul(s string) int {
	i := strings.Index(s, "mul(")
	if i == -1 {
		return 0
	}

	s = s[i+4:]
	i = strings.Index(s, ",")
	if i == -1 {
		return 0
	}

	op1, err := strconv.Atoi(s[:i])
	if err != nil {
		return mul(s)
	}

	s = s[i+1:]
	i = strings.Index(s, ")")
	if i == -1 {
		return 0
	}

	op2, err := strconv.Atoi(s[:i])
	if err != nil {
		return mul(s)
	}

	s = s[i+1:]
	return (op1 * op2) + mul(s)
}

func mul2(s string, do bool) int {
	if do {
		i := strings.Index(s, "don't()")
	  if i == -1 {
		  return mul(s)
	  }

		return mul(s[:i]) + mul2(s[i+6:], false)
	}

	i := strings.Index(s, "do()")
	if i == -1 {
		return 0
	}

	return mul2(s[i+4:], true)
}
