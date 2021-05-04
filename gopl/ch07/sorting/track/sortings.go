package track

import "sort"

// ByTitle

func ByTitle(tracks Tracks) sort.Interface {
	sorter := byTitle(tracks)

	return sorter
}

type byTitle []*Track

func (bt byTitle) Len() int {
	return len(bt)
}

func (bt byTitle) Less(i, j int) bool {
	return bt[i].Title < bt[j].Title
}

func (bt byTitle) Swap(i, j int) {
	bt[i], bt[j] = bt[j], bt[i]
}

// end ByTitle

// ByArtist

func ByArtist(tracks Tracks) sort.Interface {
	sorter := byArtist(tracks)

	return sorter
}

type byArtist []*Track

func (ba byArtist) Len() int {
	return len(ba)
}

func (ba byArtist) Less(i, j int) bool {
	return ba[i].Artist < ba[j].Artist
}

func (ba byArtist) Swap(i, j int) {
	ba[i], ba[j] = ba[j], ba[i]
}

// end ByArtist

// multicolumn sorter

// Rules importance is based on when they were added to the sorter
// First rule is executed first, then the second and so on...
type MultiColumnSorter struct {
	rules  []sort.Interface
	tracks Tracks
}

func NewMultiColumnSorter(tracks Tracks, rules ...func(Tracks) sort.Interface) *MultiColumnSorter {
	m := &MultiColumnSorter{tracks: tracks}

	for _, rule := range rules {
		m.rules = append(m.rules, rule(tracks))
	}

	return m
}

func (m *MultiColumnSorter) Len() int {
	return len(m.tracks)
}

func (m *MultiColumnSorter) Less(i, j int) bool {
	for _, rule := range m.rules {
		if rule.Less(i, j) {
			return true
		}
		if rule.Less(j, i) {
			return false
		}
	}

	return false

}

func (m *MultiColumnSorter) Swap(i, j int) {
	m.tracks[i], m.tracks[j] = m.tracks[j], m.tracks[i]
}
