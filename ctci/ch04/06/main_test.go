package main

import (
	"fmt"
	"testing"
)

func TestInOrderSuccessor(t *testing.T) {
	nodes := createBSTFromArr([]int{8, 4, 12, 2, 6, 10, 14, 1, 3, 5, 7, 9, 11, 13, 15})
	for _, n := range nodes {
		succ := InOrderSuccessor(n)
		if succ != nil {
			fmt.Printf("%d -> %d\n", n.Val, succ.Val)
		} else {
			fmt.Printf("%d -> nil\n", n.Val)
		}
	}
}

func createBSTFromArr(arr []int) []*TreeNode {
	nodes := make([]*TreeNode, 0, len(arr))
	for _, num := range arr {
		nodes = append(nodes, &TreeNode{Val: num})
	}

	for i, n := range nodes {
		leftIdx := (2 * i) + 1
		rightIdx := (2 * i) + 2

		var l, r *TreeNode
		if leftIdx < len(nodes) {
			l = nodes[leftIdx]
		}
		if rightIdx < len(nodes) {
			r = nodes[rightIdx]
		}

		n.Left = l
		n.Right = r

		if l != nil {
			l.Parent = n
		}
		if r != nil {
			r.Parent = n
		}
	}

	return nodes
}
