package main

import "testing"

func TestEncodeXML(t *testing.T) {
	tests := map[string]struct {
		doc     string
		mapping map[string]int
		want    string
	}{
		"Test1": {
			doc: `
<family lastName="McDowell" state="CA">
  <person firstName="Gayle">Some Message</person>
</family>`,
			mapping: map[string]int{
				"family":    1,
				"person":    2,
				"firstName": 3,
				"lastName":  4,
				"state":     5,
			},
			want: "1 4 McDowell 5 CA 0 2 3 Gayle 0 Some Message 0 0",
		},
		"Test2": {
			doc: `
<note>
  <to>Tove</to>
  <from>Jani</from>
  <heading>Reminder</heading>
  <body>Don't forget me this weekend!</body>
</note>`,
			mapping: map[string]int{
				"note":    1,
				"to":      2,
				"from":    3,
				"heading": 4,
				"body":    5,
			},
			want: "1 0 2 0 Tove 0 3 0 Jani 0 4 0 Reminder 0 5 0 Don't forget me this weekend! 0 0",
		},
		"Test3": {
			doc: `
<bookstore>
  <book category="children">
    <title>Harry Potter</title>
    <author>J K. Rowling</author>
    <year>2005</year>
    <price currency="USD">29.99</price>
  </book>
  <book category="web">
    <title>Learning XML</title>
    <author>Erik T. Ray</author>
    <year>2003</year>
    <price currency="EUR">39.95</price>
  </book>
</bookstore>`,
			mapping: map[string]int{
				"bookstore": 1,
				"book":      2,
				"category":  3,
				"title":     4,
				"author":    5,
				"year":      6,
				"price":     7,
				"currency":  8,
			},
			want: "1 0 2 3 children 0 4 0 Harry Potter 0 5 0 J K. Rowling 0 6 0 2005 0 7 8 USD 0 29.99 0 0 2 3 web 0 4 0 Learning XML 0 5 0 Erik T. Ray 0 6 0 2003 0 7 8 EUR 0 39.95 0 0 0",
		},
	}

	for name, test := range tests {
		t.Run(name, func(t *testing.T) {
			got, err := encodeXML(test.doc, test.mapping)
			if err != nil {
				t.Fatalf("unexpected err: %s", err)
			}

			if got != test.want {
				t.Fatalf("\ngot:  %s\nwant: %s", got, test.want)
			}
		})
	}
}
