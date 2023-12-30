package main

import (
	"bufio"
	"bytes"
	"fmt"
	"os"
	"slices"
	"strings"
)

const bc = "broadcaster"

func main() {
	modules, _ := readFileInput("input")
	fmt.Println(sumV1(modules))
}

func sumV1(modules map[string]mod) int {
	var hs, ls int

	// for v2 use i < 10_000
	for i := 1; i <= 10_000; i++ {
		q := &queue[output]{}
		q.push(output{sig: 0, to: bc})

		var h, l = 0, 1
		for !q.empty() {
			out := q.pop()

			m, ok := modules[out.to]
			if !ok {
				continue
			}

			outs := m.receive(out.from, out.sig)
			for _, o := range outs {
				q.push(o)

				// TODO: for v2 get only the first 4 'i's and calculate the LCM value
				if slices.Contains([]string{"ln", "dr", "zx", "vn"}, o.from) && o.sig == 1 {
					fmt.Printf("%#v - sum(%d)\n", out, i)
				}

				if o.sig == 0 {
					l++
				} else {
					h++
				}

			}
		}

		hs += h
		ls += l
	}

	return hs * ls
}

type output struct {
	sig      int
	to, from string
}

type mod interface {
	receive(string, int) []output
	typ() string
	name() string
}

type flipFlop struct {
	id    string
	on    bool
	dests []string
}

func newFlipFlopModule(name string, dests ...string) mod {
	return &flipFlop{id: name, dests: dests}
}

func (f *flipFlop) typ() string {
	return "%"
}

func (f *flipFlop) name() string {
	return f.id
}

func (f *flipFlop) receive(_ string, sig int) []output {
	if sig == 1 {
		return nil
	}

	outputs := make([]output, 0, len(f.dests))
	if f.on {
		f.on = false
		for _, d := range f.dests {
			outputs = append(outputs, output{sig: 0, to: d, from: f.id})
		}
	} else {
		f.on = true
		for _, d := range f.dests {
			outputs = append(outputs, output{sig: 1, to: d, from: f.id})
		}
	}

	return outputs
}

type conjunction struct {
	id     string
	dests  []string
	states map[string]int
}

func newConjunctionModule(name string, dests ...string) mod {
	states := map[string]int{}

	cj := &conjunction{
		id:     name,
		dests:  dests,
		states: states,
	}

	return cj
}

func (*conjunction) typ() string {
	return "&"
}

func (c *conjunction) name() string {
	return c.id
}

func (c *conjunction) receive(from string, sig int) []output {
	c.states[from] = sig

	out := 1
	for _, s := range c.states {
		out &= s

		if out == 0 {
			break
		}
	}

	if out == 0 {
		out = 1
	} else {
		out = 0
	}

	outputs := make([]output, 0, len(c.dests))
	for _, d := range c.dests {
		outputs = append(outputs, output{sig: out, to: d, from: c.id})
	}

	return outputs
}

type broadcast struct {
	id    string
	dests []string
}

func newBroadcastModule(name string, dests ...string) *broadcast {
	return &broadcast{
		id:    name,
		dests: dests,
	}
}

func (*broadcast) typ() string {
	return "b"
}

func (b *broadcast) name() string {
	return b.id
}

func (b *broadcast) receive(_ string, sig int) []output {
	outputs := make([]output, 0, len(b.dests))
	for _, d := range b.dests {
		outputs = append(outputs, output{sig: sig, to: d, from: b.id})
	}

	return outputs
}

func readFileInput(filename string) (map[string]mod, error) {
	data, err := os.ReadFile(filename)
	if err != nil {
		return nil, err
	}

	scanner := bufio.NewScanner(bytes.NewReader(data))
	scanner.Split(bufio.ScanLines)

	temp := map[string][]string{}
	modules := map[string]mod{}
	for scanner.Scan() {
		line := scanner.Text()
		line = strings.ReplaceAll(line, " ", "")

		mod, out, _ := strings.Cut(line, "->")
		dests := strings.Split(out, ",")
		name := mod[1:]

		temp[name] = dests

		switch mod[0:1] {
		case "%":
			modules[name] = newFlipFlopModule(name, dests...)
		case "&":
			modules[name] = newConjunctionModule(name, dests...)
		default:
			modules[mod] = newBroadcastModule(mod, dests...)
		}
	}

	for name, mod := range modules {
		if mod.typ() == "&" {
			sources := []string{}

			for iname, dests := range temp {
				if iname == name {
					continue
				}

				if slices.Contains(dests, name) {
					sources = append(sources, iname)
				}
			}

			c := mod.(*conjunction)
			for _, s := range sources {
				c.states[s] = 0
			}
		}
	}

	return modules, nil
}

type node[T any] struct {
	value T
	next  *node[T]
}

type queue[T any] struct {
	first *node[T]
	last  *node[T]
}

func (q *queue[T]) push(elem T) {
	n := &node[T]{value: elem}

	if q.first == nil {
		q.first = n
		q.last = n

		return
	}

	q.last.next = n
	q.last = n
}

func (q *queue[T]) pop() T {
	var t T
	if q.first == nil {
		return t
	}

	t = q.first.value
	q.first = q.first.next

	return t
}

func (q *queue[T]) empty() bool {
	return q.first == nil
}
