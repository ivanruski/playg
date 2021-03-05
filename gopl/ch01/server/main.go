// Exercise 1.12: Modify the Lissajous server to read parameter values from the
// URL. For example, you might arrange it so that a URL like
// http://localhost:8000/?cycles=20 sets the number of cycles to 20 instead of the
// default 5. Use the strconv.Atoi function to convert the string parameter into an
// integer. You can see its documentation with go doc strconv.Atoi.

// Lissajous generates GIF animations of random Lissajous figures.
package main

import (
	"image"
	"image/color"
	"image/gif"
	"io"
	"math"
	"math/rand"
	"strconv"
)

// Packages not needed by version in book.
import (
	"log"
	"net/http"
	"time"
)

type gifconfig struct {
	cycles  float64
	res     float64
	size    float64
	nframes int
	delay   int
}

var (
	palette = []color.Color{color.White, color.Black}
	config  = gifconfig{
		cycles:  5,
		res:     0.001,
		size:    100,
		nframes: 64,
		delay:   8,
	}
)

const (
	whiteIndex = 0 // first color in palette
	blackIndex = 1 // next color in palette
)

func main() {
	//!-main
	// The sequence of images is deterministic unless we seed
	// the pseudo-random number generator using the current time.
	// Thanks to Randall McPherson for pointing out the omission.
	rand.Seed(time.Now().UTC().UnixNano())

	handler := func(w http.ResponseWriter, r *http.Request) {
		r.ParseForm()
		if nframes := r.Form.Get("nframes"); nframes != "" {
			if num, err := strconv.Atoi(nframes); err == nil {
				config.nframes = num
			}
		}
		lissajous(w)
	}
	http.HandleFunc("/", handler)

	log.Fatal(http.ListenAndServe("localhost:8000", nil))
}

func lissajous(out io.Writer) {
	freq := rand.Float64() * 3.0 // relative frequency of y oscillator
	anim := gif.GIF{LoopCount: config.nframes}
	phase := 0.0 // phase difference
	size := config.size
	for i := 0; i < config.nframes; i++ {
		rect := image.Rect(0, 0, 2*int(size)+1, 2*int(size)+1)
		img := image.NewPaletted(rect, palette)
		for t := 0.0; t < config.cycles*2*math.Pi; t += config.res {
			x := math.Sin(t)
			y := math.Sin(t*freq + phase)
			img.SetColorIndex(int(size)+int(x*size+0.5), int(size)+int(y*size+0.5),
				blackIndex)
		}
		phase += 0.1
		anim.Delay = append(anim.Delay, config.delay)
		anim.Image = append(anim.Image, img)
	}
	gif.EncodeAll(out, &anim) // NOTE: ignoring encoding errors
}
