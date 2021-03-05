// Exercise 1.7: The function call io.Copy(dst, src) reads from src
// and writes to dst. Use it instead of ioutil.ReadAll to copy
// response body to os.Stdout without requiring a buffer large enough
// to hold the entire stream. Be sure to check the error result of
// io.Copy

package main

import (
	"fmt"
	"io"
	"net/http"
	"os"
	"strings"
)

func main() {
	for _, url := range os.Args[1:] {
		if strings.HasPrefix(url, "http://") == false &&
			strings.HasPrefix(url, "https://") == false {
			url = "http://" + url
		}
		resp, err := http.Get(url)
		if err != nil {
			fmt.Fprintf(os.Stderr, "fetch: %v\n", err)
			os.Exit(1)
		}
		_, errCopy := io.Copy(os.Stdout, resp.Body)
		resp.Body.Close()
		if errCopy != nil {
			fmt.Fprintf(os.Stderr, "fetch: reading %s: %v\n", url, errCopy)
			os.Exit(1)
		}
	}
}
