// Build Order: You are given a list of projects and a list of dependencies
// (which is a list of pairs of projects, where the second project is dependent
// on the first project). All of a project's dependencies must be build before
// the the project is. Find a build order that will allow the projects to be
// build. If there is no valid build order, rturn an error.
//
// EXAMPLE
//
// Input:
//   projects: a, b, c, d, e, f
//   dependencies: (a, d), (f, b), (b, d), (f, a), (d, c)
//
// Output: f, e, a, b, d, c

package main

import (
	"errors"
	"fmt"
	"sort"
)

func main() {}

type DepPair struct {
	ProjName string
	DepName  string
}

type Proj struct {
	Name string
	Deps []*Proj
}

func CreateProjects(projects []string) map[string]*Proj {
	projs := make(map[string]*Proj, len(projects))
	for _, p := range projects {
		projs[p] = &Proj{Name: p}
	}

	return projs
}

func SetDeps(pairs []DepPair, projects map[string]*Proj) error {
	for _, pair := range pairs {
		depender, ok := projects[pair.ProjName]
		if !ok {
			return fmt.Errorf("project '%s' does not exists", pair.ProjName)
		}
		dependee, ok := projects[pair.DepName]
		if !ok {
			return fmt.Errorf("project '%s' does not exists", pair.DepName)
		}

		depender.Deps = append(depender.Deps, dependee)
	}

	return nil
}

func HasCycle(projs map[string]*Proj) bool {
	visited := map[string]struct{}{}
	inTheStack := map[string]struct{}{}

	var detectCycle func(*Proj) bool

	detectCycle = func(proj *Proj) bool {
		if _, ok := visited[proj.Name]; ok {
			return false
		}
		for _, d := range proj.Deps {
			if _, ok := inTheStack[d.Name]; ok {
				return true
			}

			inTheStack[d.Name] = struct{}{}
			if detectCycle(d) {
				return true
			}
			delete(inTheStack, d.Name)
		}

		visited[proj.Name] = struct{}{}
		return false
	}

	for name, p := range projs {
		if _, ok := visited[name]; ok {
			continue
		}

		if detected := detectCycle(p); detected {
			return true
		}
	}

	return false
}

func BuildOrder(projs map[string]*Proj) ([]string, error) {
	if HasCycle(projs) {
		return nil, errors.New("cycle detected")
	}

	// get the keys and sort them, because it's easier to test
	keys := make([]string, 0, len(projs))
	for k := range projs {
		keys = append(keys, k)
	}
	sort.Strings(keys)

	// find the projects on which no other projects depend
	roots := []*Proj{}
	for _, name := range keys {
		p := projs[name]
		if !hasDependees(p, projs) {
			roots = append(roots, p)
		}
	}

	visited := map[string]struct{}{}
	order := make([]string, 0, len(projs))
	// put the projects that have no deps and no one depends on them at the end (again because of the tests)
	loners := []string{}

	for _, k := range keys {
		if _, ok := visited[k]; ok {
			continue
		}
		proj := projs[k]
		if len(proj.Deps) == 0 {
			loners = append(loners, proj.Name)
			continue
		}

		ord := getBuildOrder(proj, visited)
		order = append(order, ord...)
	}

	order = append(order, loners...)

	return order, nil
}

func getBuildOrder(proj *Proj, visited map[string]struct{}) []string {
	order := []string{}
	for _, d := range proj.Deps {
		if _, ok := visited[d.Name]; ok {
			continue
		}

		ord := getBuildOrder(d, visited)
		order = append(order, ord...)
	}

	visited[proj.Name] = struct{}{}
	order = append(order, proj.Name)
	return order
}

func hasDependees(proj *Proj, projs map[string]*Proj) bool {
	for _, p := range projs {
		if p == proj {
			continue
		}

		for _, d := range p.Deps {
			if d == proj {
				return true
			}
		}
	}

	return false
}
