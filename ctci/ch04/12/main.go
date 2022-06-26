// Paths with Sum: You are given a binary tree in which each node contains an
// integer values (which might be positive or negative). Design an algorithm to
// count the number of paths that sum to a given value. The path does not need
// to start or end at the root or a leaf, but it must go downwards (traveling
// only from parent nodes to child nodes).
//
// https://leetcode.com/problems/path-sum-iii/

package main

import (
	"math"
)

func main() {
}

func buildBinaryTreeFromArr(arr []int) *TreeNode {
	treeNodes := make([]*TreeNode, 0, len(arr))
	for _, num := range arr {
		treeNodes = append(treeNodes, &TreeNode{Val: num})
	}

	for i := 0; i < len(arr); i++ {
		if treeNodes[i].Val != math.MinInt64 {
			l := 2*i + 1
			r := 2*i + 2
			if l < len(arr) {
				treeNodes[i].Left = treeNodes[l]
			}
			if r < len(arr) {
				treeNodes[i].Right = treeNodes[r]
			}
		}
	}

	return treeNodes[0]
}

type TreeNode struct {
	Val   int
	Left  *TreeNode
	Right *TreeNode
}

func pathSum(root *TreeNode, targetSum int) int {
	if root == nil {
		return 0
	}

	sum := findAllPathsWithSumStartingFrom(root, 0, targetSum)
	lsum := pathSum(root.Left, targetSum)
	rsum := pathSum(root.Right, targetSum)

	return sum + lsum + rsum
}

func findAllPathsWithSumStartingFrom(root *TreeNode, sum, targetSum int) int {
	var cnt int
	currSum := sum + root.Val
	if currSum == targetSum {
		cnt = 1
	}

	var lcnt int
	if root.Left != nil {
		lcnt = findAllPathsWithSumStartingFrom(root.Left, currSum, targetSum)
	}

	var rcnt int
	if root.Right != nil {
		rcnt = findAllPathsWithSumStartingFrom(root.Right, currSum, targetSum)
	}

	return cnt + lcnt + rcnt
}
