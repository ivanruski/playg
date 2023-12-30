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
	workflows, err := readFileInput("input")
	if err != nil {
		fmt.Printf("reading input: %s", err)
	}

	x := []int{1, 4000}
	m := []int{1, 4000}
	a := []int{1, 4000}
	s := []int{1, 4000}
	fmt.Println(sumV2(x, m, a, s, workflows["in"], workflows))
}

func sumV2(xx, mm, aa, ss []int, rules []rule, workflows map[string][]rule) int {
	if invalid(xx, mm, aa, ss) {
		return 0
	}

	var sum int
	x := cp(xx)
	m := cp(mm)
	a := cp(aa)
	s := cp(ss)
	for i, rule := range rules {
		x = cp(x)
		m = cp(m)
		a = cp(a)
		s = cp(s)

		if i+1 == len(rules) {
			next := rules[i].next
			if next == "A" {
				sum += calculate(x, m, a, s)
				continue
			}
			if next == "R" {
				continue
			}

			sum += sumV2(x, m, a, s, workflows[next], workflows)
			continue
		}

		switch rule.op {
		case ">":
			switch rule.ctg {
			case "x":
				from := x[0]
				to := x[1]

				// from: 1700
				// to:   2600
				//
				// x > 1700

				if from < rule.num && rule.num <= to {
					newX := []int{rule.num + 1, x[1]}

					if rule.next == "A" {
						sum += calculate(newX, m, a, s)
					} else if rule.next != "R" {
						sum += sumV2(newX, m, a, s, workflows[rule.next], workflows)
					}

					// make current as if it didn't pass
					x[1] = rule.num
				}

			case "m":
				from := m[0]
				to := m[1]

				if from < rule.num && rule.num <= to {
					newM := []int{rule.num + 1, m[1]}

					if rule.next == "A" {
						sum += calculate(x, newM, a, s)
					} else if rule.next != "R" {
						sum += sumV2(x, newM, a, s, workflows[rule.next], workflows)
					}

					m[1] = rule.num
				}

			case "a":
				from := a[0]
				to := a[1]

				if from < rule.num && rule.num <= to {
					newA := []int{rule.num + 1, a[1]}
					if rule.next == "A" {
						sum += calculate(x, m, newA, s)
					} else if rule.next != "R" {
						sum += sumV2(x, m, newA, s, workflows[rule.next], workflows)
					}

					a[1] = rule.num
				}

			case "s":
				from := s[0]
				to := s[1]

				if from < rule.num && rule.num <= to {
					newS := []int{rule.num + 1, s[1]}
					if rule.next == "A" {
						sum += calculate(x, m, a, newS)
					} else if rule.next != "R" {
						sum += sumV2(x, m, a, newS, workflows[rule.next], workflows)
					}

					s[1] = rule.num
				}

			}
		case "<":
			switch rule.ctg {
			case "x":
				from := x[0]
				to := x[1]

				// from: 1700
				// to:   2600
				//
				// x < 2600
				if from < rule.num && rule.num < to {
					newX := []int{x[0], rule.num - 1}

					if rule.next == "A" {
						sum += calculate(newX, m, a, s)
					} else if rule.next != "R" {
						sum += sumV2(newX, m, a, s, workflows[rule.next], workflows)
					}

					x[0] = rule.num
				}

			case "m":
				from := m[0]
				to := m[1]

				if from < rule.num && rule.num < to {
					newM := []int{m[0], rule.num - 1}

					if rule.next == "A" {
						sum += calculate(x, newM, a, s)
					} else if rule.next != "R" {
						sum += sumV2(x, newM, a, s, workflows[rule.next], workflows)
					}

					m[0] = rule.num
				}

			case "a":
				from := a[0]
				to := a[1]

				if from < rule.num && rule.num < to {
					newA := []int{a[0], rule.num - 1}

					if rule.next == "A" {
						sum += calculate(x, m, newA, s)
					} else if rule.next != "R" {
						sum += sumV2(x, m, newA, s, workflows[rule.next], workflows)
					}

					a[0] = rule.num
				}

			case "s":
				from := s[0]
				to := s[1]

				if from < rule.num && rule.num < to {
					newS := []int{s[0], rule.num - 1}

					if rule.next == "A" {
						sum += calculate(x, m, a, newS)
					} else if rule.next != "R" {
						sum += sumV2(x, m, a, newS, workflows[rule.next], workflows)
					}

					s[0] = rule.num
				}
			}
		}
	}

	return sum
}

func invalid(x, m, a, s []int) bool {
	r := [][]int{x, m, a, s}
	for _, p := range r {
		if p[0] > p[1] {
			return true
		}
	}

	return false
}

func calculate(x, m, a, s []int) int {
	var prod int = 1
	r := [][]int{x, m, a, s}
	for _, p := range r {
		prod *= (p[1] - p[0] + 1)
	}

	return prod
}

func cp(s []int) []int {
	return []int{s[0], s[1]}
}

type rule struct {
	op, ctg string
	num     int
	next    string
}

func readFileInput(filename string) (map[string][]rule, error) {
	data, err := os.ReadFile(filename)
	if err != nil {
		return nil, err
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
				rules = append(rules, rule{next: r})
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
				op:   op,
				ctg:  ctg,
				num:  num,
				next: wfname,
			})
		}

		wfs[wfname] = rules
	}

	return wfs, nil
}
