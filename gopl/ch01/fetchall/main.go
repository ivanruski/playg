// Exercise 1.10 Find a web site that produces a large amount of
// data. Investigate caching by running fetchall twice in succession to see
// whether the reported time changes much. Do you get the same content each
// time? Modify fetchall to print its output to a file so it can be examined.

package main

import (
	"fmt"
	"io/ioutil"
	"net/http"
	"os"
	"time"
)

func main() {
	start := time.Now()
	ch := make(chan string)
	for _, url := range os.Args[1:] {
		go fetch(url, ch)
	}
	for range os.Args[1:] {
		fmt.Println(<-ch)
	}
	fmt.Printf("%.2fs elapsed\n", time.Since(start).Seconds())
}

func fetch(url string, ch chan<- string) {
	start := time.Now()
	resp, err := http.Get(url)
	if err != nil {
		ch <- fmt.Sprint(err) // send to channel ch
		return
	}

	data, err := ioutil.ReadAll(resp.Body)
	resp.Body.Close()
	if err != nil {
		ch <- fmt.Sprintf("while reading response body from %s: %v", url, err)
		return
	}

	f, err := os.OpenFile("C:/Users/ivanr/Desktop/log.txt", os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0664)
	if err != nil {
		ch <- fmt.Sprintf("can't open log file: %v", err)
		return
	}

	_, err = f.Write(data)
	if err != nil {
		ch <- fmt.Sprintf("can't write response body to log file %s: %v", url, err)
		f.Close()
		return
	}

	_, err = f.Write([]byte("\nend of response\n\n"))
	if err != nil {
		f.Close()
		ch <- fmt.Sprintf("can't write end of response delimiter to log file %s: %v", url, err)
		return
	}

	f.Close()
	secs := time.Since(start).Seconds()
	ch <- fmt.Sprintf("%.2fs  %7d  %s", secs, len(data), url)
}
