// BST Sequences: A binary search tree was created by traversing through an
// array from left to right and inserting each elelement. Given a binary search
// tree with distinct elements, print all possible arrays that could have led to
// this tree.
//
// EXAMPLE:
//     2
//   /   \
// 1       3
//
// Output: {2, 1, 3}, {2, 3, 1}
//
// Side node: There is almost identical problem in leetcode. The difference is
// that in leetcode they want the number of all possible arrays not the actual
// arrays. This solution is too slow and it fails with OOM in leetcode, however
// it should be correct.
//
// https://leetcode.com/problems/number-of-ways-to-reorder-array-to-get-same-bst/

package main

import (
	"fmt"
)

type TreeNode struct {
	Val   int
	Left  *TreeNode
	Right *TreeNode
}

type BST struct {
	root *TreeNode
}

func (b *BST) Add(v int) {
	node := &TreeNode{Val: v}

	if b == nil {
		b = &BST{}
	}
	if b.root == nil {
		b.root = node
		return
	}

	var prev, curr *TreeNode = nil, b.root
	for curr != nil {
		prev = curr
		if curr.Val >= v {
			curr = curr.Left
		} else {
			curr = curr.Right
		}
	}

	if prev.Val >= v {
		prev.Left = node
	} else {
		prev.Right = node
	}
}

func (b *BST) InOrderValues() []int {
	r := []int{}
	inOrderValues(b.root, &r)

	return r
}

func inOrderValues(root *TreeNode, vals *[]int) {
	if root == nil {
		return
	}

	inOrderValues(root.Left, vals)
	*vals = append(*vals, root.Val)
	inOrderValues(root.Right, vals)
}

func main() {
	input := []int{8, 4, 6, 5, 16, 2, 1, 3, 12, 10, 11, 14, 13, 15, 9, 7}
	tree := &BST{}
	for _, i := range input {
		tree.Add(i)
	}

	sequences := AllPossibleInsertSequences(tree.root)
	for _, s := range sequences {
		fmt.Println(s)
	}
}

func AllPossibleInsertSequences(root *TreeNode) [][]int {
	if root == nil {
		return nil
	}

	if root.Left == nil && root.Right == nil {
		return [][]int{{root.Val}}
	}
	if root.Right == nil {
		left := AllPossibleInsertSequences(root.Left)
		result := make([][]int, 0, len(left))
		for _, l := range left {
			result = append(result, append([]int{root.Val}, l...))
		}

		return result
	}
	if root.Left == nil {
		right := AllPossibleInsertSequences(root.Right)
		result := make([][]int, 0, len(right))
		for _, r := range right {
			result = append(result, append([]int{root.Val}, r...))
		}

		return result
	}

	left := AllPossibleInsertSequences(root.Left)
	right := AllPossibleInsertSequences(root.Right)
	result := [][]int{}

	for _, l := range left {
		for _, r := range right {
			merged, _ := mergeSlices(l, r)
			for _, m := range merged {
				result = append(result, append([]int{root.Val}, m...))
			}
		}
	}

	return result
}
