package main

import (
	"bufio"
	"bytes"
	"fmt"
	"math"
	"os"
	"strconv"
	"strings"
)

type card struct {
	id          int
	winningNums map[int]struct{}
	nums        []int
}

func main() {
	cards, err := readInputFile("input")
	if err != nil {
		fmt.Printf("reading file: %s", err)
		os.Exit(1)
	}

	fmt.Println(sumV2(cards))
}

func sumV1(cards []card) int {
	var sum int
	for _, card := range cards {
		var winCnt int
		for _, n := range card.nums {
			if _, ok := card.winningNums[n]; ok {
				winCnt++
			}
		}

		if winCnt > 0 {
			score := math.Pow(2, float64(winCnt-1))
			sum += int(score)
		}
	}

	return sum
}

func sumV2(cards []card) int {
	originals := map[int]card{}
	for _, card := range cards {
		originals[card.id] = card
	}

	cntByGame := map[int]int{}
	for i := 0; i < len(cards); i++ {
		winCnt, ok := cntByGame[cards[i].id]
		if !ok {
			for _, n := range cards[i].nums {
				if _, ok := cards[i].winningNums[n]; ok {
					winCnt++
				}
			}

			cntByGame[cards[i].id] = winCnt
		}

		if winCnt > 0 {
			cardID := cards[i].id
			for j := 1; j <= winCnt; j++ {
				cards = append(cards, originals[cardID+j])
			}
		}
	}

	return len(cards)
}

func readInputFile(file string) ([]card, error) {
	data, err := os.ReadFile(file)
	if err != nil {
		return nil, err
	}

	scanner := bufio.NewScanner(bytes.NewReader(data))
	scanner.Split(bufio.ScanLines)

	cards := []card{}
	for scanner.Scan() {
		line := scanner.Text()

		cards = append(cards, card{
			id:          parseGameID(line),
			winningNums: parseWinningNums(line),
			nums:        parseNums(line),
		})
	}

	return cards, nil
}

func parseGameID(line string) int {
	metadata, _, _ := strings.Cut(line, ":")
	id := strings.TrimLeft(metadata, "Card ")
	num, err := strconv.Atoi(id)
	if err != nil {
		panic(fmt.Sprintf("parsing %q: %s", id, err))
	}

	return num
}

func parseWinningNums(line string) map[int]struct{} {
	_, game, _ := strings.Cut(line, ":")
	wnums, _, _ := strings.Cut(game, "|")
	nums := strings.Split(strings.Trim(wnums, " "), " ")

	set := map[int]struct{}{}
	for _, wn := range nums {
		if wn == "" {
			continue
		}

		n, err := strconv.Atoi(wn)
		if err != nil {
			panic(fmt.Sprintf("parsing %q: %s", wn, err))
		}

		set[n] = struct{}{}
	}

	return set
}

func parseNums(line string) []int {
	_, game, _ := strings.Cut(line, ":")
	_, gnums, _ := strings.Cut(game, "|")
	nums := strings.Split(strings.Trim(gnums, " "), " ")

	ns := []int{}
	for _, gn := range nums {
		if gn == "" {
			continue
		}

		n, err := strconv.Atoi(gn)
		if err != nil {
			panic(fmt.Sprintf("parsing %q: %s", gn, err))
		}

		ns = append(ns, n)
	}

	return ns
}
