package cmd

import (
	"bytes"
	"fmt"
	"net/http"
	"os"
	"strconv"

	"github.com/spf13/cobra"
)

var (
	closeCmd = &cobra.Command{
		Use:   "close ISSUE-NUM -u usr -t tkn",
		Short: "Close issue in github",
		Args:  cobra.MinimumNArgs(1),
		Run:   closeIssue,
	}
)

func init() {
	closeCmd.MarkPersistentFlagRequired("username")
	closeCmd.MarkPersistentFlagRequired("token")
}

func closeIssue(cmd *cobra.Command, args []string) {
	issueNum, err := strconv.Atoi(args[0])
	if err != nil || issueNum < 1 {
		fmt.Fprintf(os.Stderr, "ISSUE-NUM must be a valid positive integer\n")
		os.Exit(1)
	}

	url := fmt.Sprintf(issuesURL, owner, repo) + "/" + args[0]
	buf := bytes.NewBuffer([]byte(`{"state":"close"}`))
	req, err := http.NewRequest("PATCH", url, buf)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Creating new close issue request failed with reason: %v\n", err)
		os.Exit(1)
	}

	req.Header.Add("Accept", "application/vnd.github.v3+json")
	addBasicAuth(req)
	res, err := http.DefaultClient.Do(req)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Closing the issue failed, reason: %v\n", err)
		os.Exit(1)
	}
	defer res.Body.Close()

	if res.StatusCode > 199 && res.StatusCode < 300 {
		fmt.Printf("Issue number %d is closed successfully\n", issueNum)
		os.Exit(0)
	}

	resBody := bytes.NewBuffer([]byte{})
	resBody.ReadFrom(res.Body)
	resBody.WriteTo(os.Stderr)
}
