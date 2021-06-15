package main

import "testing"

func TestCoinChange(t *testing.T) {
	tests := map[string]struct {
		coins  []int
		amount int
		result int
	}{
		"impossibleCase1": {
			coins:  []int{3},
			amount: 4,
			result: -1,
		},
		"coin==amoint": {
			coins:  []int{50},
			amount: 50,
			result: 1,
		},
		"coin(1)_amount(1000)": {
			coins:  []int{1},
			amount: 1000,
			result: 1000,
		},
		"coin(1,2,5)_amount(11)": {
			coins:  []int{1, 2, 5},
			amount: 11,
			result: 3,
		},
		"trickyCase1": {
			coins:  []int{83, 186, 408, 419},
			amount: 6249,
			result: 20,
		},
		"trickyCase2": {
			coins:  []int{1, 20, 50},
			amount: 60,
			result: 3,
		},
		"trickyCase3": {
			coins:  []int{2, 5},
			amount: 11,
			result: 4,
		},
		"trickyCase4": {
			coins:  []int{484, 395, 346, 103, 329},
			amount: 4259,
			result: 11,
		},
		"trickyCase5": {
			coins:  []int{3, 7, 405, 436},
			amount: 8839,
			result: 25,
		},
		"slowTest1": {
			coins:  []int{411, 412, 413, 414, 415, 416, 417, 418, 419, 420, 421, 422},
			amount: 9864,
			result: 24,
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
