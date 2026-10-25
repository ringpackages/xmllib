/*
	XMLLib Demo 15 - Pretty print and compact output
*/

load "xmllib.ring"

# -------------------------------------------------------
# Demo 15: Pretty print and compact output
# -------------------------------------------------------
? "Demo 15: Pretty vs. compact output..."

oXml = new XMLWriter
oXml.startElement("root")
oXml.addElement("a", "1")
oXml.addElement("b", "2")
oXml.startElement("c")
oXml.addElement("d", "3")
oXml.endElement()
oXml.endElement()

? "  Pretty printed:"
? oXml.output()

# Compact output
oXml2 = new XMLWriter
oXml2.setPrettyPrint(false)
oXml2.startElement("root")
oXml2.addElement("a", "1")
oXml2.addElement("b", "2")
oXml2.startElement("c")
oXml2.addElement("d", "3")
oXml2.endElement()
oXml2.endElement()

? "  Compact:"
? oXml2.output()
? ""
