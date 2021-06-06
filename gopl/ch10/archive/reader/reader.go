package reader

import (
	"errors"
	"fmt"
	"sync"
)

type ContentLister func(archiveName string) ([]string, error)

var (
	supportedListers = map[string]ContentLister{}
	m                = sync.Mutex{}
)

func RegisterFormat(name string, listFn ContentLister) {
	m.Lock()
	defer m.Unlock()

	supportedListers[name] = listFn
}

func ListContents(archiveName string) ([]string, error) {
	if len(supportedListers) == 0 {
		return nil, errors.New("no registered archive listers")
	}

	for _, listFn := range supportedListers {
		contents, err := listFn(archiveName)
		if err == nil {
			return contents, nil
		}
	}

	return nil, fmt.Errorf("the format of %q is not supported", archiveName)
}
