// Exercise 4.10: Modify issues to report the results in age
// categories, say less than a month old, less than a year old, and
// more than a year old.

package main

import (
	"fmt"
	"log"
	"os"

	"../github"
)


func main() {
	result, err := github.SearchIssues(os.Args[1:])
	if err != nil {
	 	log.Fatal(err)
	}

	monthOld := github.IssuesFromLessThanAMonth(result.Items)
	yearOld := github.IssuesFromPastYear(result.Items)
	olderThanAYear := github.IssuesOlderThanAYear(result.Items)

	if len(monthOld) != 0 {
		fmt.Println("Month old:")
		printIssues(monthOld)
	}
	if len(yearOld) != 0 {
		fmt.Println("Year old:")
		printIssues(yearOld)
	}
	if len(olderThanAYear) != 0 {
		fmt.Println("Older than a year:")
		printIssues(olderThanAYear)
	}

}

func printIssues(s []*github.Issue) {
	for _, i := range s {
		fmt.Printf("%#5d %v\n", i.Number, i.CreatedAt)
	}
}
