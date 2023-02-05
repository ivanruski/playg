// Check Balanced: Implement a function to check if a binary tree is balanced.
// For the purposes of this question, a balanced tree is defined to be a tree
// such that the heights of the two subtrees of any node never differ by more
// than one.
//
// https://leetcode.com/problems/balanced-binary-tree/

package main

import "math"

type TreeNode struct {
	Val   int
	Left  *TreeNode
	Right *TreeNode
}

func isBalanced(root *TreeNode) bool {
	return treeHeight(root) != -1
}

func treeHeight(root *TreeNode) int {
	if root == nil {
		return 0
	}

	lh := treeHeight(root.Left)
	rh := treeHeight(root.Right)
	diff := float64(lh - rh)

	// propagate the -1 to the top
	if math.Abs(diff) > 1 || lh == -1 || rh == -1 {
		return -1
	}

	if lh > rh {
		return lh + 1
	}
	return rh + 1
}
