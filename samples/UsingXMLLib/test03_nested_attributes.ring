/*
	XMLLib Demo 3 - Nested elements with attributes
*/

load "xmllib.ring"

# -------------------------------------------------------
# Demo 3: Nested elements with attributes
# -------------------------------------------------------
? "Demo 3: Nested elements with attributes..."

oXml = new XMLWriter
oXml.addDeclaration()
oXml.startElement("library")

# Book 1
oXml.startElementAttrs("book", [["id", "1"], ["lang", "en"]])
oXml.addElement("title", "Ring Programming Guide")
oXml.addElement("author", "Adam")
oXml.addElement("year", "2026")
oXml.addElementAttrs("price", "29.99", [["currency", "USD"]])
oXml.endElement()

# Book 2
oXml.startElementAttrs("book", [["id", "2"], ["lang", "ar"]])
oXml.addElement("title", "Learn Ring in Arabic")
oXml.addElement("author", "Ring Team")
oXml.addElement("year", "2026")
oXml.addElementAttrs("price", "19.99", [["currency", "EGP"]])
oXml.endElement()

oXml.endElement()

? oXml.output()

if oXml.save("demo3_library.xml")
	? "  Saved to: demo3_library.xml"
ok
? ""
