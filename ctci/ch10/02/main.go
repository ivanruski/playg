// Group Anagrams: Write a method to sort an array of strings so that
// all the anagrams are next to each other.
//
// The only difference in leetcode is that the anagarms must be
// grouped into separate slices.
// https://leetcode.com/problems/group-anagrams/

package main

import "sort"

func main() {}

func groupAnagrams(strs []string) [][]string {
	var rs []rune
	sortRuneSlice := func(i, j int) bool {
		return rs[i] < rs[j]
	}

	m := map[string][]string{}
	for _, str := range strs {
		rs = []rune(str)
		sort.Slice(rs, sortRuneSlice)
		m[string(rs)] = append(m[string(rs)], str)
	}

	result := make([][]string, 0, len(m))
	for _, values := range m {
		result = append(result, values)
	}

	return result
}
