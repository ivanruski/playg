package main

import (
	"bufio"
	"bytes"
	"fmt"
	"math"
	"os"
	"slices"
	"strconv"
	"strings"
)

// https://adventofcode.com/2025/day/10
//
// HUGE THANKS to https://www.reddit.com/r/adventofcode/comments/1pk87hl/2025_day_10_part_2_bifurcate_your_way_to_victory/
// for part 2. I wouldn't have done it otherwise.
func main() {
	diagrams, _ := readInput()

	fmt.Println(analyzeDiagrams(diagrams))
	fmt.Println(configureJoltages(diagrams))
}

func analyzeDiagrams(diagrams []diagram) int {
	var sum int
	for _, d := range diagrams {
		validCombinations := analyzeDiagram(d.lightsTarget, d.buttonWirings)
		slices.SortFunc(validCombinations, func(a, b [][]int) int {
			return len(a) - len(b)
		})

		sum += len(validCombinations[0])
	}
	return sum
}

func analyzeDiagram(target []int, pressings [][]int) [][][]int {
	t := strings.Builder{}
	for _, c := range target {
		t.WriteString(strconv.Itoa(c))
	}

	targetNum, _ := strconv.ParseInt(t.String(), 2, 64)

	buttonWirings := []int{}
	for _, bw := range pressings {
		bits := make([]int, t.Len())
		for _, n := range bw {
			bits[n] = 1
		}

		pattern := strings.Builder{}
		for _, n := range bits {
			pattern.WriteString(strconv.Itoa(n))
		}

		num, _ := strconv.ParseInt(pattern.String(), 2, 64)
		buttonWirings = append(buttonWirings, int(num))
	}

	min := math.MaxInt32
	pressingCombinations := powerset(pressings)
	result := [][][]int{}
	for _, pressingCombination := range pressingCombinations {
		num := 0
		for _, buttonPresses := range pressingCombination {
			num ^= combinePressesToBitPattern(buttonPresses, t.Len())
		}

		if num == int(targetNum) {
			result = append(result, pressingCombination)
			if len(pressingCombination) < min {
				min = len(pressingCombination)
			}
		}
	}

	return result
}

func combinePressesToBitPattern(bw []int, x int) int {
	bits := make([]int, x)
	for _, n := range bw {
		bits[n] = 1
	}

	pattern := strings.Builder{}
	for _, n := range bits {
		pattern.WriteString(strconv.Itoa(n))
	}

	num, _ := strconv.ParseInt(pattern.String(), 2, 64)
	return int(num)
}

func powerset(buttonWirings [][]int) [][][]int {
	if len(buttonWirings) == 0 {
		return [][][]int{{}}
	}

	first := buttonWirings[0]
	rest := buttonWirings[1:]

	ps := powerset(rest)
	res := make([][][]int, 0, len(ps)*2)

	for _, subset := range ps {
		res = append(res, subset)

		s := make([][]int, len(subset), len(subset)+1)
		copy(s, subset)
		s = append(s, first)
		res = append(res, s)
	}

	return res
}

func configureJoltages(diagrams []diagram) int {
	sum := 0
	for _, d := range diagrams {
		res := configureDiagramJoltages(d.joltageRequirements, d.buttonWirings, map[int][][][]int{})
		sum += res
	}

	return sum
}

func configureDiagramJoltages(counters []int, combinations [][]int, memo map[int][][][]int) int {
	allZeroes := true
	for _, d := range counters {
		if d > 0 {
			allZeroes = false
		}
		if d < 0 {
			return math.MaxInt32
		}
	}

	if allZeroes {
		return 0
	}

	target := []int{}
	for _, n := range counters {
		target = append(target, n%2)
	}

	min := math.MaxInt32
	var validCombinations [][][]int
	if vc, ok := memo[key(target)]; ok {
		validCombinations = vc
	} else {
		validCombinations = analyzeDiagram(target, combinations)
		memo[key(target)] = validCombinations
	}

	for _, pattern := range validCombinations {
		joltages := make([]int, len(counters))
		copy(joltages, counters)
		for _, buttonPressings := range pattern {
			for _, b := range buttonPressings {
				joltages[b]--
			}
		}

		allEven := true
		for _, j := range joltages {
			if j%2 != 0 {
				allEven = false
			}
		}
		if allEven {
			for i := range joltages {
				joltages[i] /= 2
			}
		}

		cnt := configureDiagramJoltages(joltages, combinations, memo)
		if cnt != math.MaxInt32 {
			if allEven {
				cnt = cnt * 2
			}
			cnt = cnt + len(pattern)
		}
		if min > cnt {
			min = cnt
		}
	}

	return min
}

func key(s []int) int {
	mul := int(math.Pow(10, float64(len(s)-1)))
	sum := 0
	for i := len(s) - 1; i >= 0; i-- {
		sum += mul * s[i]
		mul /= 10
	}

	return sum
}

type diagram struct {
	lightsTarget        []int
	lightsIndicator     []int
	buttonWirings       [][]int
	joltageRequirements []int
}

func readInput() ([]diagram, error) {
	b, err := os.ReadFile("input.txt")
	if err != nil {
		return nil, err
	}

	scanner := bufio.NewScanner(bytes.NewReader(b))
	scanner.Split(bufio.ScanLines)

	var diagrams []diagram
	for scanner.Scan() {
		line := strings.Split(scanner.Text(), " ")

		lights := line[0]
		wirings := line[1 : len(line)-1]
		joltageReqs := line[len(line)-1]

		lt := []int{}
		for _, state := range strings.Trim(lights, "[]") {
			if state == '.' {
				lt = append(lt, 0)
			} else {
				lt = append(lt, 1)
			}
		}

		bw := [][]int{}
		for _, wiring := range wirings {
			w := []int{}
			for _, n := range strings.Split(strings.Trim(wiring, "()"), ",") {
				num, _ := strconv.Atoi(n)
				w = append(w, num)
			}

			bw = append(bw, w)
		}

		jr := []int{}
		for _, r := range strings.Split(strings.Trim(joltageReqs, "{}"), ",") {
			num, _ := strconv.Atoi(r)
			jr = append(jr, num)
		}

		diagrams = append(diagrams, diagram{
			lightsTarget:        lt,
			lightsIndicator:     make([]int, len(lt)),
			buttonWirings:       bw,
			joltageRequirements: jr,
		})
	}

	return diagrams, nil
}
