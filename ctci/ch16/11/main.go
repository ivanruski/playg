// Diving Board: You are building a diving board by placing a bunch of
// planks of wood end-to-end. There are two types of planks, one of
// length "shorter" and one of length "longer". You must use exactly K
// planks of wood. Write a method to generate all possible length for
// the diving board.
//
// I didn't get the problem at first and had to look up the solution.
// There is a faster solution using DP.

package main

import "fmt"

func main() {
	fmt.Println(divingBoard1(3, 9, 15))
	fmt.Println(divingBoard2(3, 9, 15))
}

func divingBoard1(s, l, k int) int {
	cnt := map[int]struct{}{}
	findTotal(0, k, s, l, cnt)
	return len(cnt)
}

func findTotal(total, k, s, l int, cnt map[int]struct{}) {
	if k == 0 {
		cnt[total] = struct{}{}
		return
	}

	findTotal(total+s, k-1, s, l, cnt)
	findTotal(total+l, k-1, s, l, cnt)
}

// TODO: Solve using DP.
