// English Int: Given any integer print an English phrase that describes the
// integer (e.g. "One Thousand Two Hundred Thirty Four")
// 
// https://leetcode.com/problems/integer-to-english-words/

package main

import (
	"fmt"
	"strconv"
)

func main() {
}

func numberToWords(num int) string {
	if num == 0 {
		return ones["0"]
	}

	ns := strconv.Itoa(num)
	return numToWords(numberStr(ns))
}

var (
	ones = map[numberStr]string{
		"0": "Zero",
		"1": "One",
		"2": "Two",
		"3": "Three",
		"4": "Four",
		"5": "Five",
		"6": "Six",
		"7": "Seven",
		"8": "Eight",
		"9": "Nine",
	}

	tens = map[numberStr]string{
		"10": "Ten",
		"11": "Eleven",
		"12": "Twelve",
		"13": "Thirteen",
		"14": "Fourteen",
		"15": "Fifteen",
		"16": "Sixteen",
		"17": "Seventeen",
		"18": "Eighteen",
		"19": "Nineteen",

		"2": "Twenty",
		"3": "Thirty",
		"4": "Forty",
		"5": "Fifty",
		"6": "Sixty",
		"7": "Seventy",
		"8": "Eighty",
		"9": "Ninety",
	}
)

type numberStr string

func numToWords(num numberStr) string {
	if num == "" {
		return ""
	}

	n, r := split(num)

	nname := numName(n, len(r))
	rname := numToWords(r)
	if nname == "" {
		return rname
	}
	if rname == "" {
		return nname
	}

	return nname + " " + rname
}

func numName(num numberStr, digitsAfter int) string {
	if num == "0" || num == "00" || num == "000" {
		return ""
	}

	var name, placeName string

	switch len(num) {
	case 1:
		name = ones[num]
	case 2:
		name = tensName(num)
	case 3:
		name = hundredsName(num)
	}

	switch digitsAfter {
	case 0:
	case 3:
		placeName = " Thousand"
	case 6:
		placeName = " Million"
	case 9:
		placeName = " Billion"
	}

	return name + placeName
}

func hundredsName(num numberStr) string {
	fd := num[0:1]
	sd := num[1:2]
	td := num[2:3]

	if fd == "0" {
		return tensName(num[1:])
	}
	if sd == "0" && td == "0" {
		return ones[fd] + " Hundred"
	}
	if sd == "0" {
		return ones[fd] + " Hundred " + ones[td]
	}

	return ones[fd] + " Hundred " + tensName(num[1:])
}

func tensName(num numberStr) string {
	if num[0:1] == "0" {
		return ones[num[1:]]
	}
	if num[0:1] == "1" {
		return tens[num]
	}

	fd := num[0:1]
	sd := num[1:2]
	if sd == "0" {
		return tens[fd]
	}

	return tens[fd] + " " + ones[sd]
}

// split splits a number in two.
//
// It tries to take up to 3 digits from the beginning of the number and returns
// the remaining digits, which are either 0 or multiple of 3
func split(num numberStr) (numberStr, numberStr) {
	take := len(num) % 3
	if take == 0 {
		take = 3
	}

	return num[0:take], num[take:]
}
