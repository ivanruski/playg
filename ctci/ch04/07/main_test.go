package main

import (
	"reflect"
	"testing"
)

func TestHasCycle(t *testing.T) {
	tests := map[string]struct {
		projects []string
		depPairs []DepPair

		want bool
	}{
		"NoCycle1": {
			projects: []string{"a", "b", "c", "d", "e", "f", "g"},
			depPairs: []DepPair{
				{ProjName: "d", DepName: "a"},
				{ProjName: "b", DepName: "f"},
				{ProjName: "d", DepName: "b"},
				{ProjName: "a", DepName: "f"},
				{ProjName: "c", DepName: "d"},
			},

			want: false,
		},
		"NoCycle2": {
			projects: []string{"a", "b", "c", "d", "e", "f", "g"},
			depPairs: []DepPair{
				{ProjName: "d", DepName: "a"},
				{ProjName: "b", DepName: "f"},
				{ProjName: "a", DepName: "b"},
				{ProjName: "a", DepName: "f"},
				{ProjName: "c", DepName: "d"},
			},

			want: false,
		},
		"Cycle1": {
			// c -> d -> a -> f -> c
			projects: []string{"a", "b", "c", "d", "e", "f", "g"},
			depPairs: []DepPair{
				{ProjName: "d", DepName: "a"},
				{ProjName: "b", DepName: "f"},
				{ProjName: "a", DepName: "b"},
				{ProjName: "a", DepName: "f"},
				{ProjName: "c", DepName: "d"},
				{ProjName: "f", DepName: "c"},
			},

			want: true,
		},
		"Cycle2": {
			// d -> a -> b -> d
			projects: []string{"a", "b", "c", "d", "e", "f", "g"},
			depPairs: []DepPair{
				{ProjName: "d", DepName: "a"},
				{ProjName: "b", DepName: "f"},
				{ProjName: "a", DepName: "b"},
				{ProjName: "a", DepName: "f"},
				{ProjName: "c", DepName: "d"},
				{ProjName: "b", DepName: "d"},
			},

			want: true,
		},
	}

	for name, test := range tests {
		t.Run(name, func(t *testing.T) {
			projs := CreateProjects(test.projects)
			SetDeps(test.depPairs, projs)

			got := HasCycle(projs)
			if got != test.want {
				t.Errorf("got: %v, want: %v", got, test.want)
			}
		})
	}
}

func TestBuildOrder(t *testing.T) {
	tests := map[string]struct {
		projects []string
		depPairs []DepPair

		want   []string
		expErr bool
	}{
		"One": {
			projects: []string{"a", "b", "c", "d", "e", "f"},
			depPairs: []DepPair{
				{ProjName: "d", DepName: "a"},
				{ProjName: "b", DepName: "f"},
				{ProjName: "d", DepName: "b"},
				{ProjName: "a", DepName: "f"},
				{ProjName: "c", DepName: "d"},
			},

			want: []string{"f", "a", "b", "d", "c", "e"},
		},
		"Two": {
			projects: []string{"a", "b", "c", "d", "e", "f"},

			want: []string{"a", "b", "c", "d", "e", "f"},
		},
		"Three": {
			projects: []string{"a", "b", "c", "d", "e", "f"},
			depPairs: []DepPair{
				{ProjName: "a", DepName: "b"},
				{ProjName: "a", DepName: "c"},
				{ProjName: "a", DepName: "d"},
				{ProjName: "a", DepName: "f"},
				{ProjName: "b", DepName: "c"},
				{ProjName: "d", DepName: "c"},
				{ProjName: "c", DepName: "e"},
			},

			want: []string{"e", "c", "b", "d", "f", "a"},
		},
		"Four": {
			projects: []string{"a", "b", "c", "d", "e", "f"},
			depPairs: []DepPair{
				{ProjName: "c", DepName: "d"},
				{ProjName: "d", DepName: "a"},
				{ProjName: "a", DepName: "f"},
				{ProjName: "a", DepName: "f"},
				{ProjName: "b", DepName: "e"},
			},

			want: []string{"f", "a", "e", "b", "d", "c"},
		},
		"Five": {
			projects: []string{"a", "b", "c", "d", "e", "f", "g", "h", "i"},
			depPairs: []DepPair{
				{ProjName: "a", DepName: "b"},
				{ProjName: "a", DepName: "f"},
				{ProjName: "b", DepName: "c"},
				{ProjName: "b", DepName: "g"},
				{ProjName: "f", DepName: "g"},
				{ProjName: "c", DepName: "d"},
				{ProjName: "g", DepName: "h"},
				{ProjName: "d", DepName: "e"},
				{ProjName: "h", DepName: "i"},
				{ProjName: "e", DepName: "h"},
			},

			want: []string{"i", "h", "e", "d", "c", "g", "b", "f", "a"},
		},
		"Six": {
			projects: []string{"a", "b", "c", "d", "e", "f", "g", "h", "i", "m"},
			depPairs: []DepPair{
				{ProjName: "a", DepName: "b"},
				{ProjName: "a", DepName: "f"},
				{ProjName: "b", DepName: "c"},
				{ProjName: "b", DepName: "g"},
				{ProjName: "f", DepName: "g"},
				{ProjName: "c", DepName: "d"},
				{ProjName: "g", DepName: "h"},
				{ProjName: "d", DepName: "e"},
				{ProjName: "h", DepName: "i"},
				{ProjName: "e", DepName: "h"},
				// cycle
				{ProjName: "d", DepName: "m"},
				{ProjName: "m", DepName: "a"},
			},

			expErr: true,
		},
	}

	for name, test := range tests {
		t.Run(name, func(t *testing.T) {
			projs := CreateProjects(test.projects)
			err := SetDeps(test.depPairs, projs)
			if err != nil {
				t.Fatalf("setDeps: %s", err)
			}

			got, err := BuildOrder(projs)
			if !test.expErr && err != nil {
				t.Fatalf("did not expect error, got one")
			}
			if test.expErr && err == nil {
				t.Fatalf("expected error, got none")
			}

			if !reflect.DeepEqual(got, test.want) {
				t.Errorf("got: %v, want: %v", got, test.want)
			}
		})
	}
}
