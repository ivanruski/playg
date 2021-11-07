// A cinema has n rows of seats, numbered from 1 to n and there are ten seats in
// each row, labelled from 1 to 10 as shown in the figure above.
//
// Given the array reservedSeats containing the numbers of seats already
// reserved, for example, reservedSeats[i] = [3,8] means the seat located in row
// 3 and labelled with 8 is already reserved.
//
// Return the maximum number of four-person groups you can assign on the cinema
// seats. A four-person group occupies four adjacent seats in one single
// row. Seats across an aisle (such as [3,3] and [3,4]) are not considered to be
// adjacent, but there is an exceptional case on which an aisle split a
// four-person group, in that case, the aisle split a four-person group in the
// middle, which means to have two people on each side.
//
// Example 1:
// Input: n = 3, reservedSeats = [[1,2],[1,3],[1,8],[2,6],[3,1],[3,10]]
// Output: 4
// Explanation: The figure above shows the optimal allocation for four groups,
// where seats mark with x are already reserved and contiguous seats mark
// with v are for one group.
//
//     1   2   3       4   5   6   7       8   9   10
// 1 |   | x | x |   | v | v | v | v |   | x |   |   |
// 2 |   | v | v |   | v | v | x |   |   |   |   |   |
// 3 | x | v | v |   | v | v | v | v |   | v | v | x |
//
////
// Example 2:
// Input: n = 2, reservedSeats = [[2,1],[1,8],[2,6]]
// Output: 2
//
// Example 3:
// Input: n = 4, reservedSeats = [[4,3],[1,4],[4,6],[1,7]]
// Output: 4
//
// Constraints:
// 1 <= n <= 10^9
// 1 <= reservedSeats.length <= min(10*n, 10^4)
// reservedSeats[i].length == 2
// 1 <= reservedSeats[i][0] <= n
// 1 <= reservedSeats[i][1] <= 10
// All reservedSeats[i] are distinct.
//
// link: https://leetcode.com/problems/cinema-seat-allocation/

package main

func main() {

}

func maxNumberOfFamilies(n int, reservedSeats [][]int) int {
	dirtyRols := map[int]*struct {
		maxf      int
		dirtyCols [10]int
	}{}

	for _, seat := range reservedSeats {
		row := seat[0] - 1
		col := seat[1] - 1
		dr, ok := dirtyRols[row]
		if !ok {
			cols := [10]int{}
			cols[col] = 1
			dirtyRols[row] = &struct {
				maxf      int
				dirtyCols [10]int
			}{getMaxNumberOfFamiliesForRow(cols), cols}
		} else {
			dr.dirtyCols[col] = 1
			dr.maxf = getMaxNumberOfFamiliesForRow(dr.dirtyCols)
		}
	}

	var max int
	for _, r := range dirtyRols {
		max += r.maxf
	}
	max += (n - len(dirtyRols)) * 2
	return max
}

func getMaxNumberOfFamiliesForRow(cols [10]int) int {
	if (cols[1] == 0 && cols[2] == 0 && cols[3] == 0 && cols[4] == 0) &&
		(cols[5] == 0 && cols[6] == 0 && cols[7] == 0 && cols[8] == 0) {
		return 2
	}
	if cols[1] == 0 && cols[2] == 0 && cols[3] == 0 && cols[4] == 0 {
		return 1
	}
	if cols[5] == 0 && cols[6] == 0 && cols[7] == 0 && cols[8] == 0 {
		return 1
	}
	if cols[3] == 0 && cols[4] == 0 && cols[5] == 0 && cols[6] == 0 {
		return 1
	}
	return 0
}
