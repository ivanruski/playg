// Operations: Write methods to implement the multiply, subtract, and divide
// operations for integers. The results of all of these are integers. You can
// use the add operator, but not minus, times or divide.

package main

import (
	"fmt"
	"math"
)

func main() {
	fmt.Println(mul(5, -5))
	fmt.Println(5 * -5)
}

func ext(a, b int) int {
	return a + twosComplement(b)
}

func mul(a, b int) int {
	signBit := sign(a, b)
	a = abs(a)
	b = abs(b)

	var result int
	for i := 0; i < b; i++ {
		result += a
	}

	if signBit == 1 {
		return twosComplement(result)
	}

	return result
}

func div(a, b int) int {
	if b == 0 {
		return 0
	}

	signBit := sign(a, b)
	a = abs(a)
	b = abs(b)

	var cnt int
	for {
		a = ext(a, b)
		if a >= 0 {
			cnt++
		} else {
			break
		}
	}

	if signBit == 1 {
		return twosComplement(cnt)
	}

	return cnt
}

func sign(a, b int) int {
	if (a > 0 && b < 0) || (a < 0 && b > 0) {
		return 1
	}

	return 0
}

func abs(num int) int {
	if num < 0 {
		return twosComplement(num)
	}

	return num
}

func twosComplement(num int) int {
	c := (uint64(num) ^ math.MaxUint64) + 1

	return int(c)
}
