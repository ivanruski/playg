package main

import (
	"bufio"
	"bytes"
	"fmt"
	"maps"
	"math"
	"os"
	"slices"
	"strconv"
	"strings"
)

// https://adventofcode.com/2025/day/8
func main() {
	points, _ := readInput()

	// Solutions to part 1 & 2 are ugly... but correct :)
	fmt.Println(part1(points))
	fmt.Println(part2(points))
}

type point struct {
	x, y, z float64
}

type pair struct {
	d      float64
	p1, p2 point
}

func part1(points []point) int {
	size := len(points) * (len(points) - 1) / 2
	pairs := make([]pair, 0, size)
	for i := 0; i < len(points); i++ {
		for j := i + 1; j < len(points); j++ {
			d := dist(points[i], points[j])
			pairs = append(pairs, pair{
				d:  d,
				p1: points[i],
				p2: points[j],
			})
		}
	}

	slices.SortFunc(pairs, func(a, b pair) int {
		if a.d < b.d {
			return -1
		} else if a.d == b.d {
			return 0
		}
		return 1
	})

	setOfSets := newSetOfSets[point]()
	for _, p := range points {
		st := newSet(p)
		setOfSets.insert(st)
	}

	for i, pair := range pairs {
		if i >= 1000 {
			break
		}

		s1 := setOfSets.getSetOf(pair.p1)
		s2 := setOfSets.getSetOf(pair.p2)
		if s1 != s2 {
			s1.adjoin(s2)
			setOfSets.remove(s2)
		}
	}

	sets := setOfSets.sets()

	slices.SortFunc(sets, func(s1, s2 *set[point]) int {
		s1Size := s1.size()
		s2Size := s2.size()
		if s1Size < s2Size {
			return -1
		} else if s1Size == s2Size {
			return 0
		}
		return 1
	})

	slices.Reverse(sets)

	prod := 1
	for _, s := range sets[:3] {
		prod *= s.size()
	}

	return prod
}

func part2(points []point) int {
	size := len(points) * (len(points) - 1) / 2
	pairs := make([]pair, 0, size)
	for i := 0; i < len(points); i++ {
		for j := i + 1; j < len(points); j++ {
			d := dist(points[i], points[j])
			pairs = append(pairs, pair{
				d:  d,
				p1: points[i],
				p2: points[j],
			})
		}
	}

	slices.SortFunc(pairs, func(a, b pair) int {
		if a.d < b.d {
			return -1
		} else if a.d == b.d {
			return 0
		}
		return 1
	})

	setOfSets := newSetOfSets[point]()
	for _, p := range points {
		st := newSet(p)
		setOfSets.insert(st)
	}

	for _, pair := range pairs {
		s1 := setOfSets.getSetOf(pair.p1)
		s2 := setOfSets.getSetOf(pair.p2)
		if s1 != s2 {
			s1.adjoin(s2)
			setOfSets.remove(s2)
		}

		if setOfSets.size() == 1 {
			return int(pair.p1.x) * int(pair.p2.x)
		}
	}

	return -1
}

func dist(a, b point) float64 {
	return math.Sqrt(
		math.Pow(b.x-a.x, 2) + math.Pow(b.y-a.y, 2) + math.Pow(b.z-a.z, 2),
	)
}

type set[T comparable] struct {
	m map[T]struct{}
}

func newSet[T comparable](elements ...T) *set[T] {
	s := &set[T]{m: make(map[T]struct{})}

	for _, e := range elements {
		s.insert(e)
	}

	return s
}

func (s *set[T]) get(t T) bool {
	_, ok := s.m[t]
	return ok
}

func (s *set[T]) insert(t T) {
	s.m[t] = struct{}{}
}

func (s *set[T]) elements() []T {
	return slices.Collect(maps.Keys(s.m))
}

func (s *set[T]) adjoin(another *set[T]) {
	for _, el := range another.elements() {
		s.insert(el)
	}
}

func (s *set[T]) size() int {
	return len(s.m)
}

type setOfSets[T comparable] struct {
	m map[*set[T]]struct{}
}

func newSetOfSets[T comparable](sets ...*set[T]) *setOfSets[T] {
	ss := &setOfSets[T]{
		m: make(map[*set[T]]struct{}),
	}

	for _, s := range sets {
		ss.insert(s)
	}

	return ss
}

func (s *setOfSets[T]) getSetOf(t T) *set[T] {
	for set := range s.m {
		if set.get(t) {
			return set
		}
	}

	return nil
}

func (s *setOfSets[T]) insert(st *set[T]) {
	s.m[st] = struct{}{}
}

func (s *setOfSets[T]) sets() []*set[T] {
	return slices.Collect(maps.Keys(s.m))
}

func (s *setOfSets[T]) remove(st *set[T]) {
	delete(s.m, st)
}

func (s *setOfSets[T]) size() int {
	return len(s.m)
}

func readInput() ([]point, error) {
	b, err := os.ReadFile("input.txt")
	if err != nil {
		return nil, err
	}

	scanner := bufio.NewScanner(bytes.NewReader(b))
	scanner.Split(bufio.ScanLines)

	points := []point{}
	for scanner.Scan() {
		coords := make([]float64, 3)
		for i, coord := range strings.Split(scanner.Text(), ",") {
			n, _ := strconv.ParseFloat(coord, 64)
			coords[i] = n
		}

		points = append(points, point{coords[0], coords[1], coords[2]})
	}

	return points, nil
}
