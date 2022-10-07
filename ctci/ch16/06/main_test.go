package main

import (
	"crypto/rand"
	"fmt"
	"math/big"
	"strconv"
	"testing"
)

func TestSmallestDiff(t *testing.T) {
	for i := 0; i < 2000; i++ {
		t.Run(strconv.Itoa(i), func(t *testing.T) {
			size, err := getRandomInt(5000)
			if err != nil {
				t.Fatalf("creating rand int: %s", err)
			}

			xs, err := createRandomArray(size)
			if err != nil {
				t.Fatalf("creating xs: %s", err)
			}

			ys, err := createRandomArray(size)
			if err != nil {
				t.Fatalf("creating ys: %s", err)
			}

			got := smallestDiff(xs, ys)
			want := smallestDiffSlow(xs, ys)

			if got != want {
				t.Fatalf("got: %d, want: %d", got, want)
			}
		})
	}
}

func smallestDiffSlow(xs, ys []int) int {
	var sd int = 1 << 62
	for _, x := range xs {
		for _, y := range ys {
			d := abs(x - y)
			if sd > d {
				sd = d
			}
		}
	}

	return sd
}

func abs(x int) int {
	if x >= 0 {
		return x
	}

	return -x
}

func getRandomInt(max int) (int, error) {
	num, err := rand.Int(rand.Reader, big.NewInt(int64(max)))
	if err != nil {
		return 0, fmt.Errorf("rand.Int: %w", err)
	}

	return int(num.Int64()), nil
}

func createRandomArray(size int) ([]int, error) {
	arr := make([]int, 0, size)
	for i := 0; i < size; i++ {
		num, err := getRandomInt(500)
		if err != nil {
			return nil, err
		}
		arr = append(arr, num)
	}

	return arr, nil
}
