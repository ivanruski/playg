// Exercise 5.11: The instructor of the linear algebra course decides
// that calculus is now a prerequisite. Extend the topoSort function
// to report cycles.

package main

import (
	"fmt"
	"log"
)

var prereqs = map[string][]string{
	"algorithms": {"data structures"},
	"calculus":   {"linear algebra"},

	"compilers": {
		"data structures",
		"formal languages",
		"computer organization",
	},

	"data structures":       {"discrete math"},
	"databases":             {"data structures"},
	"discrete math":         {"intro to programming"},
	"formal languages":      {"discrete math"},
	"networks":              {"operating systems"},
	"operating systems":     {"data structures", "computer organization"},
	"programming languages": {"data structures", "computer organization"},

	// cycle
	"linear algebra": {"calculus"},
}

func main() {
	courses, err := topsort()

	if err != nil {
		log.Fatalf("%s", err)
	}

	for i, c := range courses {
		fmt.Printf("%d: %s\n", i+1, c)
	}
}

func topsort() ([]string, error) {
	ordered := make([]string, 0)
	seen := make(map[string]bool)
	var visitAll func(course string, visited []string) error

	visitAll = func(course string, visited []string) error {
		for _, v := range visited {
			if v == course {
				return fmt.Errorf("visitAll: cycle found")
			}
		}

		coursePrereqs, ok := prereqs[course]
		if !ok && !seen[course] {
			ordered = append(ordered, course)
			seen[course] = true
		}
		if v, _ := seen[course]; v == false {
			seen[course] = true
			for _, prereq := range coursePrereqs {
				err := visitAll(prereq, append(visited, course))
				if err != nil {
					return err
				}
			}
			ordered = append(ordered, course)
		}

		return nil
	}

	for c, _ := range prereqs {
		err := visitAll(c, make([]string, 0))
		if err != nil {
			return ordered, err
		}
	}

	return ordered, nil
}
