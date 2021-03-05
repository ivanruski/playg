// Exercise 1.3: Experiment to measure the difference in running time
// between our potentially inefficient versions and the one that uses
// strings.Join.

package main

import (
	"fmt"
	"strconv"
	"strings"
	"time"
)

func main() {
	joinStrings()
	concatStrings()
}

func joinStrings() {
	var args [1000]string
	for i := 0; i < 1000; i++ {
		args[i] = "str" + strconv.Itoa(i)
	}

	var start = time.Now().UnixNano()
	var s = strings.Join(args[:], " ")
	fmt.Println(len(s))

	var end = time.Now().UnixNano()
	fmt.Println("Time elapsed in nanoseconds using strings.Join:", end-start)
}

func concatStrings() {
	var args [1000]string
	for i := 0; i < 1000; i++ {
		args[i] = "str" + strconv.Itoa(i)
	}

	var start = time.Now().UnixNano()
	var s, sep string

	for i := 1; i < len(args); i++ {
		s += sep + args[i]
		sep = " "
	}

	// fmt.Println(s)

	var end = time.Now().UnixNano()

	fmt.Println("Time elapsed in nanoseconds concatenating:     ", end-start)
}
