package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

// https://adventofcode.com/2025/day/1
func main() {
	b, err := os.ReadFile("input.txt")
	if err != nil {
		fmt.Println(err)
	}

	moves := []string{}
	scanner := bufio.NewScanner(strings.NewReader(string(b)))
	scanner.Split(bufio.ScanLines)
	for scanner.Scan() {
		moves = append(moves, scanner.Text())
	}

	fmt.Println(day1Part1(moves))
	fmt.Println(day1Part2(moves))
}

func day1Part1(moves []string) int {
	dial := 50
	cnt := 0
	for _, move := range moves {
		dir := move[0]
		num, _ := strconv.Atoi(move[1:])

		if dir == 'L' {
			dial -= num
		} else {
			dial += num
		}

		dial %= 100

		if dial == 0 {
			cnt++
		}
	}

	return cnt
}

func day1Part2(moves []string) int {
	dial := 50
	cnt := 0
	for _, move := range moves {
		dir := move[0]
		num, _ := strconv.Atoi(move[1:])
		cnt += (num / 100)
		num %= 100

		prev := dial

		if dir == 'L' {
			dial -= num
		} else {
			dial += num
		}

		if dial < 0 {
			dial += 100
		}

		dial = (dial % 100)

		if dial == 0 {
			cnt++
			continue
		}

		if dir == 'L' && dial > prev && prev != 0 {
			cnt++
		} else if dir == 'R' && dial < prev && prev != 0 {
			cnt++
		}
	}

	return cnt
}
