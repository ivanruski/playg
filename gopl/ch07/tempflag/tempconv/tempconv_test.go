package tempconv

import (
	"testing"
)

func TestKelvinToCelsius(t *testing.T) {
	c := KToC(Kelvin(273.15))
	if c != 0 {
		t.Errorf("KToC = %v; want 0", c)
	}

	c = KToC(Kelvin(0))
	if c != -273.15 {
		t.Errorf("KToC = %v; want -273.15", c)
	}
}

func TestCelsiusToKelvin(t *testing.T) {
	k := CToK(Celsius(0))
	if k != 273.15 {
		t.Errorf("CToK = %v, want 273.15", k)
	}

	k = CToK(Celsius(273.15))
	if k != 546.3 {
		t.Errorf("CToK = %v, want 546.3", k)
	}
}

func TestKelvinToFahrenheit(t *testing.T) {
	f := KToF(Kelvin(10))
	want := CToF(KToC(10))
	if f != want {
		t.Errorf("KToF = %v, want %v", f, want)
	}
}

func TestFahrenheitToKelvin(t *testing.T) {
	k := FToK(23)
	want := CToK(FToC(23))
	if k != want {
		t.Errorf("KToF = %v, want %v", k, want)
	}
}
