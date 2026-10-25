/*
	XMLLib Demo 19 - RSS Feed building
*/

load "xmllib.ring"

# -------------------------------------------------------
# Demo 19: RSS Feed building
# -------------------------------------------------------
? "Demo 19: Building RSS Feed..."

oXml = new XMLWriter
oXml.addDeclaration()
oXml.startElementAttrs("rss", [["version", "2.0"]])
oXml.startElement("channel")
oXml.addElement("title", "Ring Language News")
oXml.addElement("link", "https://ring-lang.net")
oXml.addElement("description", "Latest updates from the Ring programming language")

# Add items
aNews = [
	["RingZipLib Released", "A new pure Ring library for ZIP archives", "2026-02-04"],
	["RingXMLLib Released", "XML builder and parser for Ring", "2026-02-04"],
	["Ring 1.28 Update", "New features and improvements", "2026-01-15"]
]

for aItem in aNews
	oXml.startElement("item")
	oXml.addElement("title", aItem[1])
	oXml.addElement("description", aItem[2])
	oXml.addElement("pubDate", aItem[3])
	oXml.endElement()
next

oXml.endElement()
oXml.endElement()

if oXml.save("demo19_rss.xml")
	? "  Created: demo19_rss.xml"
ok
? oXml.output()
? ""
