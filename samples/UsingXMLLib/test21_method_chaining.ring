/*
	XMLLib Demo 21 - Fluent / method chaining
*/

load "xmllib.ring"

# -------------------------------------------------------
# Demo 21: Fluent / method chaining
# -------------------------------------------------------
? "Demo 21: Method chaining..."

oXml = new XMLWriter
oXml.setPrettyPrint(true) {
	addDeclaration()
	startElement("note")
	addElement("to", "Ring Community")
	addElement("from", "RingXMLLib")
	addElement("subject", "Method Chaining Works!")
	addElement("body", "This XML was built using fluent method chaining.")
	endElement()
}

? oXml.output()
? ""
