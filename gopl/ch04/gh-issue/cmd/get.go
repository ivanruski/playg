package cmd

import (
	"bytes"
	"encoding/json"
	"fmt"
	"net/http"
	"os"
	"strconv"

	"github.com/spf13/cobra"
)

type issueResp struct {
	IssueNum int    `json:"number"`
	Title    string `json:"title"`
	State    string `json:"state"`
	Url      string `josn:"url"`
}

var (
	issueNum int = 0
	getCmd = &cobra.Command{
		Use:   "get -o own -r rp -num x",
		Short: "Gets issue number x from the specified owner:repo",
		Run:   getIssues,
	}
)

func init() {
	getCmd.Flags().IntVarP(&issueNum, "issue-num", "n", 0,
		"Issue's number in the specified repo")
	getCmd.MarkFlagRequired("issue-num")
}

func getIssues(cmd *cobra.Command, args []string) {
	url := fmt.Sprintf(issuesURL, owner, repo)
	resp, err := http.Get(url + "/" + strconv.Itoa(issueNum))
	if err != nil {
		fmt.Fprintf(os.Stderr, "Get issue failed: %v", err)
		os.Exit(1)
	}

	buf := bytes.NewBuffer([]byte{})
	buf.ReadFrom(resp.Body)

	out := bytes.NewBuffer([]byte{})
	err = json.Indent(out, buf.Bytes(), "", "\t")
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error parsing the response: %s\n", err)
		os.Exit(1)
	}

	out.WriteTo(os.Stdout)
}
