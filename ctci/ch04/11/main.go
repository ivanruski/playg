// Random Node: You are implementing a binary search tree class from scratch
// which, in addition to insert, find and delete, has a method getRandomNode()
// which returns a random node from the tree. All nodes should be equally likely
// to be chosen. Design and implement an algorithm for getRandomNode, and
// explain how you would implement the rest of the methods.

// My solution is inspired by the hints provided by this exercise. I came up
// with a solution which get's a random node from the tree in O(n) time, whereas
// the book's solution is O(logn), so I am going with the book's solution.
//
// https://leetcode.com/problems/delete-node-in-a-bst/ - Delete method is tested
// in leetcode as well

package main

import (
	"fmt"
	"math/rand"
	"time"
)

type TreeNode struct {
	Val   int
	Left  *TreeNode
	Right *TreeNode

	// keeps track of the number of children the node has
	size int
}

type BST struct {
	root *TreeNode
	size int
	rnd  *rand.Rand
}

func NewBST() *BST {
	rnd := rand.New(rand.NewSource(time.Now().UnixNano()))

	return &BST{
		rnd: rnd,
	}
}

func (b *BST) Insert(val int) {
	var prev *TreeNode
	curr := b.root
	for curr != nil {
		curr.size++
		prev = curr

		if curr.Val > val {
			curr = curr.Left
		} else {
			curr = curr.Right
		}
	}

	node := &TreeNode{Val: val}
	if prev == nil {
		b.root = node
	} else if prev.Val > val {
		prev.Left = node
	} else {
		prev.Right = node
	}

	b.size++
}

func (b *BST) Find(val int) *TreeNode {
	node, _ := b.find(val, false)
	return node
}

func (b *BST) find(val int, decSize bool) (node *TreeNode, parent *TreeNode) {
	if b.root == nil {
		return nil, nil
	}

	node = b.root
	for node != nil {
		if decSize {
			node.size--
		}
		if node.Val == val {
			return node, parent
		}

		parent = node
		if node.Val > val {
			node = node.Left
		} else {
			node = node.Right
		}
	}

	return nil, nil
}

func (b *BST) Delete(val int) bool {
	node, parent := b.find(val, true)
	if node == nil {
		return false
	}

	if node.Left != nil && node.Right != nil {
		min, minP := min(node.Right)
		// minP is nil when node.Right == min
		if minP == nil {
			minP = node
		}
		node.Val = min.Val
		b.replaceNode(minP, min, min.Right)
	} else if node.Left != nil {
		b.replaceNode(parent, node, node.Left)
	} else if node.Right != nil {
		b.replaceNode(parent, node, node.Right)
	} else {
		b.replaceNode(parent, node, nil)
	}

	b.size--
	return true
}

func (b *BST) InOrder() (root int, values []int) {
	if b.root == nil {
		return 0, nil
	}

	elems := []int{}
	inOrderTraversal(b.root, &elems)

	return b.root.Val, elems
}

func inOrderTraversal(root *TreeNode, elems *[]int) {
	if root == nil {
		return
	}
	inOrderTraversal(root.Left, elems)
	*elems = append(*elems, root.Val)
	inOrderTraversal(root.Right, elems)
}

func min(n *TreeNode) (node *TreeNode, parent *TreeNode) {
	node = n
	for node.Left != nil {
		parent = node
		node = node.Left
	}

	return node, parent
}

func (b *BST) replaceNode(parent, old, new *TreeNode) {
	if old == b.root {
		b.root = new
		return
	}

	if parent.Left == old {
		parent.Left = new
	} else {
		parent.Right = new
	}
}

func (b *BST) GetRandomNode() *TreeNode {
	randNum := b.rnd.Int()
	kthNode := randNum % b.size

	return getKthNode(b.root, kthNode)
}

// This is the O(logn) solution when the tree is balanced
//
// Another possibility which is O(n) is to know the size of the tree and to do a
// pre-order traversal where the root is the 0th node, root.left is 1st an so
// on. If I'm not wrong this approach also guarantees equal probability, because
// our tree nodes have indexes.
func getKthNode(root *TreeNode, k int) *TreeNode {
	if k < 0 || root == nil {
		return nil
	}

	leftSubtreeCnt := 0
	if root.Left != nil {
		leftSubtreeCnt = root.Left.size + 1
	}

	if k == leftSubtreeCnt {
		return root
	} else if k < leftSubtreeCnt {
		return getKthNode(root.Left, k)
	} else {
		if leftSubtreeCnt == 0 {
			k--
		} else {
			k -= (leftSubtreeCnt + 1)
		}
		return getKthNode(root.Right, k)
	}
}

func printSizes(root *TreeNode) {
	if root == nil {
		return
	}

	printSizes(root.Left)
	fmt.Printf("Node: %d, size: %d\n", root.Val, root.size)
	printSizes(root.Right)
}
