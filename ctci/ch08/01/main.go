// Triple Step: A child is running up a staircase with n steps and can
// hop either 1 step, 2 steps, or 3 steps at a time. Implement a
// method to count how many possible ways the child can run up the stairs.

package main

func main() {
}

func countWays(n int) int {
	if n < 3 {
		return n
	}
	a := 1
	b := 2
	c := 4
	var tmp int

	for i := 3; i < n; i++ {
		tmp = a + b + c
		a = b
		b = c
		c = tmp
	}

	return c
}
