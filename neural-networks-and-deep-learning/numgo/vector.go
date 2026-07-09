package numgo

import "math"

func VectorLen(v []float64) float64 {
	var len float64
	for _, n := range v {
		len += n * n
	}

	return math.Sqrt(len)
}

func DotProduct(x, y []float64) float64 {
	sum := 0.0
	for i := range x {
		sum += x[i] * y[i]
	}

	return sum
}

func HadamardProduct(x, y []float64) []float64 {
	res := make([]float64, len(x))
	for i := range x {
		res[i] = x[i] * y[i]
	}

	return res
}

func Sub(x, y []float64) []float64 {
	r := make([]float64, 0, len(x))

	for i, xi := range x {
		r = append(r, xi-y[i])
	}

	return r
}
