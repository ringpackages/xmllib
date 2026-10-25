/*
	XMLLib Demo 9 - Parse CDATA and comments
*/

load "xmllib.ring"

# -------------------------------------------------------
# Demo 9: Parse CDATA and comments
# -------------------------------------------------------
? "Demo 9: Parse comments and CDATA..."

cMixed = '<root>
  <!-- This is a comment -->
  <data>Hello</data>
  <script><![CDATA[x < 5 && y > 10]]></script>
</root>'

oRoot = xmlParse(cMixed)
if oRoot != NULL
	? "  Root children count: " + oRoot.childCount()

	oData = oRoot.child("data")
	if oData != NULL
		? "  Data text: " + oData.text()
	ok

	oScript = oRoot.child("script")
	if oScript != NULL
		? "  Script content: " + oScript.text()
	ok
ok
? ""
