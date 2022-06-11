// Check Subtree: T1 and T2 are two very large binary trees, with T1 much bigger
// than T2. Create an algorithm to determine if T2 is a subtree of T1.
//
// A tree T2 is a subtree of T1 if there exists a node n in T1 such that the
// subtree of n is identical to T2. That is, if you cut off the tree at node n,
// the two tress would be identical.
//
// https://leetcode.com/problems/subtree-of-another-tree/

package main

type TreeNode struct {
	Val   int
	Left  *TreeNode
	Right *TreeNode
}

func main() {

}

func isSubtree(root *TreeNode, subRoot *TreeNode) bool {
	if root == nil {
		return false
	}

	if areTreesEqual(root, subRoot) {
		return true
	}

	return isSubtree(root.Left, subRoot) || isSubtree(root.Right, subRoot)
}

func areTreesEqual(x, y *TreeNode) bool {
	if x == nil && y == nil {
		return true
	}
	if x == nil || y == nil {
		return false
	}

	if x.Val != y.Val {
		return false
	}

	return areTreesEqual(x.Left, y.Left) && areTreesEqual(x.Right, y.Right)
}
