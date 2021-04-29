// Exercise 7.6: Add support for Kelvin temperatures to tempflag.
//
// I will implement the example code from section 7.4 without
// extending it to work for Kelvin
//
// Exercise 7.7: Explain why the help message contains °C when the
// default value of 20.0 does not.
//
// Because CelsiusFlag embeds tempconv.Celsius and
// tempconv.Celsius implements `func String() string`, which is being
// promoted to CelsiusFlag and as a result CelsiusFlag satisfies the
// flag.Value interface

package main

import (
	"flag"
	"fmt"
	"ivanruski/gopl/ch07/tempconv"
)

type CelsiusFlag struct {
	tempconv.Celsius
}

func (cf *CelsiusFlag) Set(arg string) error {
	var (
		degrees float64
		scale   string
	)

	// it is safe to ignore the error
	fmt.Sscanf(arg, "%f%s", &degrees, &scale)
	switch scale {
	case "°C":
		cf.Celsius = tempconv.Celsius(degrees)
		return nil
	case "°F":
		cf.Celsius = tempconv.FToC(tempconv.Fahrenheit(degrees))
		return nil
	}

	return fmt.Errorf("%s is not valid, either °C or °F", scale)
}

func main() {
	var cf CelsiusFlag = CelsiusFlag{tempconv.Celsius(20)}

	flag.Var(&cf, "temp", "")
	flag.Parse()

	fmt.Println(cf)
}
