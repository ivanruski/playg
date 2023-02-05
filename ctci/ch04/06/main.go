// Successor: Write an algorithm to find the "next" node (i.e., in-order
// successor) of a given node in a binary search tree. You may assume that each
// node has a link to its parent.

package main

type TreeNode struct {
	Val    int
	Parent *TreeNode
	Left   *TreeNode
	Right  *TreeNode
}

func main() {
}

func InOrderSuccessor(node *TreeNode) *TreeNode {
	if node == nil {
		return nil
	}

	if node.Parent == nil || node.Right != nil {
		node = node.Right
		for node.Left != nil {
			node = node.Left
		}

		return node
	}

	if node == node.Parent.Left {
		return node.Parent
	}

	// node == node.Parent.Right
	for node.Parent != nil && node == node.Parent.Right {
		node = node.Parent
	}

	return node.Parent
}
