package cmd

import (
	"bufio"
	"bytes"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"io/ioutil"
	"net/http"
	"os"
	"os/exec"
	"os/user"
	"strings"

	"github.com/spf13/cobra"
)

type createResp struct {
	IssueNum int `json:"number"`
}

var (
	issueTitle string
	issueBody  string
	createCmd  = &cobra.Command{
		Use:   "create -u usr -t tkn",
		Short: "Create new github issue",
		Long: `Create issue in a specified OWNER/REPO.
The command will open the $EDITOR for specifying the issue's title and body.`,
		Run: createIssue,
	}
	infoFileName     string = "CREATE_-_INFO"
	infoFileTemplate string = `

# Empty lines or lines starting with # are ignored.
# The first non-empty line not strating # is for the issue's title.
# The follwing non-empty consecutive lines not starting with # are for the issue's body.
`
)

func init() {
	createCmd.MarkPersistentFlagRequired("username")
	createCmd.MarkPersistentFlagRequired("token")
}

func createIssue(cmd *cobra.Command, args []string) {
	filePath, err := createAndWriteTemplateToInfoFile()
	if err != nil {
		fmt.Fprintf(os.Stderr, "creating issue failed: %v\n", err)
		os.Exit(1)
	}

	err = openEditor(filePath)
	if err != nil {
		fmt.Fprintf(os.Stderr, "creating issue failed: %v\n", err)
		os.Exit(1)
	}

	err = setIssueTitleAndBody(filePath)
	if err != nil {
		fmt.Fprintf(os.Stderr, "couldn't read issue's title and body: %v\n", err)
		os.Exit(1)
	}

	url := fmt.Sprintf(issuesURL, owner, repo)
	reqBody := createReqBody(issueTitle, issueBody)
	req, err := http.NewRequest("POST", url, reqBody)
	if err != nil {
		fmt.Fprintf(os.Stderr, "create new http request failed: %v\n", err)
		os.Exit(1)
	}
	req.Header.Add("Accept", "application/vnd.github.v3+json")
	addBasicAuth(req)

	res, err := http.DefaultClient.Do(req)
	if err != nil {
		fmt.Fprintf(os.Stderr, "create request failed: %v\n", err)
		os.Exit(1)
	}

	buf := bytes.NewBuffer(make([]byte, 0, res.ContentLength))
	buf.ReadFrom(res.Body)

	if res.StatusCode > 199 && res.StatusCode < 300 {
		parsedResponse := &createResp{}
		json.Unmarshal(buf.Bytes(), parsedResponse)
		fmt.Printf("Issue created successfully. Issue numer: %d\n",
			parsedResponse.IssueNum)
	} else {
		fmt.Println(string(buf.Bytes()))
	}
}

func createReqBody(title, body string) io.Reader {
	reqBody := fmt.Sprintf(`{"title": "%s", "body": "%s"}`, title, body)
	fmt.Println(reqBody)
	return strings.NewReader(reqBody)
}

func openEditor(filePath string) error {
	edVar := os.Getenv("EDITOR")
	if edVar == "" {
		return errors.New("EDITOR variable is not configured")

	}

	s := strings.SplitN(edVar, " ", -1)
	editor := s[0]
	args := []string{filePath}
	if len(s) > 1 {
		args = append(s[1:], args...)
	}

	cmd := exec.Command(editor, args...)
	cmd.Stdin = os.Stdin
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	err := cmd.Run()

	return err
}

func createAndWriteTemplateToInfoFile() (string, error) {
	usr, err := user.Current()
	if err != nil {
		return "", fmt.Errorf("creatInfoFile failed: %v", err)
	}

	programDir := usr.HomeDir + "/.gh-issue"
	_, err = os.Stat(programDir)
	if err != nil && !os.IsNotExist(err) {
		return "",
			fmt.Errorf("looking for gh-issue save directory failed: %v\n", err)
	}
	if os.IsNotExist(err) {
		err = os.Mkdir(programDir, 0755)
		if err != nil {
			return "",
				fmt.Errorf("creating gh-issue save directory failed: %v\n", err)
		}
	}

	filePath := programDir + "/" + infoFileName
	err = os.WriteFile(filePath, []byte(infoFileTemplate), 0755)
	if err != nil {
		rmErr := os.Remove(filePath)
		if rmErr != nil {
			err = fmt.Errorf("deleting template file failed: %v\n", err)
		}
		return "", fmt.Errorf("populating template text failed: %v\n", err)
	}

	return filePath, nil
}

func setIssueTitleAndBody(filePath string) error {
	b, err := ioutil.ReadFile(filePath)
	if err != nil {
		return fmt.Errorf("Can't read from file %s: %v", filePath, err)
	}

	scanner := bufio.NewScanner(bytes.NewBuffer(b))
	scanner.Split(bufio.ScanLines)
	for scanner.Scan() {
		line := scanner.Text()
		if strings.HasPrefix(line, "#") || line == "" {
			continue
		}
		issueTitle = line
		break
	}

	body := strings.Builder{}
	for scanner.Scan() {
		line := scanner.Text()
		if (strings.HasPrefix(line, "#") || line == "") &&
			body.Len() > 1 {
			break
		}
		if strings.HasPrefix(line, "#") || line == "" {
			continue
		}

		_, err = body.WriteString(line + "\\n")
		if err != nil {
			return fmt.Errorf("Could not write error to buffer: %v\n", err)
		}
	}
	issueBody = body.String()

	if issueTitle == "" {
		return errors.New("issue's title is empty")
	}

	return nil
}
