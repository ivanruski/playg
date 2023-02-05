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

// Create a slice by traversing the tree inorder and check
// if the values in the slice are in an increasing order.
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

// The second approach is from the hints. The idea is to check that
// each node is within an allowed range
func isValidBST_2(root *TreeNode) bool {
	min := -(1 << 32)
	max := 1 << 32

	return inOrderWithRange(root, min, max)
}

func inOrderWithRange(root *TreeNode, min, max int) bool {
	if root == nil {
		return true
	}

	if min < root.Val && root.Val < max {
		return inOrderWithRange(root.Left, min, root.Val) &&
			inOrderWithRange(root.Right, root.Val, max)
	}

	return false
}
