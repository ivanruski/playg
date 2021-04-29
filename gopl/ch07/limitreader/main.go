// Exercise 7.5: The LimitReader function in the io package accepts an
// io.Reader r and a number of bytes n, and returns another Reader
// that reads from r but reports an end-of-file condition after n
// bytes. Implement it.

// func LimitReader(r io.Reader, n int64) io.Reader

package main

import (
	"fmt"
	"io"
	"strings"
)

type limitedReader struct {
	readLimit int
	bytesRead int
	reader    io.Reader
}

func (lr *limitedReader) Read(p []byte) (int, error) {
	if lr.readLimit <= lr.bytesRead {
		return 0, io.EOF
	}

	if len(p) > lr.readLimit-lr.bytesRead {
		limitBuf := make([]byte, lr.readLimit-lr.bytesRead)
		n, err := lr.reader.Read(limitBuf)
		if err != nil {
			return 0, err
		}
		lr.bytesRead += n

		for i, b := range limitBuf {
			p[i] = b
		}

		return n, nil
	}

	n, err := lr.reader.Read(p)
	if err != nil {
		return 0, err
	}
	lr.bytesRead += n

	return n, nil
}

func LimitReader(reader io.Reader, n int) io.Reader {
	return &limitedReader{
		readLimit: n,
		reader:    reader,
	}
}

func main() {
	strReader := strings.NewReader("Hello,sworld")
	reader := LimitReader(strReader, 7)
	buf := make([]byte, 8)
	for n, err := reader.Read(buf); err != io.EOF; n, err = reader.Read(buf) {
		fmt.Printf("n: %d\terr: %s\tread: %s\n", n, err, string(buf))
	}
}
