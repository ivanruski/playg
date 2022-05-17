package main

import "fmt"

func ExampleListOfDepths_perfectlyBalancedBST() {
	tree := sortedArrayToBST([]int{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15})
	lls := ListOfDepths(tree)
	for _, ll := range lls {
		fmt.Println(ll)
	}

	// Output:
	// 8
	// 4 -> 12
	// 2 -> 6 -> 10 -> 14
	// 1 -> 3 -> 5 -> 7 -> 9 -> 11 -> 13 -> 15
}

func ExampleListOfDepths_linkedListTree() {
	tree := &TreeNode[int]{
		Val: 1,
		Right: &TreeNode[int]{
			Val: 2,
			Right: &TreeNode[int]{
				Val: 3,
				Right: &TreeNode[int]{
					Val: 4,
					Right: &TreeNode[int]{
						Val: 5,
					},
				},
			},
		},
	}
	lls := ListOfDepths(tree)
	for _, ll := range lls {
		fmt.Println(ll)
	}

	// Output:
	// 1
	// 2
	// 3
	// 4
	// 5
}

func ExampleListOfDepths() {
	tree := &TreeNode[int]{
		Val: 1,
		Right: &TreeNode[int]{
			Val: 2,
			Left: &TreeNode[int]{
				Val: 8,
				Left: &TreeNode[int]{
					Val: 64,
				},
			},
			Right: &TreeNode[int]{
				Val: 3,
				Left: &TreeNode[int]{
					Val: 6,
					Left: &TreeNode[int]{
						Val: 7,
					},
				},
				Right: &TreeNode[int]{
					Val: 4,
					Right: &TreeNode[int]{
						Val: 5,
					},
				},
			},
		},
	}
	lls := ListOfDepths(tree)
	for _, ll := range lls {
		fmt.Println(ll)
	}

	// Output:
	// 1
	// 2
	// 8 -> 3
	// 64 -> 6 -> 4
	// 7 -> 5
}

// Use the function from the previous exercise to create trees
func sortedArrayToBST(nums []int) *TreeNode[int] {
	switch len(nums) {
	case 0:
		return nil
	case 1:
		return &TreeNode[int]{Val: nums[0]}
	case 2:
		return &TreeNode[int]{
			Val:   nums[0],
			Right: &TreeNode[int]{Val: nums[1]},
		}
	default:
		i := len(nums) / 2
		left := sortedArrayToBST(nums[0:i])
		right := sortedArrayToBST(nums[i+1:])

		root := &TreeNode[int]{
			Val:   nums[i],
			Left:  left,
			Right: right,
		}
		return root
	}
}
