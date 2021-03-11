// Exercise 3.13: Write const declarations for KB, MB, up through YB as
// compactly as you can.

package main

import "fmt"

const (
	B  = 1
	KB = B * 1000
	MB = KB * 1000
	GB = MB * 1000
	TB = GB * 1000
	PB = TB * 1000
	EB = PB * 1000
	ZB = EB * 1000
	YB = ZB * 1000
)

const (
	_   = 1 // << (10 * iota)
	KiB     // 1024
	MiB     // 1048576
	GiB     // 1073741824
	TiB     // 1099511627776              (exceeds 1 << 32)
	PiB     // 1125899906842624
	EiB     // 1152921504606846976
	ZiB     // 1180591620717411303424     (exceeds 1 << 64)
	YiB     // 1208925819614629174706176
)

func doStuff(value []string) {
	fmt.Printf("value=%v\n", value)

	value2 := value[:]
	value2 = append(value2, "b")
	fmt.Printf("value=%v, value2=%v\n", value, value2)

	value2[0] = "z"
	value = append(value, "w")
	fmt.Printf("value=%v, value2=%v\n", value, value2)
}

func main() {
	slice1 := []string{"a"} // length 1, capacity 1

	doStuff(slice1)
	// Output:
	// value=[a] -- ok
	// value=[a], value2=[a b] -- ok: value unchanged, value2 updated
	// value=[a], value2=[z b] -- ok: value unchanged, value2 updated

	slice10 := make([]string, 1, 10) // length 1, capacity 10
	slice10[0] = "a"

	doStuff(slice10)
	// Output:
	// value=[a] -- ok
	// value=[a], value2=[a b] -- ok: value unchanged, value2 updated
	// value=[z], value2=[z b] -- WTF?!? value changed???
}
