package main

import (
	"context"
	"encoding/json"
	"fmt"
	"math"
	"math/rand"
	"os"

	"github.com/ivanruski/playg/neural-networks-and-deep-learning/numgo"
)

const epsilon = 0.0001

type Network struct {
	NumLayers int
	Sizes     []int

	Weights [][][]float64
	Biases  [][]float64
}

func NewNetworkFromState() *Network {
	n := &Network{}
	n.loadState()
	return n
}

// net = NewNetwork([]int{2, 3, 1}) will create a network with 2 neurons in the
// first layer, 3 neurons in the second layer, and 1 neuron in the final
// layer. The first layer is the input layer.
func NewNetwork(sizes []int) *Network {
	n := &Network{
		NumLayers: len(sizes),
		Sizes:     sizes,
	}

	// weights/biases[0] will always be empty because we don't have w & b for the 1st layer
	weights := make([][][]float64, len(sizes))
	biases := make([][]float64, len(sizes))

	// trying to stick to the book where w³₁₄ is the weight going from 4th
	// neuron in 2nd layer to the 1st neuron in the 3rd layer
	for l := 1; l < n.NumLayers; l++ {
		weights[l] = make([][]float64, sizes[l])
		biases[l] = make([]float64, sizes[l])

		for j := range sizes[l] {
			biases[l][j] = rand.NormFloat64()
			weights[l][j] = make([]float64, sizes[l-1])

			for k := range sizes[l-1] {
				weights[l][j][k] = rand.NormFloat64()
			}
		}
	}

	n.Weights = weights
	n.Biases = biases

	return n
}

func (n *Network) FeedForward(a []float64) []float64 {
	_, a_m := n.FeedForwardBackprop(a)

	return a_m[n.NumLayers-1]
}

func (n *Network) FeedForwardBackprop(a []float64) ([][]float64, [][]float64) {
	z_m := make([][]float64, n.NumLayers)
	a_m := make([][]float64, n.NumLayers)

	a_m[0] = a

	for l := 1; l < n.NumLayers; l++ {
		z_m[l] = make([]float64, n.Sizes[l])
		a_m[l] = make([]float64, n.Sizes[l])

		anext := []float64{}

		for j := range n.Sizes[l] {
			w := n.Weights[l][j]
			b := n.Biases[l][j]

			z := numgo.DotProduct(w, a) + b
			a := sigmoid(z)

			z_m[l][j] = z
			a_m[l][j] = a

			anext = append(anext, a)
		}

		a = anext
	}

	return z_m, a_m
}

type TrainingSample struct {
	X []float64 // input
	Y []float64 // expected output
}

func (n *Network) NaiveSGD(ctx context.Context, training_data []TrainingSample, epochs, mini_batch_size int, eta float64) {
	for range epochs {
		batches := batchTrainingData(training_data, mini_batch_size)
		for i, batch := range batches {

			d_gradient := make([][][]float64, n.NumLayers)
			d_biases := make([][]float64, n.NumLayers)
			for l := 1; l < n.NumLayers; l++ {
				d_gradient[l] = make([][]float64, n.Sizes[l])
				d_biases[l] = make([]float64, n.Sizes[l])
				for j := range n.Sizes[l] {
					d_gradient[l][j] = make([]float64, n.Sizes[l-1])
				}
			}

			wg := make([][][]float64, n.NumLayers)
			wb := make([][]float64, n.NumLayers)
			for l := 1; l < n.NumLayers; l++ {
				wg[l] = make([][]float64, n.Sizes[l])
				wb[l] = make([]float64, n.Sizes[l])
				for j := range n.Sizes[l] {
					wg[l][j] = make([]float64, n.Sizes[l-1])
				}
			}

			preTrainingBatchCost := batchCost(n, batch)

			for _, training_sample := range batch {

				select {
				case <-ctx.Done():
					fmt.Println("ctx.Done, saving state and exiting")
					n.saveState()
					return
				default:
					for l := 1; l < n.NumLayers; l++ {
						for j := range n.Sizes[l] {
							for k := range n.Sizes[l-1] {
								w := n.Weights[l][j][k]
								n.Weights[l][j][k] = w - epsilon

								c1 := cost(training_sample.Y, n.FeedForward(training_sample.X))

								n.Weights[l][j][k] = w + epsilon

								c2 := cost(training_sample.Y, n.FeedForward(training_sample.X))

								wg[l][j][k] = (c2 - c1) / (2 * epsilon)

								n.Weights[l][j][k] = w
							}
						}
					}

					for l := 1; l < n.NumLayers; l++ {
						for j := range n.Sizes[l] {
							b := n.Biases[l][j]
							n.Biases[l][j] = b - epsilon

							c1 := cost(training_sample.Y, n.FeedForward(training_sample.X))

							n.Biases[l][j] = b + epsilon

							c2 := cost(training_sample.Y, n.FeedForward(training_sample.X))

							wb[l][j] = (c2 - c1) / (2 * epsilon)

							n.Biases[l][j] = b
						}
					}

					// add the per sample rate of change
					for l := 1; l < n.NumLayers; l++ {
						for j := range n.Sizes[l] {

							d_biases[l][j] += wb[l][j]
							for k := range n.Sizes[l-1] {
								d_gradient[l][j][k] += wg[l][j][k]
							}
						}
					}
				}
			}

			// average d_gradient & d_biases over the batch_size
			for l := 1; l < n.NumLayers; l++ {
				for j := range n.Sizes[l] {

					d_biases[l][j] /= float64(len(batch))
					for k := range n.Sizes[l-1] {
						d_gradient[l][j][k] /= float64(len(batch))
					}
				}
			}

			// update the weights & biases after the batch is complete
			for l := 1; l < n.NumLayers; l++ {
				for j := range n.Sizes[l] {

					n.Biases[l][j] -= (d_biases[l][j] * eta)
					for k := range n.Sizes[l-1] {
						n.Weights[l][j][k] -= (d_gradient[l][j][k] * eta)
					}
				}
			}

			postTrainingBatchCost := batchCost(n, batch)
			fmt.Printf("batch %d/%d\n", i, len(batches))
			fmt.Printf("cost before: %f\n", preTrainingBatchCost)
			fmt.Printf("cost  after: %f\n", postTrainingBatchCost)
		}
	}
}

func (n *Network) SGD(ctx context.Context, training_data []TrainingSample, epochs, mini_batch_size int, eta float64) {
	for range epochs {
		batches := batchTrainingData(training_data, mini_batch_size)

		for i, batch := range batches {

			wg := make([][][]float64, n.NumLayers)
			bg := make([][]float64, n.NumLayers)
			for l := 1; l < n.NumLayers; l++ {
				wg[l] = make([][]float64, n.Sizes[l])
				bg[l] = make([]float64, n.Sizes[l])
				for j := range n.Sizes[l] {
					wg[l][j] = make([]float64, n.Sizes[l-1])
				}
			}

			preTrainingBatchCost := batchCost(n, batch)

			for _, training_sample := range batch {

				select {
				case <-ctx.Done():
					fmt.Println("ctx.Done, saving state and exiting")
					n.saveState()
					return
				default:
					z_m, a_m := n.FeedForwardBackprop(training_sample.X)

					zL := z_m[len(z_m)-1]
					aL := a_m[len(a_m)-1]

					dM := make([][]float64, n.NumLayers)
					// Cₓ = C
					// 1. compute the ouput error δᴸ = ∇ₐC ⊙ σ′(zᴸ)
					dM[n.NumLayers-1] = outputError(zL, aL, training_sample.Y)

					// 2. backprop the error δˡ = ((wˡ⁺¹)ᵀ * δˡ⁺¹) ⊙ σ′(zˡ)
					for l := n.NumLayers - 2; l > 0; l-- {
						wT := numgo.Transpose(n.Weights[l+1])
						dM[l] = backpropError(wT, dM[l+1], z_m[l])
					}

					// accumulate ∂C/∂wˡⱼk & ∂C/∂bˡⱼ

					// 3. ∂C/∂wˡⱼk = aˡ⁻¹k*δˡⱼ
					for l := 1; l < n.NumLayers; l++ {
						for j := range n.Sizes[l] {
							for k := range n.Sizes[l-1] {
								wg[l][j][k] += a_m[l-1][k] * dM[l][j]
							}
						}
					}

					// 4. ∂C/∂bˡⱼ = δˡⱼ
					for l := 1; l < n.NumLayers; l++ {
						for j := range n.Sizes[l] {
							bg[l][j] += dM[l][j]
						}
					}
				}
			}

			// average the accumulated values in wg & bg
			for l := 1; l < n.NumLayers; l++ {
				for j := range n.Sizes[l] {

					bg[l][j] /= float64(len(batch))
					for k := range n.Sizes[l-1] {
						wg[l][j][k] /= float64(len(batch))
					}
				}
			}

			// do the gradient descent step
			for l := 1; l < n.NumLayers; l++ {
				for j := range n.Sizes[l] {

					n.Biases[l][j] -= (eta * bg[l][j])
					for k := range n.Sizes[l-1] {
						n.Weights[l][j][k] -= (eta * wg[l][j][k])
					}
				}
			}

			postTrainingBatchCost := batchCost(n, batch)
			fmt.Printf("batch %d/%d\n", i, len(batches))
			fmt.Printf("cost before: %f\n", preTrainingBatchCost)
			fmt.Printf("cost  after: %f\n", postTrainingBatchCost)
		}
	}
}

func batchCost(n *Network, training_data []TrainingSample) float64 {
	var sum float64

	for _, sample := range training_data {
		sum += cost(sample.Y, n.FeedForward(sample.X))
	}

	return sum / float64(len(training_data))
}

func (n *Network) loadState() {
	data, err := os.ReadFile("./.state/net.json")
	if err != nil {
		fmt.Printf("reading state file: %s\n", err)
	}

	net := Network{}
	err = json.Unmarshal(data, &net)
	if err != nil {
		fmt.Printf("unsmarshaling state file: %s\n", err)
	}

	*n = net
}

func (n *Network) saveState() {
	data, err := json.Marshal(n)
	if err != nil {
		panic(fmt.Sprintf("save state: %s", err))
	}

	os.WriteFile("./.state/net.json", data, 0664)
}

func (n *Network) EvalPerformance(test_data []TrainingSample) {
	var correct, incorrect int

	for _, input := range test_data {
		activations := n.FeedForward(input.X)
		if numgo.IndexOfMax(activations) == numgo.IndexOfMax(input.Y) {
			correct++
		} else {
			incorrect++
		}
	}

	fmt.Printf("Performance:\ncorrect: %d, incorrect: %d\n", correct, incorrect)
}

func batchTrainingData(training_data []TrainingSample, batch_size int) [][]TrainingSample {
	rand.Shuffle(len(training_data), func(i, j int) {
		training_data[i], training_data[j] = training_data[j], training_data[i]
	})

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
	return 1. / (1. + math.Exp(-z))
}

// compute the ouput error δᴸ = ∇ₐC ⊙ σ′(zᴸ)
func outputError(zL, aL, y []float64) []float64 {
	return numgo.HadamardProduct(
		output_gradient(aL, y),
		sigmoidPrimeVector(zL),
	)
}

// backprop the error δˡ = ((wˡ⁺¹)ᵀ * δˡ⁺¹) ⊙ σ′(zˡ)
func backpropError(wT [][]float64, errorFromNextLayer, zL []float64) []float64 {
	return numgo.HadamardProduct(
		numgo.MatrixByVector(wT, errorFromNextLayer),
		sigmoidPrimeVector(zL),
	)
}

func sigmoidPrimeVector(zL []float64) []float64 {
	dL := make([]float64, len(zL))
	for i, z := range zL {
		dL[i] = sigmoid_prime(z)
	}

	return dL
}

func sigmoid_prime(z float64) float64 {
	return math.Exp(-z) / math.Pow(1.+math.Exp(-z), 2)
}

func output_gradient(a, y []float64) []float64 {
	return numgo.Sub(a, y)
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
