package main

import (
	"bufio"
	"bytes"
	"fmt"
	"os"
	"slices"
)

// https://adventofcode.com/2025/day/7
func main() {
	diagram, _ := readInput()
	fmt.Println(splitBeam(diagram))
	fmt.Println(splitBeamQuantumly(diagram))
}

func splitBeam(diagram [][]rune) int {
	beams := []int{
		slices.Index(diagram[0], 'S'),
	}
	sum := 0
	for _, row := range diagram[1:] {
		newBeams := []int{}
		for _, beam := range beams {
			switch row[beam] {
			case '.':
				newBeams = append(newBeams, beam)
			case '^':
				sum++

				if lb := beam - 1; lb >= 0 {
					newBeams = append(newBeams, lb)
				}

				if rb := beam + 1; rb < len(row) {
					newBeams = append(newBeams, rb)
				}
			}
		}
		slices.Sort(newBeams)
		beams = slices.Compact(newBeams)
	}

	return sum
}

func splitBeamQuantumly(diagram [][]rune) int {
	beam := slices.Index(diagram[0], 'S')
	return countTimelines(1, beam, diagram, make(map[[2]int]int))
}

func countTimelines(beamRow, beamCol int, diagram [][]rune, memo map[[2]int]int) int {
	if beamCol < 0 || beamCol >= len(diagram[0]) {
		return 0
	}

	if beamRow == len(diagram) {
		return 1
	}

	if diagram[beamRow][beamCol] == '.' {
		return countTimelines(beamRow+1, beamCol, diagram, memo)
	}

	keyl := [2]int{beamRow + 1, beamCol - 1}
	var leftTimelines int

	if val, ok := memo[keyl]; ok {
		leftTimelines = val
	} else {
		leftTimelines = countTimelines(beamRow+1, beamCol-1, diagram, memo)
		memo[keyl] = leftTimelines
	}

	keyr := [2]int{beamRow + 1, beamCol + 1}
	var rightTimelines int
	if val, ok := memo[keyr]; ok {
		rightTimelines = val
	} else {
		rightTimelines = countTimelines(beamRow+1, beamCol+1, diagram, memo)
	}

	return leftTimelines + rightTimelines
}

func readInput() ([][]rune, error) {
	b, err := os.ReadFile("input.txt")
	if err != nil {
		return nil, err
	}

	scanner := bufio.NewScanner(bytes.NewReader(b))
	scanner.Split(bufio.ScanLines)

	result := [][]rune{}
	for scanner.Scan() {
		result = append(result, []rune(scanner.Text()))
	}

	return result, nil
}
