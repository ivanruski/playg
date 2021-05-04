// Exercise 7.8: Many GUIs provide a table widget with a stateful
// multi-tier sort: the primary sort key is the most recently clicked
// column head, the secondary sort key is the second-most recently
// clicked column head, and so on. Define an implementation of
// sort.Interface for use by such a table. Compare that approach with
// repeated sorting using sort.Stable.

package main

import (
	"time"

	"ivanruski/gopl/ch07/sorting/track"
)

var tracks = track.Tracks{
	{Title: "Go Ahead", Artist: "Alicia Keys", Album: "As I Am", Year: 2007, Length: length("4m36s")},
	{Title: "Ready 2 Go", Artist: "Martin Solveig", Album: "Smash", Year: 2011, Length: length("4m24s")},
	{Title: "Angles", Artist: "Robbie Williams", Album: "Life thru a Lens", Year: 1997, Length: length("4m25s")},
	{Title: "Zombie", Artist: "Maitre Gims", Album: "Subliminal", Year: 2013, Length: length("4m05s")},
	{Title: "Go", Artist: "Moby", Album: "Moby", Year: 1992, Length: length("3m37s")},
	{Title: "Go", Artist: "Delilah", Album: "From the Roots Up", Year: 2012, Length: length("3m38s")},
	{Title: "a", Artist: "b", Album: "a", Year: 2021, Length: length("3m")},
	{Title: "a", Artist: "a", Album: "a", Year: 2021, Length: length("3m")},
}

func length(s string) time.Duration {
	d, err := time.ParseDuration(s)
	if err != nil {
		panic(s)
	}
	return d
}

func main() {
}
