// XML Encoding: Since XML is very verbose you are given a way of encoding it
// where each tag gets mapped to a pred-defined integer value. The
// language/grammer is as follows:
//
// Element   --> Tag Attributes END Children END
// Attribute --> Tag Value
// END       --> 0
// Tag       --> some predefined mapping to int
// Value     --> string value
// Children  --> Element or Value
//
// EXAMPLE:
// <family lastName="McDowell" state="CA">
//   <person firstName="Gayle">Some Message</person>
// </family>
//
// Becomes:
// 1 4 McDowell 5 CA 0 2 3 Gayle 0 Some Message 0 0
//
// Write code to print the encoded version of an XML element (passed in Element
// and Attribute objects)

package main

import (
	"fmt"
	"os"
	"strconv"
	"strings"
	"unicode"
	"unicode/utf8"
)

func main() {
	doc := `<family lastName="McDowell" state="CA">
  <person firstName="Gayle"> Some Message</person>
</family>`

	mapping := map[string]int{
		"family":    1,
		"person":    2,
		"firstName": 3,
		"lastName":  4,
		"state":     5,
	}

	str, err := encodeXML(doc, mapping)
	if err != nil {
		fmt.Printf("err := %v\n", err)
		os.Exit(1)
	}

	fmt.Println(str)
}

func encodeXML(value string, mapping map[string]int) (string, error) {
	l := newLexer(value)
	go l.lex()

	result := strings.Builder{}
	var i int
	for item := range l.items {
		var s string

		switch item.typ {
		case itemStartElement:
			s = strconv.Itoa(mapping[item.val])
		case itemEndElement, itemEndOfStartElement:
			s = "0"
		case itemValue:
			s = item.val
		case itemAttribute:
			attr := strings.Split(item.val, "=")
			key := strconv.Itoa(mapping[attr[0]])
			val := strings.Trim(attr[1], "\"'")

			s = key + " " + val
		}

		if i == 1 {
			_, _ = result.WriteString(" ")
		}

		_, _ = result.WriteString(s)
		i = 1
	}

	return result.String(), nil
}

type itemType int

func (i itemType) String() string {
	switch i {
	case itemStartElement:
		return "Element"
	case itemEndElement:
		return "Close Element"
	case itemValue:
		return "Value"
	case itemAttribute:
		return "Attribute"
	case itemErr:
		return "Error"
	case itemEndOfStartElement:
		return "GreaterThanSign"
	default:
		return fmt.Sprintf("unknown item type: %d", i)
	}
}

const (
	itemStartElement itemType = iota
	itemEndOfStartElement
	itemEndElement
	itemAttribute
	itemValue
	// TODO: Define helpful err messages
	itemErr

	eof rune = -1
)

type item struct {
	typ itemType
	val string
}

// TODO: Ignore multiple spaces/newlines
type lexer struct {
	text  string
	width int
	start int
	pos   int
	items chan item
}

func newLexer(text string) *lexer {
	return &lexer{
		text:  text,
		items: make(chan item),
	}
}

func (l *lexer) emit(typ itemType) {
	l.items <- item{
		typ: typ,
		val: l.text[l.start:l.pos],
	}
	l.start = l.pos

	if typ == itemErr {
		close(l.items)
	}
}

func (l *lexer) peek() rune {
	r := l.next()
	if r != eof {
		l.backup()
	}

	return r
}

func (l *lexer) backup() {
	l.pos -= l.width
}

func (l *lexer) next() rune {
	if l.pos >= len(l.text) {
		l.width = 0
		return eof
	}

	r, size := utf8.DecodeRuneInString(l.text[l.pos:])
	if r == utf8.RuneError {
		l.emit(itemErr)
		return r
	}

	l.pos += size
	l.width = size
	return r
}

func (l *lexer) consumeWhiteSpaces() {
	for unicode.IsSpace(l.peek()) {
		l.next()
	}

	l.start = l.pos
}

type stateFn func(l *lexer) stateFn

// Initiate the lexing process
func (l *lexer) lex() {
	l.consumeWhiteSpaces()
	for state := lexLessThanSign(l); state != nil; {
		state = state(l)
	}
}

func lexLessThanSign(l *lexer) stateFn {
	r := l.next()
	if r != '<' {
		l.emit(itemErr)
		return nil
	}

	l.start = l.pos
	return lexStartElement
}

func lexGreaterThanSign(l *lexer) stateFn {
	l.start = l.pos
	r := l.next()
	if r != '>' {
		l.emit(itemErr)
		return nil
	} else {
		l.emit(itemEndOfStartElement)
	}

	closeIdx := strings.Index(l.text[l.pos:], "</")
	openIdx := strings.Index(l.text[l.pos:], "<")
	if openIdx < closeIdx {
		l.consumeWhiteSpaces()
		return lexLessThanSign
	}

	return lexInsideElement
}

func lexStartElement(l *lexer) stateFn {
	for unicode.IsLetter(l.peek()) {
		l.next()
	}

	l.emit(itemStartElement)

	l.consumeWhiteSpaces()
	r := l.peek()
	if unicode.IsLetter(r) {
		return lexAttributes
	}

	return lexGreaterThanSign
}

func lexAttributes(l *lexer) stateFn {
	l.consumeWhiteSpaces()
	for l.peek() != '>' {
		eqIdx := strings.IndexRune(l.text[l.pos:], '=')
		if eqIdx == -1 {
			l.emit(itemErr)
			return nil
		}
		l.pos += eqIdx + 1
		// TODO: check for out of range
		quote := l.next()
		if quote != '\'' && quote != '"' {
			l.emit(itemErr)
			return nil
		}

		nextQuoteIdx := strings.IndexRune(l.text[l.pos:], quote)
		l.pos = l.pos + nextQuoteIdx + 1
		l.emit(itemAttribute)

		l.consumeWhiteSpaces()
	}

	return lexGreaterThanSign
}

func lexInsideElement(l *lexer) stateFn {
	idx := strings.Index(l.text[l.pos:], "</")
	if idx == -1 {
		l.emit(itemErr)
		return nil
	}
	l.start = l.pos
	l.pos = l.start + idx
	l.emit(itemValue)

	// skip / in </
	l.start = l.pos + 2
	l.pos = l.start
	return insideEndElement
}

func insideEndElement(l *lexer) stateFn {
	idx := strings.IndexRune(l.text[l.pos:], '>')
	if idx == -1 {
		l.emit(itemErr)
		return nil
	}

	l.pos += idx
	l.emit(itemEndElement)

	l.next()
	l.start = l.pos
	l.consumeWhiteSpaces()

	// open xml element or closing another one is expected
	r := l.next()
	if r == eof {
		close(l.items)
		return nil
	}
	if r != '<' {
		l.emit(itemErr)
		return nil
	}
	if l.peek() == '/' {
		l.next()
		l.start = l.pos
		return insideEndElement
	}

	l.start = l.pos
	return lexStartElement
}
