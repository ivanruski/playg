// Given the root of a binary tree, flatten the tree into a "linked
// list":
// 
// The "linked list" should use the same TreeNode class where the right
// child pointer points to the next node in the list and the left child
// pointer is always null.  The "linked list" should be in the same order
// as a pre-order traversal of the binary tree.
//
// Example 1:
// Input: root = [1,2,5,3,4,null,6]
// Output: [1,null,2,null,3,null,4,null,5,null,6]
//
// Example 2:
// Input: root = [1,2,5,3,4,null,6]
// Output: [1,null,2,null,3,null,4,null,5,null,6]
//
// Example 3:
// Input: root = [0]
// Output: [0]
//
// Constraints:
// 
// The number of nodes in the tree is in the range [0, 2000].
// 100 <= Node.val <= 100
//
// https://leetcode.com/problems/flatten-binary-tree-to-linked-list/

func main() {
}

func flatten(root *TreeNode) {
    s := []int{}
    preorder(root, &s)

    for i, v := range s {
        root.Val = v
        if i + 1 != len(s) {
            root.Left = nil
            root.Right = &TreeNode{}
            root = root.Right
        }
    }
}

func preorder(root *TreeNode, s *[]int) {
    if root == nil {
        return
    }

    *s = append(*s, root.Val)
    preorder(root.Left, s)
    preorder(root.Right, s)
}

// Follow up: Can you flatten the tree in-place (with O(1) extra space)?
func flatten2(root *TreeNode) {
    if root == nil {
        return
    }

    flatten2(root.Right)
    flatten2(root.Left)

    rr := root.Right
    rl := root.Left

    if root.Left != nil {
        root.Left = nil
        root.Right = rl
        rm := rightMost(rl)
        rm.Right = rr
    }
}

func rightMost(root *TreeNode) *TreeNode {
    if root.Right == nil {
        return root
    }

    return rightMost(root.Right)
}

