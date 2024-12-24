package main

import (
	"container/heap"
	"fmt"
	"math"
)

func main() {
	// [[1,2,1]], n = 2, k = 2
	times := [][]int{
		{1, 2, 1},
	}
	n := 2
	k := 2

	fmt.Println(networkDelayTime(times, n, k))
}

type Edge struct {
	value    int
	vertices []Vertex
}

type Vertex struct {
	dest int
	dist int
}

// https://leetcode.com/problems/network-delay-time/description/
func networkDelayTime(times [][]int, n int, k int) int {
	edges := make([]Edge, n+1)
	for _, t := range times {
		src, dst, dist := t[0], t[1], t[2]
		edges[src].vertices = append(edges[src].vertices, Vertex{dest: dst, dist: dist})
	}

	distsFromK := make([]int, n+1)
	for i := 1; i <= n; i++ {
		if i != k {
			distsFromK[i] = math.MaxInt
		}
	}

	mh := &MinHeap{}
	heap.Init(mh)
	for _, vertex := range edges[k].vertices {
		heap.Push(mh, &Item{Src: k, Dest: vertex.dest, Dist: vertex.dist})
	}

	for mh.Len() > 0 {
		item := mh.Pop().(*Item)
		src, dst, vtxdist := item.Src, item.Dest, item.Dist

		if distsFromK[src]+vtxdist < distsFromK[dst] {
			distsFromK[dst] = distsFromK[src] + vtxdist

			for _, vertex := range edges[dst].vertices {
				heap.Push(mh, &Item{Src: dst, Dest: vertex.dest, Dist: vertex.dist})
			}
		}
	}

	max := 0
	for _, v := range distsFromK {
		if v > max {
			max = v
		}
	}

	if max == math.MaxInt {
		return -1
	}

	return max
}

// Heap
type Item struct {
	Src  int
	Dest int
	Dist int
}

type MinHeap []*Item

func (m MinHeap) Len() int {
	return len(m)
}

func (m MinHeap) Less(i, j int) bool {
	return m[i].Dist < m[j].Dist
}

func (m MinHeap) Swap(i, j int) {
	m[i], m[j] = m[j], m[i]
}

func (m *MinHeap) Push(x any) {
	*m = append(*m, x.(*Item))
}

func (m *MinHeap) Pop() any {
	e := (*m)[len(*m)-1]
	*m = (*m)[:len(*m)-1]
	return e
}
