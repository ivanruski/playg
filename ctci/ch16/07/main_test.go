package main

import (
	"crypto/rand"
	"fmt"
	"math"
	"math/big"
	"strconv"
	"testing"
)

func TestNumberMax(t *testing.T) {
	for i := 0; i < 100; i++ {
		t.Run(strconv.Itoa(i), func(t *testing.T) {
			x, err := getRandomInt(math.MaxInt64 - 1)
			if err != nil {
				t.Fatalf("getting x: %s", err)
			}

			y, err := getRandomInt(math.MaxInt64 - 1)
			if err != nil {
				t.Fatalf("getting y: %s", err)
			}

			got := numberMax(x, y)
			want := getMaxNumber(x, y)
			if got != want {
				t.Fatalf("got: %d, want: %d", got, want)
			}

			got = numberMax(x, -y)
			want = getMaxNumber(x, -y)
			if got != want {
				t.Fatalf("got: %d, want: %d", got, want)
			}

			got = numberMax(-x, y)
			want = getMaxNumber(-x, y)
			if got != want {
				t.Fatalf("got: %d, want: %d", got, want)
			}

			got = numberMax(-x, -y)
			want = getMaxNumber(-x, -y)
			if got != want {
				t.Fatalf("got: %d, want: %d", got, want)
			}
		})
	}
}

func getRandomInt(max int) (int, error) {
	num, err := rand.Int(rand.Reader, big.NewInt(int64(max)))
	if err != nil {
		return 0, fmt.Errorf("rand.Int: %w", err)
	}

	return int(num.Int64()), nil
}

func getMaxNumber(a, b int) int {
	if a > b {
		return a
	}
	return b
}
