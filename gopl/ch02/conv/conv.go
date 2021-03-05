// Exercise2.2: Write a general-purpose unit-conversion program analogous to cf
// that reads numbers from its command-line arguments or from the standard input if
// there are no arguments, and converts each number into units like temperature in
// Celsius and Fahrenheit, length in feet and meters, weight in pounds and
// kilograms, and the like.

// Additional converters should by plugged in. Each converter will be a separate
// subcommand.

package main

import (
	"flag"
	"fmt"
	"os"
	"strconv"

	"gopl.io/ch02/tempconv"
)

func main() {
	if len(os.Args) < 2 {
		fmt.Fprintf(os.Stderr, "Subcommand is expected.\n")
		fmt.Fprintf(os.Stderr, `Possible subcommands: temp.
Run conv subcommand -h for more info.`)
		return
	}

	switch os.Args[1] {
	case "temp":
		initTempSubcmd()
	// case "length":
	default:
		fmt.Fprintf(os.Stderr,
			`Invalid subcommand: %s
Possible subcommands: temp, length.
Run conv subcommand -h for more info.`,
			os.Args[1])
	}
}

func initTempSubcmd() {
	f := flag.NewFlagSet("temp", flag.ExitOnError)

	help := f.Bool("help", false, "Usage: conv -m (ftok|ftoc|ctok|ctof|ktoc|ktof) [-n] num")
	neg := f.Bool("n", false, "If the passed temperature is negative, use -n")
	method := f.String("m", "", `Possible methods are:
    ftok - Fahrenheit to Kelvin
    ftoc - Fahrenheit to Celsius
    ctok - Celsius to Kelvin
    ctof - Celsius to Fahrenheit
    ktoc - Kelvin to Celsius
    ktof - Kelvin to Fahrenheit`)

	f.Parse(os.Args[2:])
	args := f.Args()

	if *help {
		f.PrintDefaults()
		return
	}
	if *method == "" {
		mflag := f.Lookup("m")
		fmt.Fprintf(os.Stderr, "Conversion method expected:\n%s", mflag.Usage)
		return
	}
	if len(args) != 1 {
		fmt.Fprintf(os.Stderr, "A number argument after the flag 'm' is expected.")
		return
	}

	from, err := strconv.ParseFloat(args[0], 64)
	if err != nil {
		fmt.Fprintf(os.Stderr, "The argument of type int is expected: %v", err)
		return
	}
	if *neg {
		from = -from
	}

	switch *method {
	case "ftok":
		fmt.Fprintf(os.Stdout, "%v\n", tempconv.FToK(tempconv.Fahrenheit(from)))
	case "ftoc":
		fmt.Fprintf(os.Stdout, "%v\n", tempconv.FToC(tempconv.Fahrenheit(from)))
	case "ctok":
		fmt.Fprintf(os.Stdout, "%v\n", tempconv.CToK(tempconv.Celsius(from)))
	case "ctof":
		fmt.Fprintf(os.Stdout, "%v\n", tempconv.CToF(tempconv.Celsius(from)))
	case "ktoc":
		fmt.Fprintf(os.Stdout, "%v\n", tempconv.KToC(tempconv.Kelvin(from)))
	case "ktof":
		fmt.Fprintf(os.Stdout, "%v\n", tempconv.KToF(tempconv.Kelvin(from)))
	default:
		fmt.Fprintf(os.Stderr, "Invalid conversion method")
	}
}
