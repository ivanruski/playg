// Find Duplicates: You have an array with all the numbers from 1 to N, where N
// is at most 32,000. The array may have duplicate entries and you do not know
// what N is. With only 4 kilobytes of memory available, how would you print all
// duplicate elements in the array?

package main

import "fmt"

type BitVector struct {
	byts []byte
}

func NewBitVector(n int) *BitVector {
	size := (n / 8)
	byts := make([]byte, size)

	return &BitVector{byts}
}

func (bv *BitVector) Get(i int) bool {
	idx := i / 8
	bitIdx := i % 8

	byt := bv.byts[idx]
	bit := byt >> bitIdx

	return bit&1 == 1
}

func (bv *BitVector) Set(i int) {
	idx := i / 8
	bitIdx := i % 8

	byt := bv.byts[idx]
	bit := byte(1) << bitIdx
	byt = byt | bit
	bv.byts[idx] = byt
}

func main() {
	arr := make([]int, 1024)
	for i := 0; i < 1024; i++ {
		arr[i] = i + 1
		if arr[i]%100 == 0 {
			arr[i] = 16
		}
	}
	printDuplicates(arr)
}

func printDuplicates(arr []int) {
	bv := NewBitVector(len(arr))
	for _, num := range arr {
		if bv.Get(num - 1) {
			fmt.Println(num)
		} else {
			bv.Set(num - 1)
		}
	}
}
