/*
	XMLLib Demo 12 - Build from Ring lists
*/

load "xmllib.ring"

# -------------------------------------------------------
# Demo 12: Build from Ring lists
# -------------------------------------------------------
? "Demo 12: Build from Ring lists..."

oXml = new XMLWriter
oXml.addDeclaration()

# Build person from list
oXml.addFromList("person", [
	["name", "Adam"],
	["email", "adam@example.com"],
	["phone", "+20-123-456-7890"]
])

? oXml.output()
? ""

# Multiple items with same tag
oXml2 = new XMLWriter
oXml2.startElement("fruits")
oXml2.addListAsElements("fruit", ["Apple", "Banana", "Cherry", "Date"])
oXml2.endElement()

? oXml2.output()
? ""
