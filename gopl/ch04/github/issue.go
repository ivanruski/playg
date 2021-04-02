package github

import (
	"time"
)

var (
	now      = time.Now().UTC().Add(-time.Hour * 24 * 30)
	monthAgo = lastMonth(now)
	yearAgo  = lastYear(now)
)

func lastYear(t time.Time) time.Time {
	return time.Date(
		now.Year()-1,
		now.Month(),
		now.Day(),
		now.Hour(),
		now.Minute(),
		now.Second(),
		now.Nanosecond(),
		time.UTC)
}

func lastMonth(t time.Time) time.Time {
	year := t.Year()
	month := t.Month()
	if month == time.January {
		year = t.Year() - 1
		month = time.December
	} else {
		month = month - 1
	}

	return time.Date(
		year,
		month,
		now.Day(),
		now.Hour(),
		now.Minute(),
		now.Second(),
		now.Nanosecond(),
		time.UTC)
}	

func IssuesFromLessThanAMonth(issues []*Issue) []*Issue {
	s := make([]*Issue, 0)
	for _, issue := range issues {
		if issue.CreatedAt.After(monthAgo) {
			s = append(s, issue)
		}
	}

	return s
}

// Returns all issues created in the past year except for
// those that were created in the last month.
// See IssuesFromLessThanAMonth for issues from the past month.
func IssuesFromPastYear(issues []*Issue) []*Issue {
	s := make([]*Issue, 0)
	for _, issue := range issues {
		if issue.CreatedAt.After(yearAgo) && issue.CreatedAt.Before(monthAgo) {
			s = append(s, issue)
		}
	}

	return s
}

func IssuesOlderThanAYear(issues []*Issue) []*Issue {
	s := make([]*Issue, 0)
	for _, issue := range issues {
		if issue.CreatedAt.Before(yearAgo) {
			s = append(s, issue)
		}
	}

	return s
}
