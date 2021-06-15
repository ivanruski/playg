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
	coins := []int{484, 395, 346, 329, 103} // []int{3, 7, 405, 436}
	amount := 4259                          // 8839
	fmt.Println(coinChange(coins, amount))
}

func coinChange(coins []int, amount int) int {
	if amount == 0 {
		return 0
	}
	sort.Ints(coins)
	memo := make([][]int, amount+1, amount+1)
	for i := 0; i < len(memo); i++ {
		memo[i] = make([]int, len(coins)+1, len(coins)+1)
	}
	coinChange2(coins, amount, memo)
	min := math.MaxInt64
	for _, n := range memo[amount] {
		if n < min && n != 0 {
			min = n
		}
	}

	if min == math.MaxInt64 {
		return -1
	}
	return min
}

func coinChange2(coins []int, amount int, memo [][]int) int {
	if len(coins) == 0 || amount < 0 {
		return math.MaxInt64
	}
	if amount == 0 {
		return 0
	}
	if memo[amount][len(coins)] != 0 {
		return memo[amount][len(coins)]
	}

	ln := len(coins)
	largest := coins[ln-1]
	r := coinChange2(coins, amount-largest, memo)
	l := coinChange2(coins[:ln-1], amount, memo)

	if l < r || (l != math.MaxInt64 && l == r) {
		memo[amount][ln] = l
		return l
	}
	if r < l {
		memo[amount][ln] = r + 1
		return r + 1
	}

	memo[amount][ln] = math.MaxInt64
	return math.MaxInt64
}
