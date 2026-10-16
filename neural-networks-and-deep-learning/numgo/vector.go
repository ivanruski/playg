package numgo

import "math"

func VectorLen(v []float64) float64 {
	var len float64
	for _, n := range v {
		len += n * n
	}

	return math.Sqrt(len)
}

// TODO: DotProduct will breake if len(x) != len(y)
func DotProduct(x, y []float64) float64 {
	sum := 0.0
	for i := range x {
		sum += x[i] * y[i]
	}

	return sum
}

func MatrixByVector(m [][]float64, v []float64) []float64 {
	result := make([]float64, len(m))

	for i, row := range m {
		result[i] = DotProduct(row, v)
	}

	return result
}

func Transpose(m [][]float64) [][]float64 {
	mT := make([][]float64, 0, len(m[0]))

	for c := range len(m[0]) {
		t := make([]float64, len(m))
		for r := range len(m) {
			t[r] = m[r][c]
		}

		mT = append(mT, t)
	}

	return mT
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

func IndexOfMax(v []float64) int {
	max := -1.
	maxI := -1
	for i, a := range v {
		if a > max {
			max = a
			maxI = i
		}
	}

	return maxI
}
