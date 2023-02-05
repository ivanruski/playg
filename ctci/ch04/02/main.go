// Minimal Tree: Given a sorted (increasing order) array with unique integer
// elements, write an algorithm to create a binary search tree with minimal
// height.
//
// https://leetcode.com/problems/convert-sorted-array-to-binary-search-tree/

package main

type TreeNode struct {
	Val   int
	Left  *TreeNode
	Right *TreeNode
}

func sortedArrayToBST(nums []int) *TreeNode {
	switch len(nums) {
	case 0:
		return nil
	case 1:
		return &TreeNode{Val: nums[0]}
	case 2:
		return &TreeNode{
			Val:   nums[0],
			Right: &TreeNode{Val: nums[1]},
		}
	default:
		i := len(nums) / 2
		left := sortedArrayToBST(nums[0:i])
		right := sortedArrayToBST(nums[i+1:])

		root := &TreeNode{
			Val:   nums[i],
			Left:  left,
			Right: right,
		}
		return root
	}
}
