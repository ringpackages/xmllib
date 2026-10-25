/*
	XMLLib Demo 7 - XPath-like queries
*/

load "xmllib.ring"

# -------------------------------------------------------
# Demo 7: XPath-like queries
# -------------------------------------------------------
? "Demo 7: XPath-like queries..."

cXmlData = '<catalog>
  <product id="P001" category="electronics">
    <name>Laptop</name>
    <price>999.99</price>
    <inStock>true</inStock>
  </product>
  <product id="P002" category="books">
    <name>Ring Programming</name>
    <price>29.99</price>
    <inStock>true</inStock>
  </product>
  <product id="P003" category="electronics">
    <name>Mouse</name>
    <price>19.99</price>
    <inStock>false</inStock>
  </product>
</catalog>'

oRoot = xmlParse(cXmlData)
if oRoot != NULL
	# Path query
	aBooks = oRoot.xpath("product")
	if isList(aBooks)
		? "  product: found " + len(aBooks) + " items"
	ok

	# Attribute filter
	aElectronics = oRoot.xpath("product[@category='electronics']")
	if isList(aElectronics)
		? "  Electronics products: " + len(aElectronics)
		for oProd in aElectronics
			? "    - " + oProd.child("name").text()
		next
	ok

	# Deep search with //
	aNames = oRoot.xpath("//name")
	if isList(aNames)
		? "  All names (deep): " + len(aNames)
		for oName in aNames
			? "    - " + oName.text()
		next
	ok
ok
? ""
