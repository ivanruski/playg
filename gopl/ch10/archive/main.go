// Exercise 10.2: Define a generic archive file-reading function
// capable of reading ZIP files (archive/zip) and POSIX tar files
// (archive/tar). Use a registration mechanism similar to the one
// described above so that support for each file format can be plugged
// in using blank imports.
//

package main

import (
	"fmt"
	"log"

	"github.com/ivanruski/playg/gopl/ch10/archive/reader"
	_ "github.com/ivanruski/playg/gopl/ch10/archive/reader/tar"
	_ "github.com/ivanruski/playg/gopl/ch10/archive/reader/zip"
)

func main() {
	contents, err := reader.ListContents("testdata/archive.zip")
	if err != nil {
		log.Fatal(err)
	}

	for _, c := range contents {
		fmt.Println(c)
	}

	contents, err = reader.ListContents("testdata/test-archive.tar")
	if err != nil {
		log.Fatal(err)
	}

	for _, c := range contents {
		fmt.Println(c)
	}
}
