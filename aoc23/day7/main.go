package main

import (
	"bufio"
	"bytes"
	"fmt"
	"os"
	"sort"
	"strconv"
	"strings"
)

var cardsRank = map[rune]int{
	'A': 14,
	'K': 13,
	'Q': 12,
	'T': 10,
	'9': 9,
	'8': 8,
	'7': 7,
	'6': 6,
	'5': 5,
	'4': 4,
	'3': 3,
	'2': 2,
	'J': 1, // or 11 for v1
}

const (
	typeHighCard = iota
	typeOnePair
	typeTwoPair
	typeThreeOfAKind
	typeFullHouse
	typeFourOfAKind
	typeFiveOfAKind
)

type hand struct {
	cards []rune
	bid   int
}

type handSorter struct {
	hands []hand
}

func (hs *handSorter) Len() int {
	return len(hs.hands)
}

func (hs *handSorter) Swap(i, j int) {
	hs.hands[i], hs.hands[j] = hs.hands[j], hs.hands[i]
}

func handTypeV2(cards []rune) int {
	ht := handType(cards)

	m := map[rune]int{}
	for _, card := range cards {
		m[card]++
	}

	// update the original hand type
	switch ht {
	case typeFourOfAKind:
		if m['J'] == 1 || m['J'] == 4 {
			return typeFiveOfAKind
		}
	case typeFullHouse:
		if m['J'] == 2 || m['J'] == 3 {
			return typeFiveOfAKind
		}
	case typeThreeOfAKind:
		if m['J'] == 1 || m['J'] == 3 {
			return typeFourOfAKind
		}
	case typeTwoPair:
		if m['J'] == 1 {
			return typeFullHouse
		}
		if m['J'] == 2 {
			return typeFourOfAKind
		}
	case typeOnePair:
		if m['J'] == 1 || m['J'] == 2 {
			return typeThreeOfAKind
		}
	case typeHighCard:
		if m['J'] == 1 {
			return typeOnePair
		}
	}

	return ht
}

func handType(cards []rune) int {
	m := map[rune]int{}
	for _, card := range cards {
		m[card]++
	}

	if len(m) == 1 {
		return typeFiveOfAKind
	}

	var (
		pairsCnt       int
		threeOfKindCnt int
	)
	for _, cnt := range m {
		switch cnt {
		case 4:
			return typeFourOfAKind
		case 3:
			threeOfKindCnt++
		case 2:
			pairsCnt++
		}
	}

	if threeOfKindCnt == 1 && pairsCnt == 1 {
		return typeFullHouse
	}
	if threeOfKindCnt == 1 && pairsCnt == 0 {
		return typeThreeOfAKind
	}
	if pairsCnt == 2 {
		return typeTwoPair
	}
	if pairsCnt == 1 {
		return typeOnePair
	}

	return typeHighCard
}

// is 'i' less than 'j'
func (hs *handSorter) Less(i, j int) bool {
	left := hs.hands[i]
	right := hs.hands[j]

	// v1
	//lt := handType(left.cards)
	//rt := handType(right.cards)

	lt := handTypeV2(left.cards)
	rt := handTypeV2(right.cards)
	if lt == rt {
		for i := 0; i < len(left.cards); i++ {
			lr := cardsRank[left.cards[i]]
			rr := cardsRank[right.cards[i]]
			if lr < rr {
				return true
			}
			if rr < lr {
				return false
			}
		}
	}

	return lt < rt
}

func main() {
	hands, err := readInputFile("input")
	if err != nil {
		fmt.Printf("reading file: %s", err)
		os.Exit(1)
	}

	fmt.Println(sumV1(hands))
}

func sumV1(hands []hand) int {
	m := map[int]string{
		typeHighCard:     "high card",
		typeOnePair:      "one pair",
		typeTwoPair:      "two pair",
		typeThreeOfAKind: "three of a kind",
		typeFullHouse:    "full house",
		typeFourOfAKind:  "four of a kind",
		typeFiveOfAKind:  "five of a kind",
	}

	sort.Sort(&handSorter{hands: hands})

	var sum int
	for i, h := range hands {
		fmt.Printf("%s - %s\n", string(h.cards), m[handTypeV2(h.cards)])
		sum += ((i + 1) * h.bid)
	}

	return sum
}

func readInputFile(filename string) ([]hand, error) {
	data, err := os.ReadFile(filename)
	if err != nil {
		return nil, err
	}

	scanner := bufio.NewScanner(bytes.NewReader(data))
	scanner.Split(bufio.ScanLines)

	hands := []hand{}
	for scanner.Scan() {
		line := scanner.Text()
		cards, bid, _ := strings.Cut(line, " ")
		num, err := strconv.Atoi(bid)
		if err != nil {
			panic(fmt.Sprintf("error parsing %q: %s", bid, err))
		}

		hands = append(hands, hand{
			cards: []rune(cards),
			bid:   num,
		})
	}

	return hands, nil
}
