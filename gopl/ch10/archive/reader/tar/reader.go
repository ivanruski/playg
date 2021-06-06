package tar

import (
	"archive/tar"
	"fmt"
	"io"
	"os"

	"github.com/ivanruski/playg/gopl/ch10/archive/reader"
)

func init() {
	reader.RegisterFormat("tar", ListContents)
}

// ListContents returns a slice with the contents of a tar
func ListContents(tarName string) ([]string, error) {
	file, err := os.Open(tarName)
	if err != nil {
		return nil, err
	}

	result := []string{}
	tr := tar.NewReader(file)
	for {
		h, err := tr.Next()
		if err == io.EOF {
			break
		}
		if err != nil {
			return nil, fmt.Errorf("advancing tar reader failed: %w", err)
		}

		result = append(result, h.Name)
	}

	return result, nil
}
