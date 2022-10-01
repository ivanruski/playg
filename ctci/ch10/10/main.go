// Rank from Stream: Imagine you are reading in a stream of
// integers. Periodically, you wish to be able to look up the rank of a number x
// (the number of values less than or equal to x). Implement the data structures
// and algorithms to support these operations. That is, implement the method
// track(x int), which is called when each number is generated, and the method
// getRankOfNumber(x int), which returns the number of values less than or equal
// to x (not including this instance of x itself).
//
// EXAMPLE
//
// Stream (left is the first): 5, 1, 4, 4, 5, 9, 7, 13, 3
// getRankOfNumber(1) = 0 // values:
// getRankOfNumber(3) = 1 // values: s[1] = 1
// getRankOfNumber(4) = 0 // values: s[1] = 1, s[2] = 4, s[8] = 3
//
// The solution runs in O(n) because the tree is unbalanced

package main

import "fmt"

func main() {
	t := &trackerBST{}
	// arr := []int{5, 1, 4, 4, 5, 9, 7, 13, 3}
	arr := []int{8, 4, 12, 2, 6, 10, 14, 1, 3, 5, 7, 9, 11, 13, 15}
	for _, n := range arr {
		t.track(n)
	}

	for _, n := range arr {
		rank := t.getRankOfNumber(n)
		fmt.Printf("rank(%d): %d\n", n, rank)
	}
}

type node struct {
	val     int
	left    *node
	right   *node
	leftCnt int
}

type trackerBST struct {
	root *node
}

func (t *trackerBST) track(x int) {
	var prev *node
	curr := t.root
	for curr != nil {
		prev = curr
		if x <= curr.val {
			curr.leftCnt++
			curr = curr.left
		} else {
			curr = curr.right
		}
	}

	n := &node{val: x}
	if prev == nil {
		t.root = n
	} else if x <= prev.val {
		prev.left = n
	} else {
		prev.right = n
	}
}

func (t *trackerBST) getRankOfNumber(x int) int {
	var rank int
	curr := t.root
	for curr != nil {
		if curr.val == x {
			return rank + curr.leftCnt
		}
		if x < curr.val {
			curr = curr.left
		} else {
			rank++ // the node itself
			rank += curr.leftCnt
			curr = curr.right
		}
	}

	return -1
}
