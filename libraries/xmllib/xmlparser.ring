class XMLParser

	func parseString cXml
		return xParse(cXml)

	func parseFile cFileName
		if !fexists(cFileName)
			? "RingXMLLib Error: File not found: " + cFileName
			return NULL
		ok
		return parseString(read(cFileName))
