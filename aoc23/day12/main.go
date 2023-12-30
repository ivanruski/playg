package main

import (
	"bufio"
	"bytes"
	"fmt"
	"os"
	"strconv"
	"strings"
)

var mem map[string]int

func main() {
	records, _ := readFileInput("input")

	mem = map[string]int{}
	var sum int
	for _, r := range records {
		sum += count(r.row, r.groups)
	}

	fmt.Println(sum)
}

func count(row string, nums []int) int {
	if len(row) == 0 {
		if len(nums) == 0 {
			return 1
		}
		return 0
	}
	if len(nums) == 0 {
		if strings.Contains(row, "#") {
			return 0
		}
		return 1
	}

	if num, ok := mem[keyify(row, nums)]; ok {
		return num
	}

	var result int
	if row[0] == '.' || row[0] == '?' {
		result += count(row[1:], nums)
	}
	if row[0] == '#' || row[0] == '?' {
		// 1. group is equal to groups[0]
		// 2. char after that is . or ?
		if len(row) >= nums[0] {
			group := row[:nums[0]]
			if !strings.Contains(group, ".") && (len(row) == nums[0] || row[nums[0]] != '#') {
				if len(row) == nums[0] {
					result += count("", nums[1:])
				} else {
					result += count(row[nums[0]+1:], nums[1:])
				}
			}
		}
	}

	mem[keyify(row, nums)] = result
	return result
}

func keyify(row string, nums []int) string {
	sb := strings.Builder{}
	for _, n := range nums {
		sb.WriteRune(rune(n))
	}

	return row + sb.String()
}

type record struct {
	row    string
	groups []int
}

func readFileInput(filename string) ([]record, error) {
	data, err := os.ReadFile(filename)
	if err != nil {
		return nil, err
	}

	scanner := bufio.NewScanner(bytes.NewReader(data))
	scanner.Split(bufio.ScanLines)

	rs := []record{}
	for scanner.Scan() {
		line := scanner.Text()

		row, damaged, _ := strings.Cut(line, " ")

		ds := []int{}
		for _, num := range strings.Split(damaged, ",") {
			n, err := strconv.Atoi(num)
			if err != nil {
				panic(fmt.Sprintf("parsing %q: %s", num, err))
			}

			ds = append(ds, n)
		}

		unfoldedRow := row
		unfoldedGroups := ds
		for i := 0; i < 4; i++ {
			unfoldedRow += "?" + row
			unfoldedGroups = append(unfoldedGroups, ds...)
		}

		rs = append(rs, record{
			row:    unfoldedRow,
			groups: unfoldedGroups,
		})
	}

	return rs, nil
}
