// First Common Ancestor: Design an algorithm and write code to find the first
// common ancestor of two nodes in a binary tree. Avoid stroing additional nodes
// in a data structure. NOTE: This is not a necessarily a binary search tree.
//
// https://leetcode.com/problems/lowest-common-ancestor-of-a-binary-tree/

package main

func main() {}

type TreeNode struct {
	Val   int
	Left  *TreeNode
	Right *TreeNode
}

func lowestCommonAncestor(root, p, q *TreeNode) *TreeNode {
	ca, _, _ := depthFirstCommonAncestor(root, p, q)
	return ca
}

// TODO: There is a faster way
func depthFirstCommonAncestor(root, p, q *TreeNode) (*TreeNode, bool, bool) {
	if root == nil {
		return nil, false, false
	}

	cal, pfl, qfl := depthFirstCommonAncestor(root.Left, p, q)
	if cal != nil {
		return cal, true, true
	}

	car, pfr, qfr := depthFirstCommonAncestor(root.Right, p, q)
	if car != nil {
		return car, true, true
	}

	pFound := pfl || pfr || (root == p)
	qFound := qfl || qfr || (root == q)

	if pFound && qFound {
		return root, true, true
	}

	return nil, pFound, qFound
}
