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
	seq, _ := readFileInput("input")

	fmt.Println(sumV1(seq))
	fmt.Println(sumV2(seq))
}

func sumV1(seq []string) int {
	var sum int
	for _, s := range seq {
		sum += hash(s)
	}

	return sum
}

func sumV2(seq []string) int {
	boxes := make([]*box, 256)
	for i := 0; i < len(boxes); i++ {
		boxes[i] = &box{
			lenses: &slots{},
		}
	}

	for _, s := range seq {
		label, numstr, ok := strings.Cut(s, "=")
		if ok {
			idx := hash(label)
			num, _ := strconv.Atoi(numstr)

			box := boxes[idx]
			box.lenses.addOrReplace(&lense{label: label, foclen: num})
		} else {
			label, _, _ := strings.Cut(s, "-")
			idx := hash(label)

			box := boxes[idx]
			box.lenses.remove(&lense{label: label})
		}
	}

	var sum int
	for i, b := range boxes {
		slotNum := 1
		for l := b.lenses.front; l != nil; l = l.next {
			sum += (i + 1) * slotNum * l.foclen
			slotNum++
		}
	}

	return sum
}

type lense struct {
	label  string
	foclen int

	next *lense
}

type slots struct {
	front *lense
}

func (s *slots) addOrReplace(l *lense) {
	if s.front == nil {
		s.front = l
		return
	}

	curr := s.front
	for ; curr.next != nil; curr = curr.next {
		if curr.label == l.label {
			curr.foclen = l.foclen
			return
		}
	}

	if curr.label == l.label {
		curr.foclen = l.foclen
	} else {
		curr.next = l
	}
}

func (s *slots) remove(l *lense) {
	if s.front == nil {
		return
	}

	var prev *lense
	var curr = s.front

	for curr != nil {
		if curr.label == l.label {
			break
		}

		prev = curr
		curr = curr.next
	}

	if curr == nil {
		return
	}

	if prev == nil {
		s.front = curr.next
		return
	}

	prev.next = curr.next
}

type box struct {
	lenses *slots
}

func hash(s string) int {
	h := 0
	for _, s := range s {
		h += int(s)
		h *= 17
		h %= 256
	}

	return h
}

func readFileInput(filename string) ([]string, error) {
	data, err := os.ReadFile(filename)
	if err != nil {
		return nil, err
	}

	scanner := bufio.NewScanner(bytes.NewReader(data))
	scanner.Split(bufio.ScanLines)
	scanner.Scan()

	return strings.Split(scanner.Text(), ","), nil
}
