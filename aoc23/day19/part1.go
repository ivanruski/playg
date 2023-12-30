package main

import (
	"bufio"
	"bytes"
	"fmt"
	"os"
	"strconv"
	"strings"
)

func main() {
	workflows, parts, err := readFileInput("input")
	if err != nil {
		fmt.Printf("reading input: %s", err)
	}

	fmt.Println(sumV1(workflows, parts))
}

func sumV1(workflows map[string][]rule, parts []part) int {
	var sum int

OUTER:
	for _, p := range parts {
		wf := "in"
	INNER:
		for {
			rules := workflows[wf]

			for i, r := range rules {
				if i+1 == len(rules) {
					wf = r.wfname
					if wf == "A" {
						sum += p.sum()
						continue OUTER
					}
					if wf == "R" {
						continue OUTER
					}

					break
				}

				if r.op(p) {
					wf = r.wfname

					if wf == "A" {
						sum += p.sum()
						continue OUTER
					}
					if wf == "R" {
						continue OUTER
					}

					continue INNER
				}
			}

		}
	}

	return sum
}

type rule struct {
	op     func(part) bool
	wfname string
}

type part struct {
	x, m, a, s int
}

func (p part) sum() int {
	return p.x + p.m + p.a + p.s
}

func readFileInput(filename string) (map[string][]rule, []part, error) {
	data, err := os.ReadFile(filename)
	if err != nil {
		return nil, nil, err
	}

	scanner := bufio.NewScanner(bytes.NewReader(data))
	scanner.Split(bufio.ScanLines)

	wfs := map[string][]rule{}
	for scanner.Scan() {
		line := scanner.Text()
		if line == "" {
			// move onto parsing the parts
			break
		}

		wfname, rulesRaw, _ := strings.Cut(line, "{")
		rulesRaw = rulesRaw[:len(rulesRaw)-1]
		rulesStr := strings.Split(rulesRaw, ",")

		rules := []rule{}
		for i, r := range rulesStr {
			if i+1 == len(rulesStr) {
				rules = append(rules, rule{wfname: r})
				break
			}

			ctg := r[0:1]
			op := r[1:2]

			idx := strings.Index(r, ":")
			numstr := r[2:idx]
			wfname := r[idx+1:]

			num, err := strconv.Atoi(numstr)
			if err != nil {
				panic(fmt.Sprintf("atoi %q: %s", numstr, err))
			}

			rules = append(rules, rule{
				wfname: wfname,
				op:     fn(ctg, op, num),
			})
		}

		wfs[wfname] = rules
	}

	parts := []part{}
	for scanner.Scan() {
		line := scanner.Text()
		line = strings.Trim(line, "{}")
		strs := strings.Split(line, ",")
		var p part
		for _, str := range strs {
			ctg, numstr, _ := strings.Cut(str, "=")
			num, err := strconv.Atoi(numstr)
			if err != nil {
				panic(fmt.Sprintf("atoi %q: %s", numstr, err))
			}

			switch ctg {
			case "x":
				p.x = num
			case "m":
				p.m = num
			case "a":
				p.a = num
			case "s":
				p.s = num
			}
		}
		parts = append(parts, p)
	}

	return wfs, parts, nil
}

func fn(ctg, op string, num int) func(part) bool {
	switch op {
	case ">":
		switch ctg {
		case "x":
			return func(p part) bool { return p.x > num }
		case "m":
			return func(p part) bool { return p.m > num }
		case "a":
			return func(p part) bool { return p.a > num }
		case "s":
			return func(p part) bool { return p.s > num }
		}
	case "<":
		switch ctg {
		case "x":
			return func(p part) bool { return p.x < num }
		case "m":
			return func(p part) bool { return p.m < num }
		case "a":
			return func(p part) bool { return p.a < num }
		case "s":
			return func(p part) bool { return p.s < num }
		}
	}

	panic(fmt.Sprintf("unknown op: %s", op))
}
