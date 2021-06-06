package zip

import (
	"archive/zip"

	"github.com/ivanruski/playg/gopl/ch10/archive/reader"
)

func init() {
	reader.RegisterFormat("zip", ListContents)
}

// ListContents returns a slice with the contents of a zip
func ListContents(zipName string) ([]string, error) {
	zrc, err := zip.OpenReader(zipName)
	if err != nil {
		return nil, err
	}

	result := make([]string, 0, len(zrc.File))
	for _, f := range zrc.File {
		result = append(result, f.Name)
	}

	return result, nil
}
