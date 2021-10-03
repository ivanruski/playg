// You are given an integer array coins representing coins of
// different denominations and an integer amount representing a total
// amount of money.
//
// Return the fewest number of coins that you need to make up that
// amount. If that amount of money cannot be made up by any
// combination of the coins, return -1.
//
// You may assume that you have an infinite number of each kind of
// coin.

// Example 1:
// Input: coins = [1,2,5], amount = 11
// Output: 3
// Explanation: 11 = 5 + 5 + 1
//
// Example 2:
// Input: coins = [2], amount = 3
// Output: -1
//
// Example 3:
// Input: coins = [1], amount = 0
// Output: 0
//
// Example 4:
// Input: coins = [1], amount = 1
// Output: 1
//
// Example 5:
// Input: coins = [1], amount = 2
// Output: 2

// Constraints:
//
// 1 <= coins.length <= 12
// 1 <= coins[i] <= 2^31 - 1
// 0 <= amount <= 10^4

package main

import (
	"fmt"
	"math"
	"sort"
)

func main() {
	var (
		coins  = []int{186, 419, 83, 408} // []int{484, 395, 346, 329, 103} // []int{3, 7, 405, 436}
		amount = 6249                     // 4259                          // 8839
	)
	fmt.Println(coinChange(coins, amount))
}

func coinChange(coins []int, amount int) int {
	sort.Ints(coins)
	allAmounts := make([]int, amount+1)

	// The fewest amout of coins for the zero coin is zero
	allAmounts[0] = 0
	for a := 1; a < len(allAmounts); a++ {

		// Find the coin that when substracted will result in an amount
		// the is represented by the least number of coins
		var c, least int = 0, math.MaxInt
		for i := len(coins) - 1; i >= 0; i-- {
			if a-coins[i] < 0 || allAmounts[a-coins[i]] == -1 {
				continue
			}

			if allAmounts[a-coins[i]] < least {
				c = coins[i]
				least = allAmounts[a-coins[i]]
			}
		}
		if c == 0 {
			allAmounts[a] = -1
		} else {
			allAmounts[a] = allAmounts[a-c] + 1
		}
	}

	return allAmounts[amount]
}
