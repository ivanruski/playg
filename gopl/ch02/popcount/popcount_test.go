package popcount

import (
	"testing"
)

func TestPopCountBitByBit(t *testing.T) {
	var x uint64 = 2298456661
	bitcount := PopCountBitByBit(x)

	if bitcount != 18 {
		t.Errorf("PopCountBitByBit got: %d, want 18", bitcount)
	}

	x = 2298456660
	bitcount = PopCountBitByBit(x)

	if bitcount != 17 {
		t.Errorf("PopCountBitByBit got: %d, want 17", bitcount)
	}

	x = 1048576
	bitcount = PopCountBitByBit(x)

	if bitcount != 1 {
		t.Errorf("PopCountBitByBit got: %d, want 1", bitcount)
	}
}

func TestPopCount3(t *testing.T) {
	var x uint64 = 2298456661
	bitcount := PopCount3(x)

	if bitcount != 18 {
		t.Errorf("PopCountBitByBit got: %d, want 18", bitcount)
	}

	x = 2298456660
	bitcount = PopCount3(x)

	if bitcount != 17 {
		t.Errorf("PopCountBitByBit got: %d, want 17", bitcount)
	}

	x = 1048576
	bitcount = PopCount3(x)

	if bitcount != 1 {
		t.Errorf("PopCountBitByBit got: %d, want 1", bitcount)
	}
}
