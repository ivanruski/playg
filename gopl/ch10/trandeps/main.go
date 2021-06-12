// Exercise 10.4: Construct a tool that reports the set of all
// packages in the workspace that transitively depend on the packages
// specified by the arguments. Hint: you will need to run go list
// twice, once for the initial packages and once for all packages. You
// may want to parse its JSON output using the encoding/json package
// (§4.5).
//
// I understand this exercise as following:
// If in my workspace I have a package named pkg and one of package's
// imports is strings, and I run this program with ./transdeps errors,
// the program will output pkg

package main

import (
	"bufio"
	"bytes"
	"errors"
	"fmt"
	"log"
	"os"
	"os/exec"
	"strings"
)

func main() {
	depsPerPkg, err := getWorkspacePkgsAndTheirTransDeps()
	if err != nil {
		log.Fatal(err)
	}

	for pkg, deps := range depsPerPkg {
		if pkgTransitivelyDependsOn(deps, os.Args[1:]) {
			fmt.Println(pkg)
		}
	}
}

func pkgTransitivelyDependsOn(pkgDeps, pkgsInput []string) bool {
	for _, dep := range pkgDeps {
		for _, pkg := range pkgsInput {
			if dep == pkg {
				return true
			}
		}
	}
	return false
}

// getWorkspacePkgsAndTheirTransDeps returns each package in the
// workspace and it's transitive dependencies
func getWorkspacePkgsAndTheirTransDeps() (map[string][]string, error) {
	args := []string{
		"list", "-f", `'{{print .Name "|||" .Imports "|||" .Deps}}'`, "./...",
	}
	cmd := exec.Command("go", args...)
	cmdStdErr := &strings.Builder{}
	cmd.Stderr = cmdStdErr
	out, err := cmd.Output()
	if err != nil {
		return nil, fmt.Errorf("%s: %s", err, cmdStdErr.String())
	}

	pkgs := map[string][]string{}
	scanner := bufio.NewScanner(bytes.NewReader(out))
	scanner.Split(bufio.ScanLines)
	for scanner.Scan() {
		line := strings.Trim(scanner.Text(), "'")
		parts := strings.Split(line, "|||")
		if len(parts) != 3 {
			return nil, errors.New("go list returned invalid output")
		}
		name := parts[0]
		// parts[1] and parts[2] format is [a b c]
		imports := strings.Split(strings.Trim(parts[1], "[]"), " ")
		deps := strings.Split(strings.Trim(parts[2], "[]"), " ")
		for _, d := range deps {
			found := false
			for _, i := range imports {
				if i == d {
					found = true
					break
				}
			}
			if !found {
				pkgs[name] = append(pkgs[name], d)
			}
		}

	}

	return pkgs, nil
}
