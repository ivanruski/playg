// Exercise 8.6: Add depth-limiting to the concurrent crawler. That
// is, if the user sets -depth=3, then only URLs reachable by at most
// three links will be fetched.

// I've deliberately copied the Crawl3 source, so that I can try to
// address the termination problem.

// Copyright © 2016 Alan A. A. Donovan & Brian W. Kernighan.
// License: https://creativecommons.org/licenses/by-nc-sa/4.0/

// See page 243.

// Crawl3 crawls web links starting with the command-line arguments.
//
// This version uses bounded parallelism.
// For simplicity, it does not address the termination problem.
//
package main

import (
	"flag"
	"fmt"
	"log"

	"ivanruski/gopl/ch08/findlinks/links"
)

func crawl(url string, depth int) []string {
	fmt.Println(url, depth)
	list, err := links.Extract(url)
	if err != nil {
		log.Print(err)
	}
	return list
}

type link struct {
	depth int // depth from the intial set of links, the intial set of links are with depth 0
	value string
}

func main() {
	var (
		worklist    = make(chan []link) // lists of URLs, may have duplicates
		unseenLinks = make(chan link)   // de-duplicated URLs
		depth       = flag.Int("depth", 3, "the max depth of URLs that the crawler can traverse, strarting from the initial set of URLs")
	)
	flag.Parse()
	if *depth < 0 {
		fmt.Println("depth flag must be a non negative number")
	}

	// Add command-line arguments to worklist.
	go func() {
		initialLinks := make([]link, 0, len(flag.Args()))
		for _, l := range flag.Args() {
			initialLinks = append(initialLinks, link{value: l, depth: 0})
		}
		worklist <- initialLinks
	}()

	for i := 0; i < 2; i++ {
		go func() {
			for unseenLink := range unseenLinks {
				foundLinks := crawl(unseenLink.value, unseenLink.depth)
				go func(parentDepth int) {
					links := make([]link, 0, len(foundLinks))
					for _, foundLink := range foundLinks {
						links = append(links, link{value: foundLink, depth: parentDepth + 1})
					}
					worklist <- links
				}(unseenLink.depth)
			}
		}()
	}

	// The main goroutine de-duplicates worklist items
	// and sends the unseen ones to the crawlers.
	seen := make(map[string]bool)
	for list := range worklist {
		for _, link := range list {
			if link.depth > *depth {
				continue
			}
			if !seen[link.value] {
				seen[link.value] = true
				unseenLinks <- link
			}
		}
	}
}
