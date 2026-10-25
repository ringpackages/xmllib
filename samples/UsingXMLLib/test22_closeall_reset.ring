/*
	XMLLib Demo 22 - closeAll and reset
*/

load "xmllib.ring"

# -------------------------------------------------------
# Demo 22: closeAll and reset
# -------------------------------------------------------
? "Demo 22: closeAll and reset..."

oXml = new XMLWriter
oXml.startElement("a")
oXml.startElement("b")
oXml.startElement("c")
oXml.addElement("d", "deep")
? "  Open elements: " + oXml.count()
oXml.closeAll()
? "  After closeAll: " + oXml.count()
? oXml.output()
? ""
