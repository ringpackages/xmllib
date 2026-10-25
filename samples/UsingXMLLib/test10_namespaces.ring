/*
	XMLLib Demo 10 - XML Namespaces
*/

load "xmllib.ring"

# -------------------------------------------------------
# Demo 10: XML Namespaces
# -------------------------------------------------------
? "Demo 10: Namespaces..."

oXml = new XMLWriter
oXml.addDeclaration()
oXml.startElementNS("soap", "Envelope", "http://schemas.xmlsoap.org/soap/envelope/")
oXml.startElement("soap:Header")
oXml.addElement("auth:Token", "ABC123")
oXml.endElement()
oXml.startElement("soap:Body")
oXml.startElement("m:GetPrice")
oXml.addElement("m:Item", "Ring Programming Book")
oXml.endElement()
oXml.endElement()
oXml.endElement()

? oXml.output()
? ""
