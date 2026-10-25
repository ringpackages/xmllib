class XMLWriter

	aParts = []
	aStack = []
	cIndent = "  "
	nLevel = 0
	lPretty = true
	aIndCache = []
	nIndCacheSize = 0
	cVersion = "1.0"
	cEncoding = "UTF-8"
	lStandalone = false
	lDeclAdded = false
	cNL = nl

	func initCache
		if nIndCacheSize > 0 return ok
		aIndCache = [""]
		cAcc = ""
		for nCache = 1 to 15
			cAcc += cIndent
			aIndCache + cAcc
		next
		nIndCacheSize = 16

	func setIndent cNewIndent
		cIndent = cNewIndent
		nIndCacheSize = 0
		initCache()
		return self

	func setPrettyPrint lFlag
		lPretty = lFlag
		return self

	func setVersion cVer
		cVersion = cVer
		return self

	func setEncoding cEnc
		cEncoding = cEnc
		return self

	func setStandalone lFlag
		lStandalone = lFlag
		return self

	func addDeclaration
		cDecl = '<?xml version="' + cVersion + '" encoding="' + cEncoding + '"'
		if lStandalone cDecl += ' standalone="yes"' ok
		cDecl += '?>'
		if lPretty cDecl += cNL ok
		aParts + cDecl
		lDeclAdded = true
		return self

	func addPI cTarget, cPIData
		addIndent()
		aParts + ('<?' + cTarget + ' ' + cPIData + '?>')
		if lPretty aParts + cNL ok
		return self

	func startElement cTag
		addIndent()
		aParts + ('<' + cTag + '>')
		if lPretty aParts + cNL ok
		aStack + cTag
		nLevel += 1
		return self

	func startElementAttrs cTag, aAttrs
		addIndent()
		cLine = '<' + cTag
		nAttrLen = len(aAttrs)
		for nAttr = 1 to nAttrLen
			if isList(aAttrs[nAttr]) and len(aAttrs[nAttr]) >= 2
				cLine += ' ' + aAttrs[nAttr][1] + '="' + xmlEscape("" + aAttrs[nAttr][2]) + '"'
			ok
		next
		cLine += '>'
		if lPretty cLine += cNL ok
		aParts + cLine
		aStack + cTag
		nLevel += 1
		return self

	func endElement
		nStackLen = len(aStack)
		if nStackLen = 0
			? "RingXMLLib Warning: No open element to close"
			return self
		ok
		nLevel -= 1
		cTag = aStack[nStackLen]
		del(aStack, nStackLen)
		addIndent()
		cLine = '</' + cTag + '>'
		if lPretty cLine += cNL ok
		aParts + cLine
		return self

	func addElement cTag, cText
		addIndent()
		cLine = '<' + cTag + '>' + xmlEscape("" + cText) + '</' + cTag + '>'
		if lPretty cLine += cNL ok
		aParts + cLine
		return self

	func addElementAttrs cTag, cText, aAttrs
		addIndent()
		cLine = '<' + cTag
		nAttrLen = len(aAttrs)
		for nAttr = 1 to nAttrLen
			if isList(aAttrs[nAttr]) and len(aAttrs[nAttr]) >= 2
				cLine += ' ' + aAttrs[nAttr][1] + '="' + xmlEscape("" + aAttrs[nAttr][2]) + '"'
			ok
		next
		cLine += '>' + xmlEscape("" + cText) + '</' + cTag + '>'
		if lPretty cLine += cNL ok
		aParts + cLine
		return self

	func addEmptyElement cTag
		addIndent()
		cLine = '<' + cTag + '/>'
		if lPretty cLine += cNL ok
		aParts + cLine
		return self

	func addEmptyElementAttrs cTag, aAttrs
		addIndent()
		cLine = '<' + cTag
		nAttrLen = len(aAttrs)
		for nAttr = 1 to nAttrLen
			if isList(aAttrs[nAttr]) and len(aAttrs[nAttr]) >= 2
				cLine += ' ' + aAttrs[nAttr][1] + '="' + xmlEscape("" + aAttrs[nAttr][2]) + '"'
			ok
		next
		cLine += '/>'
		if lPretty cLine += cNL ok
		aParts + cLine
		return self

	func addRawElement cTag, cRawContent
		addIndent()
		cLine = '<' + cTag + '>' + cRawContent + '</' + cTag + '>'
		if lPretty cLine += cNL ok
		aParts + cLine
		return self

	func addText cText
		addIndent()
		cLine = xmlEscape("" + cText)
		if lPretty cLine += cNL ok
		aParts + cLine
		return self

	func addRawText cText
		aParts + cText
		return self

	func addComment cText
		addIndent()
		cLine = '<!-- ' + cText + ' -->'
		if lPretty cLine += cNL ok
		aParts + cLine
		return self

	func addCDATA cText
		addIndent()
		cLine = '<![CDATA[' + cText + ']]>'
		if lPretty cLine += cNL ok
		aParts + cLine
		return self

	func startElementNS cPrefix, cLocalName, cNSURI
		cFullTag = cPrefix + ":" + cLocalName
		addIndent()
		cLine = '<' + cFullTag + ' xmlns:' + cPrefix + '="' + cNSURI + '">'
		if lPretty cLine += cNL ok
		aParts + cLine
		aStack + cFullTag
		nLevel += 1
		return self

	func addElementNS cPrefix, cLocalName, cText
		cFullTag = cPrefix + ':' + cLocalName
		addIndent()
		cLine = '<' + cFullTag + '>' + xmlEscape("" + cText) + '</' + cFullTag + '>'
		if lPretty cLine += cNL ok
		aParts + cLine
		return self

	func addElements aList
		nListLen = len(aList)
		for nItem = 1 to nListLen
			addElement(aList[nItem][1], aList[nItem][2])
		next
		return self

	func addFromList cTag, aList
		startElement(cTag)
		nListLen = len(aList)
		for nItem = 1 to nListLen
			if isList(aList[nItem]) and len(aList[nItem]) = 2
				if isString(aList[nItem][2])
					addElement(aList[nItem][1], aList[nItem][2])
				but isList(aList[nItem][2])
					addFromList(aList[nItem][1], aList[nItem][2])
				ok
			ok
		next
		endElement()
		return self

	func addListAsElements cTag, aItems
		nItemsLen = len(aItems)
		for nItem = 1 to nItemsLen
			addElement(cTag, "" + aItems[nItem])
		next
		return self

	func output
		cOut = ""
		nPartsLen = len(aParts)
		for nPart = 1 to nPartsLen
			cOut += aParts[nPart]
		next
		return cOut

	func save cFileName
		cContent = ""
		if !lDeclAdded
			cContent = '<?xml version="' + cVersion + '" encoding="' + cEncoding + '"?>' + cNL
		ok
		cContent += output()
		write(cFileName, cContent)
		return fexists(cFileName)

	func toString
		return output()

	func count
		return len(aStack)

	func closeAll
		while len(aStack) > 0
			endElement()
		end
		return self

	func reset
		aParts = []
		aStack = []
		nLevel = 0
		lDeclAdded = false
		return self

	private

	func addIndent
		if !lPretty or nLevel = 0 return ok
		initCache()
		nIdx = nLevel + 1
		if nIdx <= nIndCacheSize
			aParts + aIndCache[nIdx]
		else
			cInd = ""
			for nStep = 1 to nLevel
				cInd += cIndent
			next
			aParts + cInd
		ok
