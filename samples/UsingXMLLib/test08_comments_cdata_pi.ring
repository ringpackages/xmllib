/*
	XMLLib Demo 8 - Comments, CDATA, Processing Instructions
*/

load "xmllib.ring"

# -------------------------------------------------------
# Demo 8: Comments, CDATA, Processing Instructions
# -------------------------------------------------------
? "Demo 8: Comments, CDATA, PI..."

oXml = new XMLWriter
oXml.addDeclaration()
oXml.addPI("xml-stylesheet", 'type="text/xsl" href="transform.xsl"')
oXml.addComment("This is a configuration file")
oXml.startElement("config")
oXml.addComment("Database settings")
oXml.addElement("host", "localhost")
oXml.addElement("port", "3306")
oXml.addComment("Script content uses CDATA")
oXml.startElement("script")
oXml.addCDATA('if (x < 5 && y > 10) { alert("OK"); }')
oXml.endElement()
oXml.endElement()

? oXml.output()
? ""
