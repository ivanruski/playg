package main

import (
	"bufio"
	"bytes"
	"fmt"
	"math"
	"os"
	"regexp"
	"strconv"
	"strings"
)

type rng struct {
	source, dest, length int
}

type almanac struct {
	seeds  []int
	ranges [][]rng
}

func main() {
	al, err := readInputFile("input")
	if err != nil {
		fmt.Printf("reading file: %s", err)
		os.Exit(1)
	}

	fmt.Println(lowestLocationNumV2(al))
}

func lowestLocationNum(al almanac) int {
	var min int = math.MaxInt
	for _, source := range al.seeds {
		dest := source
		for _, rngs := range al.ranges {
			// Any source numbers that aren't mapped correspond to the same destination number.
			for _, r := range rngs {
				if r.source <= dest && dest < r.source+r.length {
					d := dest - r.source
					dest = r.dest + d
					break
				}
			}
		}

		if min > dest {
			min = dest
		}
	}

	return min
}

func lowestLocationNumV2(al almanac) int {
	var min int = math.MaxInt
	for i := 0; i < len(al.seeds); i += 2 {
		source := al.seeds[i]
		length := al.seeds[i+1]

		for s := source; s < source+length; s++ {
			dest := s
			for _, rngs := range al.ranges {
				// Any source numbers that aren't mapped correspond to the same destination number.
				for _, r := range rngs {
					if r.source <= dest && dest < r.source+r.length {
						d := dest - r.source
						dest = r.dest + d
						break
					}
				}
			}

			if min > dest {
				min = dest
			}
		}
	}

	return min
}

func readInputFile(filename string) (almanac, error) {
	data, err := os.ReadFile(filename)
	if err != nil {
		return almanac{}, nil
	}

	scanner := bufio.NewScanner(bytes.NewReader(data))
	scanner.Split(bufio.ScanLines)

	scanner.Scan()
	seeds := parseSeeds(scanner.Text())

	var (
		reg    = regexp.MustCompile("[a-z]*-to-[a-z]* map:")
		ranges = [][]rng{}
	)
	for scanner.Scan() {
		line := scanner.Text()
		if line == "" { // empty lines
			continue
		}

		if reg.MatchString(line) {
			rngs := []rng{}
			for scanner.Scan() {
				line := scanner.Text()
				if line == "" {
					break
				}

				rngs = append(rngs, (parseRange(line)))
			}

			ranges = append(ranges, rngs)
		}
	}

	return almanac{
		seeds:  seeds,
		ranges: ranges,
	}, nil
}

func parseSeeds(line string) []int {
	_, seeds, _ := strings.Cut(line, ":")
	ids := strings.Split(strings.Trim(seeds, " "), " ")
	nums := []int{}
	for _, id := range ids {
		n, err := strconv.Atoi(id)
		if err != nil {
			panic(fmt.Sprintf("parsing %q: %s", id, err))
		}

		nums = append(nums, n)
	}

	return nums
}

func parseRange(line string) rng {
	nums := strings.Split(strings.TrimRight(line, " "), " ")
	ns := []int{}
	for _, num := range nums {
		n, err := strconv.Atoi(num)
		if err != nil {
			panic(fmt.Sprintf("parsing %q: %s", num, err))
		}

		ns = append(ns, n)
	}

	return rng{
		dest:   ns[0],
		source: ns[1],
		length: ns[2],
	}
}

func buildMap(ranges [][]int) map[int]int {
	m := map[int]int{}
	for _, rang := range ranges {
		dest, source, length := rang[0], rang[1], rang[2]
		for i := 0; i < length; i++ {
			m[source+i] = dest + i
		}
	}

	return m
}
