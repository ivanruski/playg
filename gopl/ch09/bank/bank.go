// Copyright © 2016 Alan A. A. Donovan & Brian W. Kernighan.
// License: https://creativecommons.org/licenses/by-nc-sa/4.0/

// See page 261.
//!+

// Package bank provides a concurrency-safe bank with one account.
package bank

type withdrawRequest struct {
	amount int
	result chan<- bool
}

var deposits = make(chan int) // send amount to deposit
var balances = make(chan int) // receive balance
var withdraws = make(chan withdrawRequest)

func Deposit(amount int) { deposits <- amount }
func Balance() int       { return <-balances }

// Exercise 9.1: Add a function Withdraw(amount int) bool to the
// gopl.io/ch9/bank1 program. The result should indicate whether the
// transaction succeeded or failed due to insufficient funds. The
// message sent to the monitor goroutine must contain both the amount
// to withdraw and a new channel over which the monitor goroutine can
// send the boolean result back to Withdraw.
func Withdraw(amount int) bool {
	res := make(chan bool)
	withdraw := withdrawRequest{
		amount: amount,
		result: res,
	}
	withdraws <- withdraw
	return <-res
}

func teller(done <-chan struct{}) {
	var balance int // balance is confined to teller goroutine
	for {
		select {
		case amount := <-deposits:
			balance += amount
		case balances <- balance:
		case w := <-withdraws:
			res := false
			if w.amount <= balance {
				balance -= w.amount
				res = true
			}
			w.result <- res
		case <-done:
			return
		}
	}
}

func init() {
	// go teller() // start the monitor goroutine
}

//!-
