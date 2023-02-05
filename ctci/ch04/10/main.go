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
	subRootHeight := treeHeight(subRoot)
	nodesToCheck := []*TreeNode{}
	nodesWithHeight(root, subRootHeight, &nodesToCheck)

	for _, n := range nodesToCheck {
		if areTreesEqual(n, subRoot) {
			return true
		}
	}

	return false
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

func treeHeight(root *TreeNode) int {
	if root == nil {
		return 0
	}

	lh := treeHeight(root.Left)
	rh := treeHeight(root.Right)

	if lh > rh {
		return lh + 1
	}
	return rh + 1
}

func nodesWithHeight(root *TreeNode, height int, nodes *[]*TreeNode) int {
	if root == nil {
		return 0
	}

	lh := nodesWithHeight(root.Left, height, nodes)
	rh := nodesWithHeight(root.Right, height, nodes)
	var nodeHeight int
	if lh > rh {
		nodeHeight = lh + 1
	} else {
		nodeHeight = rh + 1
	}

	if height == nodeHeight {
		ns := *nodes
		ns = append(ns, root)
		*nodes = ns
	}

	return nodeHeight
}
