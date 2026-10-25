class XMLNode

	nType = XML_ELEMENT
	cTag = ""
	cText = ""
	aAttrs = []
	aChildren = []
	oParent = NULL

	func tag
		return cTag

	func text
		if nType = XML_TEXT or nType = XML_CDATA
			return cText
		ok
		cOut = ""
		nChildLen = len(aChildren)
		for nChild = 1 to nChildLen
			cOut += aChildren[nChild].text()
		next
		return cOut

	func directText
		cOut = ""
		nChildLen = len(aChildren)
		for nChild = 1 to nChildLen
			if aChildren[nChild].nType = XML_TEXT
				cOut += aChildren[nChild].cText
			ok
		next
		return cOut

	func attr cName
		nAttrLen = len(aAttrs)
		for nAttr = 1 to nAttrLen
			if aAttrs[nAttr][1] = cName
				return aAttrs[nAttr][2]
			ok
		next
		return ""

	func hasAttr cName
		nAttrLen = len(aAttrs)
		for nAttr = 1 to nAttrLen
			if aAttrs[nAttr][1] = cName
				return true
			ok
		next
		return false

	func setAttr cName, cValue
		nAttrLen = len(aAttrs)
		for nAttr = 1 to nAttrLen
			if aAttrs[nAttr][1] = cName
				aAttrs[nAttr][2] = cValue
				return self
			ok
		next
		aAttrs + [cName, cValue]
		return self

	func removeAttr cName
		nAttrLen = len(aAttrs)
		for nAttr = 1 to nAttrLen
			if aAttrs[nAttr][1] = cName
				del(aAttrs, nAttr)
				return self
			ok
		next
		return self

	func attrs
		return aAttrs

	func attrCount
		return len(aAttrs)

	func child cTagName
		nChildLen = len(aChildren)
		for nChild = 1 to nChildLen
			if aChildren[nChild].nType = XML_ELEMENT and aChildren[nChild].cTag = cTagName
				return aChildren[nChild]
			ok
		next
		return NULL

	func children cTagName
		aFound = []
		nChildLen = len(aChildren)
		for nChild = 1 to nChildLen
			if aChildren[nChild].nType = XML_ELEMENT and aChildren[nChild].cTag = cTagName
				aFound + aChildren[nChild]
			ok
		next
		return aFound

	func childAt nIndex
		if nIndex >= 1 and nIndex <= len(aChildren)
			return aChildren[nIndex]
		ok
		return NULL

	func childCount
		return len(aChildren)

	func elementCount
		nCount = 0
		nChildLen = len(aChildren)
		for nChild = 1 to nChildLen
			if aChildren[nChild].nType = XML_ELEMENT
				nCount += 1
			ok
		next
		return nCount

	func elements
		aFound = []
		nChildLen = len(aChildren)
		for nChild = 1 to nChildLen
			if aChildren[nChild].nType = XML_ELEMENT
				aFound + aChildren[nChild]
			ok
		next
		return aFound

	func firstChild
		if len(aChildren) > 0
			return aChildren[1]
		ok
		return NULL

	func lastChild
		nChildLen = len(aChildren)
		if nChildLen > 0
			return aChildren[nChildLen]
		ok
		return NULL

	func parent
		return oParent

	func find cTagName
		nChildLen = len(aChildren)
		for nChild = 1 to nChildLen
			if aChildren[nChild].nType = XML_ELEMENT and aChildren[nChild].cTag = cTagName
				return aChildren[nChild]
			ok
		next
		for nChild = 1 to nChildLen
			if aChildren[nChild].nType = XML_ELEMENT
				oFound = aChildren[nChild].find(cTagName)
				if oFound != NULL
					return oFound
				ok
			ok
		next
		return NULL

	func findAll cTagName
		aFound = []
		findAllRecursive(cTagName, aFound)
		return aFound

	func findByAttr cAttrName, cAttrValue
		if hasAttr(cAttrName) and attr(cAttrName) = cAttrValue
			return self
		ok
		nChildLen = len(aChildren)
		for nChild = 1 to nChildLen
			if aChildren[nChild].nType = XML_ELEMENT
				oFound = aChildren[nChild].findByAttr(cAttrName, cAttrValue)
				if oFound != NULL
					return oFound
				ok
			ok
		next
		return NULL

	func findAllByAttr cAttrName, cAttrValue
		aFound = []
		findAllByAttrRecursive(cAttrName, cAttrValue, aFound)
		return aFound

	func findByText cSearchText
		nChildLen = len(aChildren)
		for nChild = 1 to nChildLen
			if aChildren[nChild].nType = XML_ELEMENT
				if substr(aChildren[nChild].text(), cSearchText) > 0
					return aChildren[nChild]
				ok
				oFound = aChildren[nChild].findByText(cSearchText)
				if oFound != NULL
					return oFound
				ok
			ok
		next
		return NULL

	func xpath cPath
		if cPath = "" or cPath = NULL return NULL ok
		if left(cPath, 2) = "//"
			return findAll(substr(cPath, 3))
		ok
		nBracketPos = substr(cPath, "[")
		if nBracketPos > 0
			cTagPart = left(cPath, nBracketPos - 1)
			cFilterPart = substr(cPath, nBracketPos + 1, len(cPath) - nBracketPos - 1)
			if left(cFilterPart, 1) = "@"
				nEqPos = substr(cFilterPart, "=")
				if nEqPos > 0
					cAttrName = substr(cFilterPart, 2, nEqPos - 2)
					cAttrVal = substr(cFilterPart, nEqPos + 1)
					cAttrVal = substr(cAttrVal, "'", "")
					cAttrVal = substr(cAttrVal, '"', "")
					aMatches = children(cTagPart)
					aFound = []
					nMatchLen = len(aMatches)
					for nMatch = 1 to nMatchLen
						if aMatches[nMatch].attr(cAttrName) = cAttrVal
							aFound + aMatches[nMatch]
						ok
					next
					return aFound
				ok
			ok
		ok
		nSlashPos = substr(cPath, "/")
		if nSlashPos > 0
			cFirstTag = left(cPath, nSlashPos - 1)
			cRestPath = substr(cPath, nSlashPos + 1)
			oChild = child(cFirstTag)
			if oChild != NULL
				return oChild.xpath(cRestPath)
			ok
			return NULL
		ok
		return children(cPath)

	func addChild oChild
		aChildren + oChild
		return self

	func removeChild nIndex
		if nIndex >= 1 and nIndex <= len(aChildren)
			del(aChildren, nIndex)
		ok
		return self

	func removeChildByTag cTagName
		nChildLen = len(aChildren)
		for nChild = 1 to nChildLen
			if aChildren[nChild].nType = XML_ELEMENT and aChildren[nChild].cTag = cTagName
				del(aChildren, nChild)
				return self
			ok
		next
		return self

	func setText cNewText
		nChild = 1
		while nChild <= len(aChildren)
			if aChildren[nChild].nType = XML_TEXT
				del(aChildren, nChild)
			else
				nChild += 1
			ok
		end
		oText = new XMLNode
		oText.nType = XML_TEXT
		oText.cText = cNewText
		aChildren + oText
		return self

	func toXml
		aParts = []
		toXmlParts(aParts, 0, "  ", true)
		cOut = ""
		nPartsLen = len(aParts)
		for nPart = 1 to nPartsLen
			cOut += aParts[nPart]
		next
		return cOut

	func toXmlCompact
		aParts = []
		toXmlParts(aParts, 0, "", false)
		cOut = ""
		nPartsLen = len(aParts)
		for nPart = 1 to nPartsLen
			cOut += aParts[nPart]
		next
		return cOut

	func toXmlCustom cIndStr
		aParts = []
		toXmlParts(aParts, 0, cIndStr, true)
		cOut = ""
		nPartsLen = len(aParts)
		for nPart = 1 to nPartsLen
			cOut += aParts[nPart]
		next
		return cOut

	func saveToFile cFileName
		cContent = '<?xml version="1.0" encoding="UTF-8"?>' + nl + toXml()
		write(cFileName, cContent)
		return fexists(cFileName)

	func printTree
		printTreeIndent(0)

	private

	func findAllRecursive cTagName, aFound
		nChildLen = len(aChildren)
		for nChild = 1 to nChildLen
			if aChildren[nChild].nType = XML_ELEMENT
				if aChildren[nChild].cTag = cTagName
					aFound + aChildren[nChild]
				ok
				aChildren[nChild].findAllRecursive(cTagName, aFound)
			ok
		next

	func findAllByAttrRecursive cAttrName, cAttrValue, aFound
		if hasAttr(cAttrName) and attr(cAttrName) = cAttrValue
			aFound + self
		ok
		nChildLen = len(aChildren)
		for nChild = 1 to nChildLen
			if aChildren[nChild].nType = XML_ELEMENT
				aChildren[nChild].findAllByAttrRecursive(cAttrName, cAttrValue, aFound)
			ok
		next

	func toXmlParts aParts, nLevel, cIndStr, lPretty
		cNL = nl
		cInd = ""
		if lPretty and nLevel > 0
			for nStep = 1 to nLevel
				cInd += cIndStr
			next
		ok

		switch nType
		on XML_TEXT
			if lPretty
				cTrimmed = xmlTrim(cText)
				if cTrimmed != ""
					aParts + (cInd + xmlEscape(cTrimmed) + cNL)
				ok
			else
				aParts + xmlEscape(cText)
			ok
		on XML_COMMENT
			aParts + (cInd + '<!-- ' + cText + ' -->' + cNL)
		on XML_CDATA
			aParts + (cInd + '<![CDATA[' + cText + ']]>' + cNL)
		on XML_PI
			aParts + (cInd + '<?' + cTag + ' ' + cText + '?>' + cNL)
		on XML_ELEMENT
			cOpenTag = cInd + '<' + cTag
			nAttrLen = len(aAttrs)
			for nAttr = 1 to nAttrLen
				cOpenTag += ' ' + aAttrs[nAttr][1] + '="' + xmlEscape(aAttrs[nAttr][2]) + '"'
			next
			nChildLen = len(aChildren)
			if nChildLen = 0
				aParts + (cOpenTag + '/>' + cNL)
			but nChildLen = 1 and aChildren[1].nType = XML_TEXT and
					len(aChildren[1].cText) < 60
				aParts + (cOpenTag + '>' + xmlEscape(aChildren[1].cText) + '</' + cTag + '>' + cNL)
			else
				aParts + (cOpenTag + '>' + cNL)
				for nChild = 1 to nChildLen
					aChildren[nChild].toXmlParts(aParts, nLevel + 1, cIndStr, lPretty)
				next
				aParts + (cInd + '</' + cTag + '>' + cNL)
			ok
		off

	func printTreeIndent nLevel
		cInd = ""
		for nStep = 1 to nLevel
			cInd += "  "
		next
		switch nType
		on XML_TEXT
			cTrimmed = xmlTrim(cText)
			if cTrimmed != ""
				? cInd + '"' + cTrimmed + '"'
			ok
		on XML_COMMENT
			? cInd + "<!-- " + cText + " -->"
		on XML_CDATA
			? cInd + "[CDATA: " + left(cText, 40) + "...]"
		on XML_ELEMENT
			cLine = cInd + "<" + cTag + ">"
			nAttrLen = len(aAttrs)
			if nAttrLen > 0
				cLine += " ("
				for nAttr = 1 to nAttrLen
					if nAttr > 1 cLine += ", " ok
					cLine += aAttrs[nAttr][1] + "=" + aAttrs[nAttr][2]
				next
				cLine += ")"
			ok
			? cLine
			nChildLen = len(aChildren)
			for nChild = 1 to nChildLen
				aChildren[nChild].printTreeIndent(nLevel + 1)
			next
		off
