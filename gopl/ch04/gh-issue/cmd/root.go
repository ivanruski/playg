package cmd

import (
	"encoding/base64"
	"net/http"

	"github.com/spf13/cobra"
)

const issuesURL = "https://api.github.com/repos/%s/%s/issues"

var (
	owner, repo string
	usr, token  string

	rootCmd = &cobra.Command{
		Short: "CRUD operations for issues in github",
		Long: `Tool that lets users create, read, update, and close
GitHub issues from the command line, invoking their preferred
text editor when substantial text input is required.`,
	}
)

func init() {
	rootCmd.PersistentFlags().StringVarP(&owner, "owner", "o", "", "Owner")
	rootCmd.PersistentFlags().StringVarP(&repo, "repo", "r", "", "Repository")
	rootCmd.PersistentFlags().StringVarP(&usr, "username", "u", "",
		"Username used for basic auth")
	rootCmd.PersistentFlags().StringVarP(&token, "token", "t", "",
		"Token used instead of pass for basic auth")

	rootCmd.MarkPersistentFlagRequired("owner")
	rootCmd.MarkPersistentFlagRequired("repo")
}

func Execute() error {
	rootCmd.AddCommand(createCmd)
	rootCmd.AddCommand(getCmd)
	rootCmd.AddCommand(closeCmd)
	return rootCmd.Execute()
}

func addBasicAuth(req *http.Request) {
	usrToken := base64.URLEncoding.EncodeToString([]byte(usr + ":" + token))

	req.Header.Add("Authorization", "Basic "+usrToken)
}
