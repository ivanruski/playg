// Exercise 7.4: The strings.NewReader function returns a value that
// satisfies the io.Reader interface (and others) by reading from its
// argument, a string. Implement a simple version of NewReader
// yourself, and use it to make the HTML parser (§5.2) take input from
// a string.

package main

import (
	"fmt"
	"io"

	"golang.org/x/net/html"
)

type StringReader struct {
	data      []byte
	bytesRead int
}

func NewStringReader(str string) io.Reader {
	return &StringReader{
		data: []byte(str),
	}
}

func (sr *StringReader) Read(p []byte) (n int, err error) {
	if sr.bytesRead == len(sr.data) {
		return 0, io.EOF
	}

	plen := len(p)
	readFromIdx := sr.bytesRead

	for i, b := range sr.data[readFromIdx:] {
		if n >= plen {
			break
		}
		p[i] = b
		n++
		sr.bytesRead++
	}

	return n, nil
}

func main() {
	reader := NewStringReader("<div><span>Hello, World :)</span></div>")
	node, _ := html.Parse(reader)
	printNode(node, "")
}

func printNode(node *html.Node, offset string) {
	if node == nil {
		return
	}

	fmt.Printf("%s type:%v data:%s pointer: %p\n", offset, node.Type, node.Data, node)

	for child := node.FirstChild; child != nil; child = child.NextSibling {
		printNode(child, offset+"\t")
	}
}
