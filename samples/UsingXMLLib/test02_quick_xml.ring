/*
	XMLLib Demo 2 - Quick XML creation
*/

load "xmllib.ring"

# -------------------------------------------------------
# Demo 2: Quick XML creation
# -------------------------------------------------------
? "Demo 2: Quick XML..."

cXml = quickXML("person", [
	["name", "Adam"],
	["age", "30"],
	["city", "Cairo"],
	["language", "Ring"]
])
? cXml
? ""
