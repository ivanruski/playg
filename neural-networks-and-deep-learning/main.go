package main

import (
	"fmt"
	"log"
	"os"
	"time"

	"github.com/ivanruski/playg/neural-networks-and-deep-learning/mnist"
)

func main() {
	dataset, err := mnist.ReadDataSet(
		"./data/mnist/train-images-idx3-ubyte/train-images-idx3-ubyte",
		"./data/mnist/train-labels-idx1-ubyte/train-labels-idx1-ubyte",
	)

	if err != nil {
		log.Printf("reading dataset failed: %s", err)
		os.Exit(1)
	}

	training_data := normalizeMnistDataset(dataset)
	net := NewNetwork([]int{784, 20, 10})

	fmt.Println("before training", time.Now())
	net.NaiveSGD(training_data, 1, 10, 1)
	fmt.Println("post training", time.Now())
}

// convert an mnist image representation to one dimensional vector and the digit its represent
// to 10 element slice where the element at index=digit is 1.0
func normalizeMnistDataset(dataset *mnist.DataSet) []TrainingSample {
	data := make([]TrainingSample, 0, len(dataset.Data))
	for _, datum := range dataset.Data {
		digit := make([]float64, 10)
		digit[datum.Digit] = 1.0
		data = append(data, TrainingSample{
			X: flattenImage(datum.Image),
			Y: digit,
		})
	}

	return data
}

func flattenImage(image [][]uint8) []float64 {
	f := make([]float64, 0, len(image)*len(image[0]))

	for _, row := range image {
		for _, pixel := range row {
			f = append(f, float64(pixel)/255.0)
		}
	}

	return f
}

func printMatrix(m [][]float64) {
	for i := 0; i < len(m); i++ {
		for j := 0; j < len(m[i]); j++ {
			fmt.Printf("%.10f ", m[i][j])
		}
		fmt.Println()
	}
	fmt.Println()
}
