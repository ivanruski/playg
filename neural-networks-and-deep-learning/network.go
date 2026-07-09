package main

import (
	"fmt"
	"math"
	"math/rand"

	"github.com/ivanruski/playg/neural-networks-and-deep-learning/numgo"
)

type Network struct {
	num_layers int
	sizes      []int

	weights [][][]float64
	biases  [][]float64
}

// net = NewNetwork([]int{2, 3, 1}) will create a network with 2 neurons in the
// first layer, 3 neurons in the second layer, and 1 neuron in the final
// layer. The first layer is the input layer.
func NewNetwork(sizes []int) Network {
	n := Network{
		num_layers: len(sizes),
		sizes:      sizes,
	}

	// weights/biases[0] will always be empty because we don't have w & b for the 1st layer
	weights := make([][][]float64, len(sizes))
	biases := make([][]float64, len(sizes))

	// trying to stick to the book where w³₁₄ is the weight going from 4th
	// neuron in 2nd layer to the 1st neuron in the 3rd layer
	for l := 1; l < n.num_layers; l++ {
		weights[l] = make([][]float64, sizes[l])
		biases[l] = make([]float64, sizes[l])

		for j := range sizes[l] {
			weights[l][j] = make([]float64, sizes[l-1])

			for k := range sizes[l-1] {
				weights[l][j][k] = rand.NormFloat64()
			}
		}
	}

	n.weights = weights
	n.biases = biases

	return n
}

func (n *Network) FeedForward(a []float64) []float64 {
	for l := 1; l < n.num_layers; l++ {
		anext := []float64{}

		for j := range n.sizes[l] {
			w := n.weights[l][j]
			b := n.biases[l][j]

			z := numgo.DotProduct(w, a) + b
			anext = append(anext, sigmoid(z))
		}

		a = anext
	}

	return a
}

type TrainingSample struct {
	X []float64
	Y []float64
}

// Brute force implementation, where backprop is not being used
func (n *Network) NaiveSGD(training_data []TrainingSample, epochs, mini_batch_size int, eta float64) {
	d_gradient := make([][][]float64, n.num_layers)
	d_biases := make([][]float64, n.num_layers)
	for l := 1; l < n.num_layers; l++ {
		d_gradient[l] = make([][]float64, n.sizes[l])
		d_biases[l] = make([]float64, n.sizes[l])
		for j := range n.sizes[l] {
			d_gradient[l][j] = make([]float64, n.sizes[l-1])
		}
	}

	wg := make([][][]float64, n.num_layers)
	wb := make([][]float64, n.num_layers)
	for l := 1; l < n.num_layers; l++ {
		wg[l] = make([][]float64, n.sizes[l])
		wb[l] = make([]float64, n.sizes[l])
		for j := range n.sizes[l] {
			wg[l][j] = make([]float64, n.sizes[l-1])
		}
	}

	for range epochs {

		batches := batchTrainingData(training_data, mini_batch_size)
		for i, batch := range batches {

			fmt.Printf("batch %d out of %d\n", i, len(batches))

			for _, training_sample := range batch {

				for l := 1; l < n.num_layers; l++ {
					for j := range n.sizes[l] {
						for k := range n.sizes[l-1] {
							w := n.weights[l][j][k]
							n.weights[l][j][k] = w - eta

							c1 := cost(training_sample.Y, n.FeedForward(training_sample.X))

							n.weights[l][j][k] = w + eta

							c2 := cost(training_sample.Y, n.FeedForward(training_sample.X))

							wg[l][j][k] = (c2 - c1) / 2 * eta

							n.weights[l][j][k] = w
						}
					}
				}

				for l := 1; l < n.num_layers; l++ {
					for j := range n.sizes[l] {
						b := n.biases[l][j]
						n.biases[l][j] = b - eta

						c1 := cost(training_sample.Y, n.FeedForward(training_sample.X))

						n.biases[l][j] = b + eta

						c2 := cost(training_sample.Y, n.FeedForward(training_sample.X))

						wb[l][j] = (c2 - c1) / 2 * eta

						n.biases[l][j] = b
					}
				}

				// add the per sample rate of change
				for l := 1; l < n.num_layers; l++ {
					for j := range n.sizes[l] {

						d_biases[l][j] += wb[l][j]
						for k := range n.sizes[l-1] {
							d_gradient[l][j][k] += wg[l][j][k]
						}
					}
				}
			}

			// average d_gradient & d_biases over the batch_size
			for l := 1; l < n.num_layers; l++ {
				for j := range n.sizes[l] {

					d_biases[l][j] /= float64(mini_batch_size)
					for k := range n.sizes[l-1] {
						d_gradient[l][j][k] += float64(mini_batch_size)
					}
				}
			}

			// update the weights & biases after the batch is complete
			for l := 1; l < n.num_layers; l++ {
				for j := range n.sizes[l] {

					n.biases[l][j] += d_biases[l][j]
					for k := range n.sizes[l-1] {
						n.weights[l][j][k] += d_gradient[l][j][k]
					}
				}
			}
		}
	}
}

// For now simply split, not randomization
func batchTrainingData(training_data []TrainingSample, batch_size int) [][]TrainingSample {
	batch_cnt := len(training_data)/batch_size + 1
	batches := make([][]TrainingSample, 0, batch_cnt)
	for i := 0; i < len(training_data); i += batch_size {
		batches = append(
			batches,
			training_data[i:min(i+batch_size, len(training_data))],
		)
	}

	return batches
}

func sigmoid(z float64) float64 {
	return 1.0 / (1.0 + math.Exp(-z))
}

func sigmoid2(z []float64) []float64 {
	vectorized := make([]float64, len(z))
	for i, zi := range z {
		vectorized[i] = sigmoid(zi)
	}

	return vectorized
}

// C = 1/2*||y - a||^2
func cost(y, a []float64) float64 {
	c := numgo.VectorLen(numgo.Sub(y, a))

	return (c * c) / 2
}
