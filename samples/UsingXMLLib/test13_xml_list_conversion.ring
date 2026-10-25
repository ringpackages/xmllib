/*
	XMLLib Demo 13 - XML to Ring list and back
*/

load "xmllib.ring"

# -------------------------------------------------------
# Demo 13: XML to Ring list and back
# -------------------------------------------------------
? "Demo 13: XML <-> Ring list conversion..."

cOriginal = '<order id="1001">
  <customer>Ring Developer</customer>
  <items>
    <item>Keyboard</item>
    <item>Mouse</item>
  </items>
  <total>149.99</total>
</order>'

# Convert to Ring list
aData = xmlToList(cOriginal)
? "  Tag: " + aData[:tag]
? "  Attributes: " + aData[:attrs][1][1] + " = " + aData[:attrs][1][2]
? "  Children count: " + len(aData[:children])

# Convert back to XML
cRebuilt = listToXML(aData)
? "  Rebuilt XML: " + cRebuilt
? ""
