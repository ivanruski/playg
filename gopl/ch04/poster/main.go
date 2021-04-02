package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"image/jpeg"
	"net/http"
	"net/url"
	"os"
)

var (
	postApiUrl    = "http://img.omdbapi.com/"
	apiUrl        = "http://omdbapi.com/"
	apiKey        = "d9019d42"
	usageTemplate = `usage: poster <movie-title>

If the movie title consists of several words wrap them around
single or double quotes.

exmaple:
poster "Modern Family"`
)

func main() {
	if len(os.Args) == 1 {
		fmt.Println(usageTemplate)
		return
	}

	movieTitle := os.Args[1]
	movieID, err := getMovieID(movieTitle)
	if err != nil {
		fmt.Fprintf(os.Stderr, "%v\n", err)
		os.Exit(1)
	}

	img, err := getMoviePoster(movieID)
	if err != nil {
		fmt.Fprintf(os.Stderr, "%v\n", err)
		os.Exit(1)
	}

	filePath, err := savePoster(img, movieTitle)
	if err != nil {
		fmt.Fprintf(os.Stderr, "%v\n", err)
		os.Exit(1)
	}

	fmt.Printf("File saved at %s\n", filePath)
}

func savePoster(img []byte, fileName string) (string, error) {
	wd, err := os.Getwd()
	if err != nil {
		return "", fmt.Errorf("can't get current working directory: %v\n", err)
	}

	filePath := wd + "/" + fileName + ".jpeg"
	err = os.WriteFile(filePath, img, 0744)
	if err != nil {
		return "", fmt.Errorf("can't write file to disk: %v\n", err)
	}

	return filePath, nil
}

func getMoviePoster(movieID string) ([]byte, error) {
	requrl := postApiUrl + "?i=" + movieID + "&apiKey=" + apiKey
	res, err := http.Get(requrl)
	if err != nil {
		return nil, fmt.Errorf("get moviePoster failed: %v\n", err)
	}
	defer res.Body.Close()

	buf := bytes.Buffer{}
	buf.ReadFrom(res.Body)
	if !(res.StatusCode > 199 && res.StatusCode < 300) {
		return nil, fmt.Errorf("StatusCode: %d\nResponse: %s\n", res.StatusCode, string(buf.Bytes()))
	}

	_, err = jpeg.Decode(bytes.NewBuffer(buf.Bytes()))
	if err != nil {
		return nil, fmt.Errorf("can decode poster: %v\n", err)
	}

	return buf.Bytes(), nil
}

func getMovieID(movieTitle string) (string, error) {
	requrl := apiUrl + "?t=" + url.QueryEscape(movieTitle) + "&apiKey=" + apiKey
	res, err := http.Get(requrl)
	if err != nil {
		return "", fmt.Errorf("get movieId failed: %v\n", err)
	}
	defer res.Body.Close()

	buf := bytes.Buffer{}
	buf.ReadFrom(res.Body)
	if !(res.StatusCode > 199 && res.StatusCode < 300) {
		return "", fmt.Errorf("StatusCode: %d\nResponse: %s\n", res.StatusCode, string(buf.Bytes()))
	}

	resModel := struct {
		ID       string `json:"imdbID"`
		Response string
		Error    string
	}{}
	err = json.Unmarshal(buf.Bytes(), &resModel)
	if err != nil {
		return "", fmt.Errorf("getMovieID: unmarshal response: %v\n", err)
	}

	if resModel.Response == "False" {
		return "", fmt.Errorf("StatusCode: %d\nResponse: %s\n", res.StatusCode, resModel.Error)
	}

	return resModel.ID, nil
}
