// Missing Int: Given an input file with four billion non-negative integers,
// provide an algorithm to generate an integer that is not contained in the
// file. Assume you have 1 GB of memory availble for this task.

package main

import "fmt"

type BitVector struct {
	byts []byte
}

func NewBitVector(n int) *BitVector {
	size := (n / 8) + 1
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
	fmt.Println(missingInt2([]int{3, 0, 1}))
}

// https://leetcode.com/problems/missing-number/
func missingInt(nums []int) int {
	// size := 1024 * 1024 * 1024 * 8 // max: // 1 GB in bits
	bv := NewBitVector(len(nums))
	for _, n := range nums {
		bv.Set(n)
	}

	for i := 0; i < len(nums); i++ {
		if !bv.Get(i) {
			return i
		}
	}

	return len(nums)
}

// FOLLOW UP
// What if you have only 10 MB of memory? Assume that all the values are
// distinct and we now have no more than one billion non-negative integers.
func missingInt2(nums []int) int {
	// 4 000 000 000 / 800 = 5 000 000
	// 5 000 000 buckets * 2 bytes (int16) = 10 000 000 bytes or 10 MB
	bucketSize := 800
	size := (len(nums) / bucketSize) + 1 // + 1 byte
	buckets := make([]int16, size)

	// divide the numbers into buckets
	for _, n := range nums {
		bucket := n / bucketSize
		buckets[bucket]++
	}

	// if a bucket has size lass than bucket size, number is missing from it
	var from, to int
	for i, b := range buckets {
		if b < int16(bucketSize) {
			from = i * bucketSize
			to = (i + 1) * bucketSize
			break
		}
	}

	// allocate a bucket and set all values to -1
	bucket := make([]int, bucketSize) // one more allocation of 8 bytes * bucketSize
	for i := 0; i < bucketSize; i++ {
		bucket[i] = -1
	}

	// go through all the numbers again and find the numbers
	// belonging to that bucket
	for _, n := range nums {
		if from <= n && n < to {
			idx := n % bucketSize
			bucket[idx] = n
		}
	}

	// the first index with value -1 is the missing num
	for i, n := range bucket {
		if n == -1 {
			if i == 0 {
				return from // first num
			}

			return bucket[i-1] + 1
		}
	}

	return -1
}
