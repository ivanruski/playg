package main

import "testing"

func TestCoinChange(t *testing.T) {
	tests := map[string]struct {
		coins  []int
		amount int
		result int
	}{
		"coins=[]_amount=1": {
			amount: 1,
			result: -1,
		},
		"coins=[]_amount=0": {
			amount: 0,
			result: 0,
		},
		"coins=[1,2,5]_amount=20": {
			coins:  []int{1, 2, 5},
			amount: 20,
			result: 4,
		},
		"coins=[7,8]_amount=20": {
			coins:  []int{7, 8},
			amount: 20,
			result: -1,
		},
		"coins=[10]_amount=9": {
			coins:  []int{10},
			amount: 9,
			result: -1,
		},
		"coins=[1,7,9]_amount=21": {
			coins:  []int{1, 7, 9},
			amount: 21,
			result: 3,
		},
	}

	for n, c := range tests {
		t.Run(n, func(t *testing.T) {
			r := coinChange(c.coins, c.amount)
			if r != c.result {
				t.Errorf("got: %d, want: %d", r, c.result)
			}
		})
	}
}
