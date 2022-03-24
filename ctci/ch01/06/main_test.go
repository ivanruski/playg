package main

import "testing"

func TestStringCompression(t *testing.T) {
	tests := map[string]struct {
		input string
		want  string
	}{
		"aabcccccaaa": {
			input: "aabcccccaaa",
			want:  "a2b1c5a3",
		},
		"iia": {
			input: "iia",
			want:  "iia",
		},
		"ii": {
			input: "ii",
			want:  "ii",
		},
		"i": {
			input: "i",
			want:  "i",
		},
		"empty string": {
			input: "",
			want:  "",
		},
		"iiiiiiiiiivvvvvvvvvvaaaaaaaaaannnnnnnnnn": {
			input: "iiiiiiiiiivvvvvvvvvvaaaaaaaaaannnnnnnnnn",
			want:  "i10v10a10n10",
		},
		"IIIaaIIIvvIIIiii": {
			input: "IIIaaIIIvvIIIiii",
			want:  "I3a2I3v2I3i3",
		},
	}

	for name, test := range tests {
		t.Run(name, func(t *testing.T) {
			got := StringCompression(test.input)
			if got != test.want {
				t.Errorf("Got: %s, want: %s", got, test.want)
			}
		})
	}
}
