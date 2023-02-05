package main

import "testing"

func BenchmarkDivingBoard1(b *testing.B) {
	for i := 0; i < b.N; i++ {
		_ = divingBoard1(8, 13, 20)
	}
}
