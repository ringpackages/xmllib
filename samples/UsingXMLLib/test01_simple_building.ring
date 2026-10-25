/*
	XMLLib Demo 1 - Simple element building
*/

load "xmllib.ring"

# -------------------------------------------------------
# Demo 1: Simple element building
# -------------------------------------------------------
? "Demo 1: Simple XML building..."

oXml = new XMLWriter
oXml.addDeclaration()
oXml.startElement("greeting")
oXml.addElement("message", "Hello World!")
oXml.addElement("language", "Ring")
oXml.endElement()

? oXml.output()
? ""
