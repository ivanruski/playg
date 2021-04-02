// Exercise 4.1: Write a function that counts the number of bits that
// are different in two SHA256 hashes

package main

import (
	"fmt"
	"crypto/sha256"
)

func main() {
	var hash1 [32]byte = sha256.Sum256([]byte("98"))
	var hash2 [32]byte = sha256.Sum256([]byte("99"))

	
	fmt.Printf("%d\n", cntSha1DiffBits(hash1, hash2))
}

func cntSha1DiffBits(hash1, hash2 [32]byte) int {
	var bitDiffCnt int

	for i := 0; i < 32; i++ {
		byte1, byte2 := hash1[i], hash2[i]

		for j := 0; j < 8; j++ {
			bit1 := (byte1 >> j) & 1
			bit2 := (byte2 >> j) & 1

			if bit1 != bit2 {
				bitDiffCnt++
			}
		}
	}

	return bitDiffCnt
}

