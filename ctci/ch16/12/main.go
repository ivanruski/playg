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
	"errors"
	"fmt"
	"io"
	"strconv"
	"strings"
	"unicode"
)

func main() {
	doc := `<note>
	  <to>Tove</to>
	  <from>Jani</from>
	  <heading>Reminder</heading>
	  <body>Don't forget me this weekend!</body>
	</note>`

	mapping := map[string]int{
		"family":    1,
		"person":    2,
		"firstName": 3,
		"lastName":  4,
		"state":     5,
	}

	val, err := encodeXML(doc, mapping)
	if err != nil {
		fmt.Printf("err: %s\n", err)
	}

	fmt.Printf("encoded: %s\n", val)
}

var (
	XMLStartElement    = "<"
	XMLStartEndElement = "</"
	XMLEndElement      = ">"
	EqualSign          = "="
	Slash              = "/"
	Quote              = "\""
)

func encodeXML(value string, mapping map[string]int) (string, error) {
	// parse element
	// parse value

	sr := strings.NewReader(value)
	sb := &strings.Builder{}

	err := encode(sr, sb, mapping)
	if errors.Is(err, io.EOF) {
		return sb.String(), nil
	}
	if err != nil {
		return "", err
	}

	return sb.String(), nil
}

func encode(sr *strings.Reader, sb *strings.Builder, mapping map[string]int) error {
	r, _, err := sr.ReadRune()
	if err != nil {
		return fmt.Errorf("ReadRune: %w", err)
	}

	if unicode.IsSpace(r) {
		return encode(sr, sb, mapping)
	}

	if string(r) == XMLStartElement {
		r, _, err := sr.ReadRune()
		if err != nil {
			return fmt.Errorf("ReadRune: %w", err)
		}

		if string(r) == Slash {
			err := exhaustEndElement(sr)
			if err != nil {
				return fmt.Errorf("exhaustEndElement: %w", err)
			}

			_, err = sb.WriteString("0")
			if err != nil {
				return fmt.Errorf("writing %q: %w", " 0", err)
			}

			// TODO: If traling space available we'll append " " to the end of the element
			_, _, err = sr.ReadRune()
			if errors.Is(err, io.EOF) {
				return nil
			} else {
				err := sr.UnreadRune()
				if err != nil {
					return fmt.Errorf("UnreadRune: %w", err)
				}
				_, err = sb.WriteString(" ")
				if err != nil {
					return fmt.Errorf("writing %q: %w", " 0", err)
				}
			}

		} else {
			err := sr.UnreadRune()
			if err != nil {
				return fmt.Errorf("UnreadRune: %w", err)
			}

			el, hasAttrs, err := parseStartElement(sr)
			if err != nil {
				return fmt.Errorf("parseStartElement: %w", err)
			}

			_, err = sb.WriteString(strconv.Itoa(mapping[el]))
			if err != nil {
				return fmt.Errorf("writing %q: %w", el, err)
			}

			for hasAttrs {
				tag, value, attrs, err := parseAttribute(sr)
				if err != nil {
					return fmt.Errorf("parsing attribute: %w", err)
				}

				_, err = sb.WriteString(" " + strconv.Itoa(mapping[tag]) + " " + value)
				if err != nil {
					return fmt.Errorf("writing %q: %w", tag+" "+value, err)
				}

				hasAttrs = attrs
			}

			_, err = sb.WriteString(" 0 ")
			if err != nil {
				return fmt.Errorf("writing %q: %w", " 0", err)
			}
		}
	} else {
		err := sr.UnreadRune()
		if err != nil {
			return fmt.Errorf("UnreadRune: %w", err)
		}

		value, err := parseValue(sr)
		if err != nil {
			return fmt.Errorf("parsing value: %w", err)
		}

		_, err = sb.WriteString(value + " 0 ")
		if err != nil {
			return fmt.Errorf("writing %q: %w", value+" 0", err)
		}

		err = exhaustEndElement(sr)
		if err != nil {
			return fmt.Errorf("exhaustEndElement: %w", err)
		}
	}

	return encode(sr, sb, mapping)
}

func parseValue(sr *strings.Reader) (string, error) {
	value := strings.Builder{}

	for {
		r, _, err := sr.ReadRune()
		if err != nil {
			return "", err
		}

		if string(r) == XMLStartElement {
			r, _, err := sr.ReadRune()
			if err != nil {
				return "", err
			}
			if string(r) == Slash {
				break
			}

			err = sr.UnreadRune()
			if err != nil {
				return "", err
			}
		}

		_, err = value.WriteRune(r)
		if err != nil {
			return "", err
		}
	}

	return value.String(), nil
}

func parseAttribute(sr *strings.Reader) (string, string, bool, error) {
	var tag, value = strings.Builder{}, strings.Builder{}
	var hasAttrs bool

	for {
		r, _, err := sr.ReadRune()
		if err != nil {
			return "", "", false, err
		}

		if string(r) == EqualSign {
			break
		}

		_, err = tag.WriteRune(r)
		if err != nil {
			return "", "", false, err
		}
	}

	for {
		r, _, err := sr.ReadRune()
		if err != nil {
			return "", "", false, err
		}

		if string(r) == Quote {
			continue
		}

		if string(r) == XMLEndElement {
			break
		}
		if unicode.IsSpace(r) {
			hasAttrs = true
			break
		}

		_, err = value.WriteRune(r)
		if err != nil {
			return "", "", false, err
		}
	}

	return tag.String(), value.String(), hasAttrs, nil
}

func parseStartElement(sr *strings.Reader) (string, bool, error) {
	sb := strings.Builder{}
	var hasAttrs bool
	for {
		r, _, err := sr.ReadRune()
		if err != nil {
			return "", false, err
		}

		// start element could have attributes
		if unicode.IsSpace(r) {
			hasAttrs = true
			break
		}
		if string(r) == XMLEndElement {
			break
		}

		_, err = sb.WriteRune(r)
		if err != nil {
			return "", false, err
		}
	}

	return sb.String(), hasAttrs, nil
}

func exhaustEndElement(sr *strings.Reader) error {
	for {
		r, _, err := sr.ReadRune()
		if err != nil {
			return err
		}

		if string(r) == XMLEndElement {
			break
		}
	}

	return nil
}
