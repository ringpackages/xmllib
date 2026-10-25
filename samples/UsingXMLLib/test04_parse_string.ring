/*
	XMLLib Demo 4 - Parse XML string
*/

load "xmllib.ring"

# -------------------------------------------------------
# Demo 4: Parse XML string
# -------------------------------------------------------
? "Demo 4: Parsing XML string..."

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
	? "  Root tag: " + oRoot.tag()
	? "  Number of products: " + oRoot.elementCount()
	? ""

	# Iterate products
	aProducts = oRoot.children("product")
	for oProduct in aProducts
		? "  Product: " + oProduct.child("name").text()
		? "    ID: " + oProduct.attr("id")
		? "    Category: " + oProduct.attr("category")
		? "    Price: $" + oProduct.child("price").text()
		? "    In Stock: " + oProduct.child("inStock").text()
	next
ok
? ""
