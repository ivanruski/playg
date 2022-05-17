// Validate BST: Implement a function to check if a binary tree is a binary
// search tree.
//
// https://leetcode.com/problems/validate-binary-search-tree/

package main

type TreeNode struct {
	Val   int
	Left  *TreeNode
	Right *TreeNode
}

func main() {
}

func isValidBST(root *TreeNode) bool {
	s := sliceFromInOrderTraversal(root)
	if len(s) < 2 {
		return true
	}

	for i := 1; i < len(s); i++ {
		if s[i-1] >= s[i] {
			return false
		}
	}

	return true
}

func sliceFromInOrderTraversal(root *TreeNode) []int {
	if root == nil {
		return nil
	}

	var s []int
	if root.Left != nil {
		s = append(s, sliceFromInOrderTraversal(root.Left)...)
	}
	s = append(s, root.Val)

	if root.Right != nil {
		s = append(s, sliceFromInOrderTraversal(root.Right)...)
	}

	return s
}
