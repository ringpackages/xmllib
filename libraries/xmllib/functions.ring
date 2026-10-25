func quickXML cRootTag, aChildrenList
	oDoc = new XMLWriter
	oDoc.startElement(cRootTag)
	nChildLen = len(aChildrenList)
	for nChild = 1 to nChildLen
		aPair = aChildrenList[nChild]
		oDoc.addElement(aPair[1], aPair[2])
	next
	oDoc.endElement()
	return oDoc.output()

func quickXMLFile cFileName, cRootTag, aChildrenList
	cContent = quickXML(cRootTag, aChildrenList)
	write(cFileName, '<?xml version="1.0" encoding="UTF-8"?>' + nl + cContent)
	return fexists(cFileName)

func xmlParse cXml
	return xParse(cXml)

func xmlParseFile cFileName
	if !fexists(cFileName)
		? "RingXMLLib Error: File not found: " + cFileName
		return NULL
	ok
	return xParse(read(cFileName))

func xmlEscape cStr
	cStr = "" + cStr
	if substr(cStr, "&") = 0 and substr(cStr, "<") = 0 and
		substr(cStr, ">") = 0 and substr(cStr, '"') = 0 and substr(cStr, "'") = 0
		return cStr
	ok
	cStr = substr(cStr, "&", "&amp;")
	cStr = substr(cStr, "<", "&lt;")
	cStr = substr(cStr, ">", "&gt;")
	cStr = substr(cStr, '"', "&quot;")
	cStr = substr(cStr, "'", "&apos;")
	return cStr

func xmlUnescape cStr
	cStr = "" + cStr
	if substr(cStr, "&") = 0
		return cStr
	ok
	cStr = substr(cStr, "&lt;", "<")
	cStr = substr(cStr, "&gt;", ">")
	cStr = substr(cStr, "&quot;", '"')
	cStr = substr(cStr, "&apos;", "'")
	cStr = substr(cStr, "&amp;", "&")
	return cStr

func xmlTrim cStr
	nLen = len(cStr)
	nStart = 1
	while nStart <= nLen
		cChar = cStr[nStart]
		if cChar != " " and cChar != XML_TAB and cChar != XML_LF and cChar != XML_CR exit ok
		nStart += 1
	end
	if nStart > nLen return "" ok
	nEnd = nLen
	while nEnd > nStart
		cChar = cStr[nEnd]
		if cChar != " " and cChar != XML_TAB and cChar != XML_LF and cChar != XML_CR exit ok
		nEnd -= 1
	end
	return substr(cStr, nStart, nEnd - nStart + 1)

func xmlToList cXml
	oRootNode = xmlParse(cXml)
	if oRootNode = NULL return [] ok
	return xmlNodeToList(oRootNode)

func xmlNodeToList oNode
	if oNode.nType = XML_TEXT
		return oNode.cText
	ok
	aOut = [:tag = oNode.cTag, :attrs = oNode.aAttrs, :children = []]
	nChildLen = len(oNode.aChildren)
	for nChild = 1 to nChildLen
		aOut[:children] + xmlNodeToList(oNode.aChildren[nChild])
	next
	return aOut

func listToXML aList
	if isString(aList) return xmlEscape(aList) ok
	if !isList(aList) return "" ok
	cTag = aList[:tag]
	if cTag = NULL or cTag = "" return "" ok
	cOut = "<" + cTag
	aAttrs = aList[:attrs]
	if isList(aAttrs)
		nAttrLen = len(aAttrs)
		for nAttr = 1 to nAttrLen
			if isList(aAttrs[nAttr]) and len(aAttrs[nAttr]) = 2
				cOut += " " + aAttrs[nAttr][1] + '="' + xmlEscape(aAttrs[nAttr][2]) + '"'
			ok
		next
	ok
	aChildren = aList[:children]
	if !isList(aChildren) or len(aChildren) = 0
		return cOut + "/>"
	ok
	cOut += ">"
	nChildLen = len(aChildren)
	for nChild = 1 to nChildLen
		cOut += listToXML(aChildren[nChild])
	next
	return cOut + "</" + cTag + ">"

func fbReset
	aFBType  = []
	aFBTag   = []
	aFBText  = []
	aFBAttrs = []
	aFBKids  = []
	nFBCount = 0

func fbAlloc
	nFBCount += 1
	aFBType  + 0
	aFBTag   + ""
	aFBText  + ""
	aFBAttrs + ""
	aFBKids  + ""
	return nFBCount

func xParse cXml
	fbReset()
	cData = cXml
	nPos = 1
	nLen = len(cData)

	# Skip BOM
	if nLen >= 3
		if ascii(cData[1]) = 0xEF and ascii(cData[2]) = 0xBB and ascii(cData[3]) = 0xBF
			nPos = 4
		ok
	ok

	# Skip whitespace
	while nPos <= nLen
		cChar = cData[nPos]
		if cChar != " " and cChar != XML_TAB and cChar != XML_LF and cChar != XML_CR exit ok
		nPos += 1
	end

	# Skip XML declaration
	if nPos + 4 <= nLen
		if substr(cData, nPos, 5) = "<?xml"
			nF = substr(cData, "?>")
			if nF > 0 nPos = nF + 2 ok
		ok
	ok

	# Skip PIs, comments, DOCTYPE before root
	lAgain = true
	while lAgain and nPos <= nLen
		while nPos <= nLen
			cChar = cData[nPos]
			if cChar != " " and cChar != XML_TAB and cChar != XML_LF and cChar != XML_CR exit ok
			nPos += 1
		end
		lAgain = false
		if nPos + 3 <= nLen and substr(cData, nPos, 4) = "<!--"
			nF = substr(cData, "-->")
			if nF > 0 nPos = nF + 3 lAgain = true ok
		but nPos + 1 <= nLen and substr(cData, nPos, 2) = "<?"
			nF = substr(cData, "?>")
			if nF > 0 nPos = nF + 2 lAgain = true ok
		but nPos + 8 <= nLen and substr(cData, nPos, 9) = "<!DOCTYPE"
			while nPos <= nLen and cData[nPos] != ">"
				nPos += 1
			end
			if nPos <= nLen nPos += 1 ok
			lAgain = true
		ok
	end

	if nPos > nLen or cData[nPos] != "<"
		return NULL
	ok

	aPos = [nPos]
	nRootIdx = fbParseEl(cData, aPos, nLen)

	if nRootIdx = 0 return NULL ok

	aNodes = list(nFBCount)
	for nNode = 1 to nFBCount
		oNode = new XMLNode
		oNode.nType = aFBType[nNode]
		oNode.cTag = aFBTag[nNode]
		oNode.cText = aFBText[nNode]
		aA = aFBAttrs[nNode]
		if isList(aA) and len(aA) > 0
			oNode.aAttrs = aA
		ok
		aNodes[nNode] = oNode
	next

	# Link children bottom-up (reverse order so leaves are complete before parents copy them)
	for nNode = nFBCount to 1 step -1
		aK = aFBKids[nNode]
		if isList(aK) and len(aK) > 0
			nKidLen = len(aK)
			for nKid = 1 to nKidLen
				aNodes[nNode].aChildren + aNodes[aK[nKid]]
			next
		ok
	next

	return aNodes[nRootIdx]

func fbParseEl cData, aPos, nLen
	nPos = aPos[1]

	# Skip '<'
	nPos += 1

	# Read tag name
	nNameStart = nPos
	while nPos <= nLen
		cChar = cData[nPos]
		if cChar = " " or cChar = XML_TAB or cChar = XML_LF or cChar = XML_CR or
			cChar = ">" or cChar = "/" or cChar = "=" or cChar = '"' or cChar = "'"
			exit
		ok
		nPos += 1
	end
	cTagName = substr(cData, nNameStart, nPos - nNameStart)

	# Allocate node in flat buffer
	nIdx = fbAlloc()
	aFBType[nIdx] = XML_ELEMENT
	aFBTag[nIdx] = cTagName

	# Parse attributes
	aAttrs = []
	while nPos <= nLen
		while nPos <= nLen
			cChar = cData[nPos]
			if cChar != " " and cChar != XML_TAB and cChar != XML_LF and cChar != XML_CR exit ok
			nPos += 1
		end
		if nPos > nLen exit ok
		cChar = cData[nPos]
		if cChar = ">" or cChar = "/" exit ok

		nAttrStart = nPos
		while nPos <= nLen
			cChar = cData[nPos]
			if cChar = " " or cChar = XML_TAB or cChar = XML_LF or cChar = XML_CR or
				cChar = ">" or cChar = "/" or cChar = "=" or cChar = '"' or cChar = "'"
				exit
			ok
			nPos += 1
		end
		cAttrName = substr(cData, nAttrStart, nPos - nAttrStart)
		if cAttrName = ""
			nPos += 1
			loop
		ok

		while nPos <= nLen
			cChar = cData[nPos]
			if cChar != " " and cChar != XML_TAB and cChar != XML_LF and cChar != XML_CR exit ok
			nPos += 1
		end

		if nPos <= nLen and cData[nPos] = "="
			nPos += 1
			while nPos <= nLen
				cChar = cData[nPos]
				if cChar != " " and cChar != XML_TAB and cChar != XML_LF and cChar != XML_CR exit ok
				nPos += 1
			end
			if nPos <= nLen
				cQuote = cData[nPos]
				if cQuote = '"' or cQuote = "'"
					nPos += 1
					nValueStart = nPos
					while nPos <= nLen and cData[nPos] != cQuote
						nPos += 1
					end
					aAttrs + [cAttrName, xmlUnescape(substr(cData, nValueStart, nPos - nValueStart))]
					nPos += 1
				ok
			ok
		else
			aAttrs + [cAttrName, cAttrName]
		ok
	end
	if len(aAttrs) > 0
		aFBAttrs[nIdx] = aAttrs
	ok

	# Skip whitespace
	while nPos <= nLen
		cChar = cData[nPos]
		if cChar != " " and cChar != XML_TAB and cChar != XML_LF and cChar != XML_CR exit ok
		nPos += 1
	end

	# Self-closing?
	if nPos + 1 <= nLen and substr(cData, nPos, 2) = "/>"
		nPos += 2
		aPos[1] = nPos
		return nIdx
	ok

	if nPos <= nLen and cData[nPos] = ">"
		nPos += 1
	ok

	cCloseTag = "</" + cTagName
	nCloseTagLen = len(cCloseTag)
	aChildIdx = []

	# Parse children
	while nPos <= nLen
		# Text content
		if cData[nPos] != "<"
			nTextStart = nPos
			while nPos <= nLen and cData[nPos] != "<"
				nPos += 1
			end
			nChildIdx = fbAlloc()
			aFBType[nChildIdx] = XML_TEXT
			aFBText[nChildIdx] = xmlUnescape(substr(cData, nTextStart, nPos - nTextStart))
			aChildIdx + nChildIdx
		ok

		if nPos > nLen exit ok

		nRemaining = nLen - nPos + 1

		# Closing tag?
		if nRemaining >= nCloseTagLen and substr(cData, nPos, nCloseTagLen) = cCloseTag
			while nPos <= nLen and cData[nPos] != ">"
				nPos += 1
			end
			if nPos <= nLen nPos += 1 ok
			exit

		but nRemaining >= 2 and substr(cData, nPos, 2) = "</"
			while nPos <= nLen and cData[nPos] != ">"
				nPos += 1
			end
			if nPos <= nLen nPos += 1 ok
			exit

		but nRemaining >= 4 and substr(cData, nPos, 4) = "<!--"
			nPos += 4
			nCommentStart = nPos
			while nPos + 2 <= nLen
				if substr(cData, nPos, 3) = "-->" exit ok
				nPos += 1
			end
			nChildIdx = fbAlloc()
			aFBType[nChildIdx] = XML_COMMENT
			aFBText[nChildIdx] = substr(cData, nCommentStart, nPos - nCommentStart)
			aChildIdx + nChildIdx
			nPos += 3

		but nRemaining >= 9 and substr(cData, nPos, 9) = "<![CDATA["
			nPos += 9
			nCDataStart = nPos
			while nPos + 2 <= nLen
				if substr(cData, nPos, 3) = "]]>" exit ok
				nPos += 1
			end
			nChildIdx = fbAlloc()
			aFBType[nChildIdx] = XML_CDATA
			aFBText[nChildIdx] = substr(cData, nCDataStart, nPos - nCDataStart)
			aChildIdx + nChildIdx
			nPos += 3

		but nRemaining >= 2 and substr(cData, nPos, 2) = "<?"
			nPos += 2
			nPINameStart = nPos
			while nPos <= nLen
				cChar = cData[nPos]
				if cChar = " " or cChar = XML_TAB or cChar = XML_LF or cChar = XML_CR or cChar = "?" exit ok
				nPos += 1
			end
			cPITarget = substr(cData, nPINameStart, nPos - nPINameStart)
			while nPos <= nLen
				cChar = cData[nPos]
				if cChar != " " and cChar != XML_TAB and cChar != XML_LF and cChar != XML_CR exit ok
				nPos += 1
			end
			nPIDataStart = nPos
			while nPos + 1 <= nLen
				if substr(cData, nPos, 2) = "?>" exit ok
				nPos += 1
			end
			nChildIdx = fbAlloc()
			aFBType[nChildIdx] = XML_PI
			aFBTag[nChildIdx] = cPITarget
			aFBText[nChildIdx] = substr(cData, nPIDataStart, nPos - nPIDataStart)
			aChildIdx + nChildIdx
			nPos += 2

		but cData[nPos] = "<"
			# Child element
			aPos[1] = nPos
			nChildIdx = fbParseEl(cData, aPos, nLen)
			nPos = aPos[1]
			aChildIdx + nChildIdx
		else
			nPos += 1
		ok
	end

	if len(aChildIdx) > 0
		aFBKids[nIdx] = aChildIdx
	ok

	aPos[1] = nPos
	return nIdx
