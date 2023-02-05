// Animal Shelter: An animal shelter, which holds only dogs and cats, operates
// on a strictly "first in, first out" basis. People must adopt either the
// "oldest" (based on arrival time) of all animals at the shelter, or they can
// select whether they would prefer a dog or a cat (and will receive the oldest
// animal of that type). They cannot select which specific animal they would
// like. Create the data structures to maintain this system and implement
// operations such as: enqueue, dequeueAny, dequeueDog and dequeueCat. You may
// use the built-in LinkedList data structure.
//
// TODO add comment

package main

import (
	"fmt"
	"math"
)

type Node[T any] struct {
	Value T
	Next  *Node[T]
}

type Queue[T any] struct {
	front *Node[T]
	tail  *Node[T]
}

func (q *Queue[T]) Empty() bool {
	return q.front == nil
}

// first Enqueue tail and front are nil
// then only append at the end
func (q *Queue[T]) Enqueue(v T) {
	n := &Node[T]{Value: v}
	if q.tail == nil {
		q.tail = n
		q.front = n
		return
	}

	q.tail.Next = n
	q.tail = n
}

func (q *Queue[T]) Dequeue() (T, bool) {
	var t T

	if q.front == nil {
		return t, false
	}

	t = q.front.Value

	if q.front == q.tail {
		q.front = nil
		q.tail = nil
		return t, true
	}

	q.front = q.front.Next

	return t, true
}

func (q *Queue[T]) Peek() (T, bool) {
	var t T
	if q.front == nil {
		return t, false
	}

	return q.front.Value, true
}

type AnimalType int

const (
	Dog AnimalType = iota
	Cat
)

type Animal struct {
	Name string
	Type AnimalType
}

type animalInShelter struct {
	animal Animal
	order  int
}

// AnimalShelter must be used after calling NewAnimalShelter
type AnimalShelter struct {
	dogs       *Queue[animalInShelter]
	cats       *Queue[animalInShelter]
	animalsCnt int
}

func NewAnimalShelter() *AnimalShelter {
	return &AnimalShelter{
		dogs: &Queue[animalInShelter]{},
		cats: &Queue[animalInShelter]{},
	}
}

func (as *AnimalShelter) Enqueue(animal Animal) error {
	num := as.animalsCnt
	an := animalInShelter{
		animal: animal,
		order:  num,
	}

	switch animal.Type {
	case Dog:
		as.dogs.Enqueue(an)
	case Cat:
		as.cats.Enqueue(an)
	default:
		return fmt.Errorf("Unknown animal type: %v", animal.Type)
	}

	as.animalsCnt++
	return nil
}

// dequeueAny, dequeueDog and dequeueCat
func (as *AnimalShelter) DequeueAny() (Animal, bool) {
	if as.dogs.Empty() {
		return as.DequeueCat()
	}
	if as.cats.Empty() {
		return as.DequeueDog()
	}

	cat, _ := as.cats.Peek()
	dog, _ := as.dogs.Peek()
	if cat.order < dog.order {
		return as.DequeueCat()
	}
	return as.DequeueDog()
}

func (as *AnimalShelter) DequeueDog() (Animal, bool) {
	an, ok := as.dogs.Dequeue()
	return an.animal, ok

}

func (as *AnimalShelter) DequeueCat() (Animal, bool) {
	an, ok := as.cats.Dequeue()
	return an.animal, ok
}

func main() {
	fmt.Println(math.MaxInt)
}
