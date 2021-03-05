// Exercise 1.4: Modify dup2 to print the names of all files in which
// each duplicated line occurs.

package main

import (
	"bufio"
	"fmt"
	"os"
)

func main() {
	filesPerLine := make(map[string]map[string]bool)
	counts := make(map[string]int)
	files := os.Args[1:]

	if len(files) == 0 {
		countLines(os.Stdin, "stdin", counts, filesPerLine)
	} else {
		for _, fileName := range files {
			file, err := os.Open(fileName)
			if err != nil {
				fmt.Printf("dup2: %v", err)
				continue
			}

			countLines(file, fileName, counts, filesPerLine)
			file.Close()
		}
	}

	for key, value := range counts {
		if value > 1 {
			fmt.Printf("%d\t%s\n", value, key)

			for file, _ := range filesPerLine[key] {
				fmt.Printf("\t%s\n", file)
			}
		}
	}
}

func countLines(file *os.File, fileName string, counts map[string]int, filesPerLine map[string]map[string]bool) {
	scanner := bufio.NewScanner(file)

	for scanner.Scan() {
		line := scanner.Text()
		counts[line]++

		if filesPerLine[line] == nil {
			filesPerLine[line] = make(map[string]bool)
		}

		filesPerLine[line][fileName] = true
	}

	file.Close()
}
