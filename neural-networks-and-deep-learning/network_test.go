package main

import (
	"fmt"
	"testing"
)

func TestFeedForward(t *testing.T) {
	n := NewNetwork([]int{2, 3, 4})
	a := []float64{0.5, 0.5}

	out := n.FeedForward(a)

	fmt.Println(out)
}
