// Exercise 8.4: Modify the reverb2 server to use a sync.WaitGroup per
// connection to count the number of active echo goroutines. When it
// falls to zero, close the write half of the TCP connection as
// described in Exercise 8.3. Verify that your modified netcat3 client
// from that exercise waits for the final echoes of multiple
// concurrent shouts, even after the standard input has been closed.

package main

import (
	"bufio"
	"fmt"
	"log"
	"net"
	"strings"
	"sync"
	"time"
)

func echo(c net.Conn, shout string, delay time.Duration) {
	fmt.Fprintln(c, "\t", strings.ToUpper(shout))
	time.Sleep(delay)
	fmt.Fprintln(c, "\t", shout)
	time.Sleep(delay)
	fmt.Fprintln(c, "\t", strings.ToLower(shout))
}

//!+
func handleConn(c net.Conn) {
	wg := sync.WaitGroup{}
	input := bufio.NewScanner(c)
	wgchan, scannerchan := make(chan bool), make(chan bool)

	go func() {
		wgActivated := false
		for input.Scan() {
			if wgActivated == false {
				go func() {
					wg.Wait()
					wgchan <- true
				}()
			}
			scannerchan <- true
		}
	}()

	for {
		select {
		case <-wgchan:
			c.(*net.TCPConn).CloseWrite()
			return
		case <-scannerchan:
			wg.Add(1)
			go func() {
				echo(c, input.Text(), 2*time.Second)
				wg.Done()
			}()
		}
	}
}

//!-

func main() {
	l, err := net.Listen("tcp", "localhost:8000")
	if err != nil {
		log.Fatal(err)
	}
	for {
		conn, err := l.Accept()
		if err != nil {
			log.Print(err) // e.g., connection aborted
			continue
		}
		go handleConn(conn)
	}
}
