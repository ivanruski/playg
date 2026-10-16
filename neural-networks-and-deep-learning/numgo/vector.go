package numgo

import (
	"fmt"
	"math"
)

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

func MatrixMul(x, y [][]float64) [][]float64 {
	if len(x[0]) != len(y) {
		return nil
	}

	ty := Transpose(y)
	m := make([][]float64, len(x))
	for i, xi := range x {
		m[i] = MatrixByVector(ty, xi)
	}

	return m
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

func MatrixHadamardAdd(m [][]float64, v []float64) [][]float64 {
	r := make([][]float64, len(m))

	for i := range m {
		r[i] = make([]float64, len(m[0]))
	}

	for j := range m[0] {
		for i := range m {
			r[i][j] = m[i][j] + v[i]
		}
	}

	return r
}

func MatrixSub(m1, m2 [][]float64) [][]float64 {
	r := make([][]float64, len(m1))

	for i := range m1 {
		r[i] = make([]float64, len(m1[i]))
		for j := range m1[i] {
			r[i][j] = m1[i][j] - m2[i][j]
		}
	}

	return r
}

func MatrixHadamard(m1, m2 [][]float64) [][]float64 {
	if len(m1) != len(m2) {
		panic(fmt.Sprintf("m1(len = %d) != m2(len = %d)", len(m1), len(m2)))
	}

	r := make([][]float64, len(m1))

	for i := range m1 {
		r[i] = make([]float64, len(m1[i]))
		if len(m1[i]) != len(m2[i]) {
			panic(fmt.Sprintf("len(m1[%d]) != (m2[%d])", len(m1[i]), len(m2[i])))
		}
		for j := range m1[i] {
			r[i][j] = m1[i][j] * m2[i][j]
		}
	}

	return r
}

func Sub(x, y []float64) []float64 {
	r := make([]float64, 0, len(x))

	for i, xi := range x {
		r = append(r, xi-y[i])
	}

	return r
}

func Add(x, y []float64) []float64 {
	r := make([]float64, 0, len(x))

	for i, xi := range x {
		r = append(r, xi+y[i])
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

func Vectorize(v []float64, fn func(float64) float64) []float64 {
	r := make([]float64, 0, len(v))

	for _, vi := range v {
		r = append(r, fn(vi))
	}

	return r
}

func Matrixize(m [][]float64, fn func(float64) float64) [][]float64 {
	r := make([][]float64, len(m))

	for i := range m {
		r[i] = make([]float64, len(m[i]))

		for j := 0; j < len(m[i]); j++ {
			r[i][j] = fn(m[i][j])
		}
	}

	return r
}
