package main

import (
	"crypto/rand"
	"fmt"
	"math/big"
	"sort"
	"strconv"
	"testing"
)

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

func TestPeeksAndValleys(t *testing.T) {
	for i := 0; i < 500; i++ {
		t.Run(strconv.Itoa(i), func(t *testing.T) {
			size, err := getRandomInt(250)
			if err != nil {
				t.Fatalf("getting random number: %s", err)
			}
			arr, err := createRandomArray(size)
			if err != nil {
				t.Fatalf("creating random array: %s", err)
			}

			got := PeeksAndValleys2(arr)
			if !findInvalidPeekOrValley(got) {
				t.Errorf("%v is not valid peeks and valleys", got)
			}

			if !compareSlices(arr, got) {
				t.Error("the resulting slice does not contain the original elements")
			}
		})
	}
}

func TestIsValidArray(t *testing.T) {
	tests := []struct {
		nums []int
		want bool
	}{
		{
			nums: []int{},
			want: true,
		},
		{
			nums: []int{1},
			want: true,
		},
		{
			nums: []int{1, 2},
			want: true,
		},
		{
			nums: []int{2, 1},
			want: true,
		},
		{
			nums: []int{1, 2, 2},
			want: true,
		},
		{
			nums: []int{2, 2, 1},
			want: true,
		},
		{
			nums: []int{1, 1, 2},
			want: true,
		},
		{
			nums: []int{1, 2, 3},
			want: false,
		},
		{
			nums: []int{3, 2, 1},
			want: false,
		},
		{
			nums: []int{1, 3, 2},
			want: true,
		},
		{
			nums: []int{3, 1, 2},
			want: true,
		},
		{
			nums: []int{1, 2, 3, 4},
			want: false,
		},
		{
			nums: []int{4, 3, 2, 1},
			want: false,
		},
		{
			nums: []int{1, 4, 2, 3},
			want: true,
		},
		{
			nums: []int{4, 2, 3, 1},
			want: true,
		},
		{
			nums: []int{1, 1, 1, 2, 2},
			want: true,
		},
		{
			nums: []int{2, 1, 2, 1, 2, 1, 2, 3},
			want: false,
		},
		{
			nums: []int{1, 5, 2, 6, -10, 3, 2, 4, -500, 500, 0},
			want: true,
		},
	}

	for i, test := range tests {
		t.Run(strconv.Itoa(i), func(t *testing.T) {
			got := findInvalidPeekOrValley(test.nums)
			if got != test.want {
				t.Errorf("got: %v, want: %v", got, test.want)
			}
		})
	}
}

func findInvalidPeekOrValley(nums []int) bool {
	if len(nums) < 3 {
		return true
	}

	var peek bool
	if isPeek(nums[0], nums[1], nums[2]) {
		peek = true
	}

	for i := 1; i < len(nums)-1; i++ {
		if peek {
			if !isPeek(nums[i-1], nums[i], nums[i+1]) {
				fmt.Println("invalid peek", nums[i-1], nums[i], nums[i+1])
				return false
			}
		} else {
			if !isValley(nums[i-1], nums[i], nums[i+1]) {
				fmt.Println("invalid valley", nums[i-1], nums[i], nums[i+1])
				return false
			}
		}

		peek = !peek
	}

	return true
}

func isPeek(a, b, c int) bool {
	return a <= b && b >= c
}

func isValley(a, b, c int) bool {
	return a >= b && b <= c
}

func compareSlices(a, b []int) bool {
	if len(a) != len(b) {
		return false
	}

	sort.Ints(a)
	sort.Ints(b)

	for i := 0; i < len(a); i++ {
		if a[i] != b[i] {
			return false
		}
	}

	return true
}
