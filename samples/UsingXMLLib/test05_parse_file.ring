/*
	XMLLib Demo 5 - Parse and navigate XML file
*/

load "xmllib.ring"

# -------------------------------------------------------
# Demo 5: Parse and navigate XML file
# -------------------------------------------------------
? "Demo 5: Parse XML file..."

# Create the XML file to parse
cLibraryXml = '<?xml version="1.0" encoding="UTF-8"?>
<library>
  <book id="1" lang="en">
    <title>Ring Programming Guide</title>
    <author>Adam</author>
    <year>2026</year>
    <price currency="USD">29.99</price>
  </book>
  <book id="2" lang="ar">
    <title>Learn Ring in Arabic</title>
    <author>Ring Team</author>
    <year>2026</year>
    <price currency="EGP">19.99</price>
  </book>
</library>'
write("demo5_library.xml", cLibraryXml)

oRoot = xmlParseFile("demo5_library.xml")
if oRoot != NULL
	? "  Loaded library with " + oRoot.elementCount() + " books"

	aBooks = oRoot.children("book")
	for oBook in aBooks
		? "  Book #" + oBook.attr("id") + ": " + oBook.child("title").text()
		? "    Author: " + oBook.child("author").text()
	next
ok
? ""
