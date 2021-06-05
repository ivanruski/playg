// Exercise 9.5: Write a program with two goroutines that send
// messages back and forth over two unbuffered channels in ping-pong
// fashion. How many communications per second can the program
// sustain?

package main

import (
	"fmt"
	"time"
)

func main() {
	ch1 := make(chan int)
	ch2 := make(chan int)
	done := make(chan struct{})
	result := make(chan int, 2)

	go func(send chan<- int, receive <-chan int) {
	loop:
		for {
			select {
			case num, ok := <-receive:
				if ok {
					num++
					send <- num
				}
			case <-done:
				break loop
			}
		}
		result <- <-receive
		close(send)
	}(ch1, ch2)

	go func(send chan<- int, receive <-chan int) {
	loop:
		for {
			select {
			case num, ok := <-receive:
				if ok {
					num++
					send <- num
				}
			case <-done:
				break loop
			}
		}
		result <- <-receive
		close(send)
	}(ch2, ch1)

	ch2 <- 0
	time.Sleep(1 * time.Second)
	close(done)
	num, num2 := <-result, <-result
	if num == 0 {
		num = num2
	}

	fmt.Printf("message ping ponged %d\n", num)
}
