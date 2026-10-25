/*
	XMLLib Demo 11 - Empty elements and self-closing tags
*/

load "xmllib.ring"

# -------------------------------------------------------
# Demo 11: Empty elements and self-closing tags
# -------------------------------------------------------
? "Demo 11: Empty and self-closing elements..."

oXml = new XMLWriter
oXml.startElement("form")
oXml.addEmptyElementAttrs("input", [["type", "text"], ["name", "email"], ["required", "true"]])
oXml.addEmptyElement("br")
oXml.addEmptyElementAttrs("input", [["type", "submit"], ["value", "Send"]])
oXml.endElement()

? oXml.output()
? ""
