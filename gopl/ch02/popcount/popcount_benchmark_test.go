package popcount

import (
	"testing"
)

func BenchmarkPopCount(t *testing.B) {
	var num uint64 = 2298456661
	for i := 0; i < t.N; i++ {
		PopCount(num)
	}
}

func BenchmarkPopCountLoop(t *testing.B) {
	var num uint64 = 2298456661
	for i := 0; i < t.N; i++ {
		PopCountLoop(num)
	}
}

func BenchmarkPopCountBitByBit(t *testing.B) {
	var num uint64 = 2298456661
	for i := 0; i < t.N; i++ {
		PopCountBitByBit(num)
	}
}

func BenchmarkPopCount3(t *testing.B) {
	var num uint64 = 2298456661
	for i := 0; i < t.N; i++ {
		PopCount3(num)
	}
}
