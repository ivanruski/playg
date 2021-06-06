package tar

import (
	"testing"
)

func TestListContents(t *testing.T) {
	contents, err := ListContents("testdata/archive.zip")

	if err != nil {
		t.Errorf("unexpected err: %s", err)
	}

	expectedContents := map[string]int{
		"./archive/":                          0,
		"./archive/reader/":                   0,
		"./archive/reader/go.mod":             0,
		"./archive/reader/zip/":               0,
		"./archive/reader/reader.go":          0,
		"./archive/reader/tar/":               0,
		"./archive/reader/tar/archive.tar":    0,
		"./archive/reader/tar/reader.go":      0,
		"./archive/reader/tar/reader_test.go": 0,
	}

	if len(expectedContents) != len(contents) {
		t.Errorf("got %d contents, expected %d", len(contents), len(expectedContents))
		return
	}

	for _, c := range contents {
		occurCount, ok := expectedContents[c]
		if !ok {
			t.Errorf("%s is not expected to be in the tar", c)
			continue
		}
		if occurCount == 1 {
			t.Errorf("%s is found multiple times in the tar", c)
			continue
		}
		expectedContents[c]++
	}
}
