// Coins: Given an infinite number of quarters (25 cents), dimes (10
// cents), nickels (5 cents), and pennies (1 cent), write code to
// calculate the number of ways of representing n cents.
//
// https://leetcode.com/problems/coin-change-2/

package main

import (
	"fmt"
	"sort"
)

func main() {
	amount := 10
	coins := []int{1, 2, 5}
	fmt.Println(change(amount, coins))
}

func change(amount int, coins []int) int {
	sort.Ints(coins)

	m := make([][]int, len(coins)+1)
	for i := 0; i < len(m); i++ {
		m[i] = make([]int, amount+1)
		m[i][0] = 1
	}

	for i := 1; i < len(coins)+1; i++ {
		for a := 1; a <= amount; a++ {
			c := coins[i-1]
			sum := m[i-1][a]
			if a-c >= 0 {
				sum += m[i][a-c]
			}
			m[i][a] = sum
		}
	}

	return m[len(coins)][amount]
}
