// Exercise 7.3: Write a String method for the *tree type in
// gopl.io/ch4/treesort (§4.4) that reveals the sequence of values in
// the tree.

package main

import (
	"fmt"
	"strconv"
	"strings"
)

type tree struct {
	value       int
	left, right *tree
}

func (t *tree) String() string {
	var inorder func(*tree, *strings.Builder)
	inorder = func(root *tree, builder *strings.Builder) {
		if root == nil {
			return
		}

		inorder(root.left, builder)
		builder.WriteString(strconv.Itoa(root.value))
		builder.WriteString(" ")
		inorder(root.right, builder)
	}

	b := &strings.Builder{}
	b.WriteString("[ ")
	inorder(t, b)
	b.WriteString("]")

	return b.String()
}

// Sort sorts values in place.
func Sort(values []int) {
	var root *tree
	for _, v := range values {
		root = add(root, v)
	}
	appendValues(values[:0], root)
}

// appendValues appends the elements of t to values in order
// and returns the resulting slice.
func appendValues(values []int, t *tree) []int {
	if t != nil {
		values = appendValues(values, t.left)
		values = append(values, t.value)
		values = appendValues(values, t.right)
	}
	return values
}

func add(t *tree, value int) *tree {
	if t == nil {
		// Equivalent to return &tree{value: value}.
		t = new(tree)
		t.value = value
		return t
	}
	if value < t.value {
		t.left = add(t.left, value)
	} else {
		t.right = add(t.right, value)
	}
	return t
}

func main() {
	var t *tree
	t = add(t, 9)
	t = add(t, 8)
	t = add(t, 7)
	t = add(t, 6)
	t = add(t, 5)
	t = add(t, 4)
	t = add(t, 3)
	t = add(t, 2)
	t = add(t, 1)

	fmt.Println(t)
}
