package main

import (
	"bufio"
	"bytes"
	"fmt"
	"os"
	"strconv"
	"strings"
	"unicode"
)

func main() {
	lines, err := readInputFile("input")
	if err != nil {
		fmt.Printf("reading input file: %s\n", err)
		os.Exit(1)
	}

	var sum int
	for _, line := range lines {
		sum += extractCalibrationValueV2(line)
	}

	fmt.Printf("value: %d\n", sum)
}

// --- Part One ---
func extractCalibrationValueV1(line string) int {
	var first, last rune = 'x', 'x'
	for _, c := range line {
		if !unicode.IsDigit(c) {
			continue
		}

		if first == 'x' {
			first = c
		} else {
			last = c
		}
	}

	if last == 'x' {
		last = first
	}

	num, _ := strconv.Atoi(string([]rune{first, last}))
	return num
}

// --- Part Two ---
func extractCalibrationValueV2(line string) int {
	var first, last rune = 'x', 'x'
	for i, c := range line {
		var digit rune = 'x'
		if unicode.IsDigit(c) {
			digit = c
		} else {
			d, ok := tryReadSpelledDigit(line[i:])
			if ok {
				digit = digits[d]
			}
		}

		if digit == 'x' {
			continue
		}

		if first == 'x' {
			first = digit
		} else {
			last = digit
		}
	}

	if last == 'x' {
		last = first
	}

	num, _ := strconv.Atoi(string([]rune{first, last}))
	return num
}

var digits = map[string]rune{
	"one":   '1',
	"two":   '2',
	"three": '3',
	"four":  '4',
	"five":  '5',
	"six":   '6',
	"seven": '7',
	"eight": '8',
	"nine":  '9',
}

func tryReadSpelledDigit(s string) (string, bool) {
	for digit := range digits {
		if strings.HasPrefix(s, digit) {
			return digit, true
		}
	}

	return "", false
}

func readInputFile(file string) ([]string, error) {
	data, err := os.ReadFile(file)
	if err != nil {
		return nil, err
	}

	scanner := bufio.NewScanner(bytes.NewReader(data))
	scanner.Split(bufio.ScanLines)

	lines := []string{}
	for scanner.Scan() {
		lines = append(lines, scanner.Text())
	}

	return lines, nil
}
