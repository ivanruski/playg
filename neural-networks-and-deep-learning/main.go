package main

import (
	"context"
	"flag"
	"fmt"
	"log"
	"os"
	"os/signal"
	"time"

	"github.com/ivanruski/playg/neural-networks-and-deep-learning/mnist"
)

func main() {
	var loadFromState bool
	flag.BoolVar(&loadFromState, "from-state", false, "preload weights and biases from file")
	flag.Parse()

	dataset, err := mnist.ReadDataSet(
		"./data/mnist/train-images-idx3-ubyte/train-images-idx3-ubyte",
		"./data/mnist/train-labels-idx1-ubyte/train-labels-idx1-ubyte",
	)

	if err != nil {
		log.Printf("reading dataset failed: %s", err)
		os.Exit(1)
	}

	var net *Network
	if loadFromState {
		net = NewNetworkFromState()
	} else {
		net = NewNetwork([]int{784, 30, 10})
	}

	data := normalizeMnistDataset(dataset)
	training_data := data[:50_000]
	test_data := data[50_000:]

	fmt.Println("before training", time.Now())
	net.EvalPerformance(test_data)

	ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt)
	defer stop()

	net.NaiveSGD(ctx, training_data, 1, 30, 1)

	fmt.Println("post training", time.Now())
	net.EvalPerformance(test_data)
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
