// Copyright © 2016 Alan A. A. Donovan & Brian W. Kernighan.
// License: https://creativecommons.org/licenses/by-nc-sa/4.0/

package bank

import (
	"testing"
)

func TestBank(t *testing.T) {
	cancel := make(chan struct{})
	go teller(cancel)

	done := make(chan struct{})

	// Alice
	go func() {
		Deposit(200)
		done <- struct{}{}
	}()

	// Bob
	go func() {
		Deposit(100)
		done <- struct{}{}
	}()

	// Wait for both transactions.
	<-done
	<-done

	if got, want := Balance(), 300; got != want {
		t.Errorf("Balance = %d, want %d", got, want)
	}
	cancel <- struct{}{}
}

func TestWithdraws(t *testing.T) {
	cancel := make(chan struct{})
	go teller(cancel)

	done := make(chan struct{})
	Deposit(200)
	go func() {
		Deposit(300)
		done <- struct{}{}
	}()

	go func() {
		ok := Withdraw(200)
		if !ok {
			t.Error("withdraw failed")
		}
		done <- struct{}{}
	}()

	<-done
	<-done
	if got, want := Balance(), 300; got != want {
		t.Errorf("Balance = %d, want %d", got, want)
	}
	cancel <- struct{}{}
}
