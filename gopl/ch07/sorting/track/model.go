package track

import (
	"fmt"
	"os"
	"text/tabwriter"
	"time"
)

type Tracks []*Track

type Track struct {
	Title  string
	Artist string
	Album  string
	Year   int
	Length time.Duration
}

func (ts Tracks) PrintToConsole() {
	const format = "%v\t%v\t%v\t%v\t%v\t\n"
	tw := new(tabwriter.Writer).Init(os.Stdout, 0, 8, 2, ' ', 0)
	fmt.Fprintf(tw, format, "Title", "Artist", "Album", "Year", "Length")
	fmt.Fprintf(tw, format, "-----", "------", "-----", "----", "------")
	for _, t := range ts {
		fmt.Fprintf(tw, format, t.Title, t.Artist, t.Album, t.Year, t.Length)
	}
	tw.Flush() // calculate column widths and print table
}
