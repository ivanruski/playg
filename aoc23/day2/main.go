package main

import (
	"bufio"
	"bytes"
	"fmt"
	"os"
	"strconv"
	"strings"
)

type set struct {
	redCnt   int
	greenCnt int
	blueCnt  int
}

type game struct {
	id   int
	sets []set
}

func main() {
	games, err := readInputFile("input")
	if err != nil {
		fmt.Printf("reading input: %s", err)
		os.Exit(1)
	}

	sum := sumV2(games)
	fmt.Println(sum)
}

// The Elf would first like to know which games would have been possible if the
// bag contained only 12 red cubes, 13 green cubes, and 14 blue cubes?
func sumV1(games []game) int {
	var sum int
OUTER:
	for _, g := range games {
		for _, s := range g.sets {
			if s.redCnt > 12 || s.greenCnt > 13 || s.blueCnt > 14 {
				continue OUTER
			}
		}

		sum += g.id
	}

	return sum
}

func sumV2(games []game) int {
	var sum int
	for _, game := range games {
		var r, g, b = -1, -1, -1
		for _, s := range game.sets {
			if r < s.redCnt {
				r = s.redCnt
			}
			if g < s.greenCnt {
				g = s.greenCnt
			}
			if b < s.blueCnt {
				b = s.blueCnt
			}
		}

		sum += (r * g * b)
	}

	return sum
}

func readInputFile(file string) ([]game, error) {
	data, err := os.ReadFile(file)
	if err != nil {
		return nil, err
	}

	scanner := bufio.NewScanner(bytes.NewReader(data))
	scanner.Split(bufio.ScanLines)

	games := []game{}
	for scanner.Scan() {
		line := scanner.Text()

		games = append(games, game{
			id:   parseGameID(line),
			sets: parseSets(line),
		})
	}

	return games, nil
}

func parseGameID(line string) int {
	metadata, _, _ := strings.Cut(line, ":")
	_, id, _ := strings.Cut(metadata, " ")

	idnum, _ := strconv.Atoi(id)
	return idnum
}

func parseSets(line string) []set {
	_, game, _ := strings.Cut(line, ":")

	subsets := strings.Split(game, ";")
	sets := make([]set, 0, len(subsets))
	for _, subset := range subsets {
		cubes := strings.Split(subset, ",")
		var r, g, b int
		for _, cube := range cubes {
			num, color, _ := strings.Cut(strings.TrimLeft(cube, " "), " ")

			n, _ := strconv.Atoi(num)
			switch color {
			case "red":
				r += n
			case "green":
				g += n
			case "blue":
				b += n
			}
		}

		sets = append(sets, set{
			redCnt:   r,
			greenCnt: g,
			blueCnt:  b,
		})
	}

	return sets
}
