package main

import (
	"container/heap"
	"fmt"
)

func main() {
	n := 5
	edges := [][]int{
		{1, 4},
		{2, 4},
		{0, 4},
		{0, 3},
		{0, 2},
		{2, 3},
	}
	probs := []float64{0.37, 0.17, 0.93, 0.23, 0.39, 0.04}
	start := 3
	end := 4

	p := maxProbability(n, edges, probs, start, end)

	fmt.Println(p)
}

// https://leetcode.com/problems/path-with-maximum-probability
func maxProbability(n int, edges [][]int, succProb []float64, start, dest int) float64 {
	nodes := make([]node, n)
	for i, e := range edges {
		nodes[e[0]].edges = append(nodes[e[0]].edges, edge{
			src:    e[0],
			dest:   e[1],
			weight: succProb[i],
		})

		nodes[e[1]].edges = append(nodes[e[1]].edges, edge{
			src:    e[1],
			dest:   e[0],
			weight: succProb[i],
		})
	}

	probs := make([]float64, n)
	probs[start] = 1

	h := &maxheap{}
	heap.Init(h)

	for _, e := range nodes[start].edges {
		heap.Push(h, e)
	}

	for h.Len() > 0 {
		e := heap.Pop(h).(edge)

		if probs[e.dest] < probs[e.src]*e.weight {
			probs[e.dest] = probs[e.src] * e.weight

			for _, de := range nodes[e.dest].edges {
				heap.Push(h, de)
			}
		}
	}

	return probs[dest]
}

type node struct {
	edges []edge
}

type edge struct {
	src    int
	dest   int
	weight float64
}

type maxheap struct {
	items []edge
}

func (m *maxheap) Len() int {
	return len(m.items)
}

func (m *maxheap) Less(i, j int) bool {
	return !(m.items[i].weight < m.items[j].weight)
}

func (m *maxheap) Swap(i, j int) {
	m.items[i], m.items[j] = m.items[j], m.items[i]
}

func (m *maxheap) Push(x any) {
	e := x.(edge)
	m.items = append(m.items, e)
}

func (m *maxheap) Pop() any {
	e := m.items[m.Len()-1]
	m.items = m.items[:m.Len()-1]
	return e
}
