// Write an algorithm to determine if a number n is happy.
//
// A happy number is a number defined by the following process:
//
// 1. Starting with any positive integer, replace the number by the sum of the
// squares of its digits.
//
// 2. Repeat the process until the number equals 1 (where it will stay), or it
// loops endlessly in a cycle which does not include 1.
//
// 3. Those numbers for which this process ends in 1 are happy.
//
// Return true if n is a happy number, and false if not.
//
// Example 1:
// n = 19 - true
// 1 + 81 = 82
// 64 + 4 = 68
// 36 + 64 = 100
// 1 + 0 + 0 = 1
//
// Example 2:
// n = 2 - false
//
// link: https://leetcode.com/problems/happy-number/

package main

import "fmt"

func main() {
	fmt.Println(isHappy(68))
}

func isHappy(n int) bool {
	m := map[int]struct{}{}
	for {
		_, ok := m[n]
		if ok {
			break
		}
		m[n] = struct{}{}
		n = getSumOfSquares(n)
		if n == 1 {
			return true
		}
	}
	return false
}

func getSumOfSquares(n int) int {
	var sum int
	digits := getNumDigits(n)
	for _, d := range digits {
		sum += (d * d)
	}
	return sum
}

func getNumDigits(n int) []int {
	digits := []int{}
	for n > 9 {
		digits = append(digits, n%10)
		n /= 10
	}
	digits = append(digits, n)

	result := make([]int, len(digits))
	for i := 0; i < len(digits); i++ {
		result[i] = digits[len(digits)-i-1]
	}

	return result
}
