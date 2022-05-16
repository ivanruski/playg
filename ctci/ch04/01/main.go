// Route Between Nodes: Given a directed graph and two nodes (S and E), design
// an algorithm to find out whether there is a route from S to E

package main

type Node[T any] struct {
	Val      T
	Vertices []*Node[T]
}

type Graph[T any] struct {
	Nodes []*Node[T]
}

func main() {
}

func CheckRouteDFS[T any](s, t *Node[T]) bool {
	return checkRouteDFS(s, t, make(map[*Node[T]]struct{}))
}

func checkRouteDFS[T any](s, t *Node[T], visited map[*Node[T]]struct{}) bool {
	if s == t {
		return true
	}

	visited[s] = struct{}{}

	for _, v := range s.Vertices {
		if _, ok := visited[v]; ok {
			continue
		}

		if checkRouteDFS(v, t, visited) {
			return true
		}
	}

	return false
}

type QueueNode[T any] struct {
	Val  T
	Next *QueueNode[T]
}

type Queue[T any] struct {
	front *QueueNode[T]
	tail  *QueueNode[T]
}

func (q *Queue[T]) Enqueue(v T) {
	n := &QueueNode[T]{Val: v}

	if q.tail == nil {
		q.front = n
		q.tail = n
	} else {
		q.tail.Next = n
		q.tail = n
	}
}

func (q *Queue[T]) Dequeue() T {
	var t T
	if q.front == nil {
		return t
	}

	t = q.front.Val
	if q.front == q.tail {
		q.front = nil
		q.tail = nil
	} else {
		q.front = q.front.Next
	}

	return t
}

func (q *Queue[T]) IsEmpty() bool {
	return q.front == nil
}

func CheckRouteBFS[T any](s, t *Node[T]) bool {
	visited := map[*Node[T]]struct{}{}
	q := Queue[*Node[T]]{}

	q.Enqueue(s)
	visited[s] = struct{}{}

	for !q.IsEmpty() {
		n := q.Dequeue()
		visited[n] = struct{}{}
		if n == t {
			return true
		}

		for _, v := range n.Vertices {
			if _, ok := visited[v]; !ok {
				q.Enqueue(v)
			}
		}
	}

	return false
}
