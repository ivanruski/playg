package main

import (
	"errors"
)

type QueueNode struct {
	val  *Pair
	next *QueueNode
}

type Queue struct {
	front *QueueNode
	tail  *QueueNode
}

func (q *Queue) Enqueue(v *Pair) {
	n := &QueueNode{val: v}
	if q.front == nil {
		q.front = n
		q.tail = n
	} else {
		q.tail.next = n
		q.tail = n
	}
}

func (q *Queue) Dequeue() *Pair {
	v := q.front.val

	if q.front == q.tail {
		q.front = nil
		q.tail = nil
		return v
	}
	q.front = q.front.next

	return v
}

func (q *Queue) isEmpty() bool {
	return q.front == nil
}

type Pair struct {
	Left  []int
	Right []int
}

// mergeSlices accepts two slices and generates all possible merge combinations
// such that the elements of both slices are in the same order.
//
// e.g. [1, 2] and [3, 4] will result in:
// [3 4 1 2]
// [3 1 4 2]
// [3 1 2 4]
// [1 3 4 2]
// [1 3 2 4]
// [1 2 3 4]
//
// 1 is always before 2 and 3 is always before 4
func mergeSlices(a, b []int) ([][]int, error) {
	if len(b) == 0 {
		return [][]int{a}, nil
	}
	if len(intersect(a, b)) != 0 {
		return nil, errors.New("slices must not overlap")
	}

	q := Queue{}
	sentinel := &Pair{}

	pairs := createPairs(a, b[0])
	for _, p := range pairs {
		q.Enqueue(p)
	}
	q.Enqueue(sentinel)

	i := 1
	for i < len(b) {
		p := q.Dequeue()
		if p == sentinel {
			i++
			q.Enqueue(p)
			continue
		}

		pairs := createPairs(p.Right, b[i])
		for _, pair := range pairs {
			l := make([]int, len(p.Left)+len(pair.Left))
			copy(l, append(p.Left, pair.Left...))

			r := make([]int, len(pair.Right))
			copy(r, pair.Right)

			q.Enqueue(&Pair{Left: l, Right: r})
		}
	}

	result := [][]int{}
	for !q.isEmpty() {
		p := q.Dequeue()
		if p == sentinel {
			continue
		}
		result = append(result, append(p.Left, p.Right...))
	}

	return result, nil
}

// createPairs accepts slice of ints and an int and generates set of pairs
// where in each pair the last element of Pair.Left is the int param.
// e.g. createParis([]int{1, 2, 3}, x) will return:
// 0: Left: [x], Right: [1, 2, 3]
// 1: Left: [1, x], Right: [2, 3]
// 2: Left: [1, 2, x], Right: [3]
// 3: Left: [1, 2, 3, x] Right:[]
func createPairs(nums []int, x int) []*Pair {
	result := make([]*Pair, 0, len(nums)+1)

	for i := 0; i <= len(nums); i++ {
		l := make([]int, 0, i+1)
		for j := 0; j < i; j++ {
			l = append(l, nums[j])
		}
		l = append(l, x)

		r := make([]int, len(nums[i:]))
		copy(r, nums[i:])

		result = append(result, &Pair{Left: l, Right: r})
	}

	return result
}

func intersect(a []int, b []int) []int {
	m := map[int]struct{}{}
	for _, x := range a {
		m[x] = struct{}{}
	}

	r := []int{}
	for _, x := range b {
		if _, ok := m[x]; ok {
			r = append(r, x)
		}
	}

	return r
}
