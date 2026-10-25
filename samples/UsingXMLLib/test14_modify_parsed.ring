/*
	XMLLib Demo 14 - Modify parsed XML
*/

load "xmllib.ring"

# -------------------------------------------------------
# Demo 14: Modify parsed XML
# -------------------------------------------------------
? "Demo 14: Modify parsed XML..."

cXml2 = '<settings>
  <theme>light</theme>
  <language>en</language>
  <fontSize>14</fontSize>
</settings>'

oRoot = xmlParse(cXml2)
if oRoot != NULL
	? "  Before modification:"
	? "    Theme: " + oRoot.child("theme").text()
	? "    Language: " + oRoot.child("language").text()

	# Modify values
	oRoot.child("theme").setText("dark")
	oRoot.child("language").setText("ar")

	# Add new element
	oNew = new XMLNode
	oNew.nType = XML_ELEMENT
	oNew.cTag = "showLineNumbers"
	oNew.setText("true")
	oRoot.addChild(oNew)

	# Add attribute to root
	oRoot.setAttr("version", "2.0")

	? ""
	? "  After modification:"
	? "    Theme: " + oRoot.child("theme").text()
	? "    Language: " + oRoot.child("language").text()
	? "    New setting: " + oRoot.child("showLineNumbers").text()
	? "    Version attr: " + oRoot.attr("version")

	? ""
	? "  Modified XML:"
	? oRoot.toXml()
ok
? ""
