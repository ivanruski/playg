// Exercise 5.1: Change the findlinks program to traverse the n.FirstChild linked
// list using recursive calls to visit instead of a loop.

package main

import (
	"fmt"
	"os"

	"golang.org/x/net/html"
)

func main() {
	node, err := html.Parse(os.Stdin)
	if err != nil {
		fmt.Printf("findlinks parse input: %s", err)
	}

	for _, l := range visit(node) {
		fmt.Println(l)
	}
}

// book's first implementation
// it's not a direct copy, so there might be some differences
func visit_original(node *html.Node) []string {
	links := make([]string, 0)

	if node.Type == html.ElementNode && node.Data == "a" {
		links = append(links, extractLinkFromAhref(node))
	}

	for n := node.FirstChild; n != nil; n = n.NextSibling {
		links = append(links, visit(n)...)
	}

	return links
}

func visit(node *html.Node) []string {
	if node == nil {
		return []string{}
	}

	links := make([]string, 0)
	if node.Type == html.ElementNode && node.Data == "a" {
		links = append(links, extractLinkFromAhref(node))
	}

	links = append(links, visit(node.FirstChild)...)
	links = append(links, visit(node.NextSibling)...)

	return links
}

func extractLinkFromAhref(node *html.Node) string {
	for _, attr := range node.Attr {
		if attr.Key == "href" {
			return attr.Val
		}
	}

	return ""
}
