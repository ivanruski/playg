// Exercise 4.2: Write a program that prints the SHA256 hash of its
// standard input by default but supports a command-line flag to print
// SHA384 or SHA512 hash instead.

package main

import (
	"fmt"
	"flag"
	"crypto/sha256"
	"crypto/sha512"
)

var digest = flag.Int("b", 256,
	"Digest size in bits. Possible digest: 256(default), 384, 512")

func main() {
	flag.Parse()

	var tohash string = flag.Arg(0)

	switch *digest {
	case 256:
		hashed := sha256.Sum256([]byte(tohash))
		fmt.Printf("%x\n", hashed)
	case 384:
		hashed := sha512.Sum384([]byte(tohash))
		fmt.Printf("%x\n", hashed)
	case 512:
		hashed := sha512.Sum512([]byte(tohash))
		fmt.Printf("%x\n", hashed)
	default:
		fmt.Printf("Digest size of %v is not supported\n", *digest)
	}
}


