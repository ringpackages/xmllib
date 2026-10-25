/*
	XMLLib Demo 17 - XML escaping
*/

load "xmllib.ring"

# -------------------------------------------------------
# Demo 17: XML escaping
# -------------------------------------------------------
? "Demo 17: XML escaping..."

cDangerous = 'Tom & Jerry <friends> said "hello" to O' + "'" + 'Brien'
? "  Original: " + cDangerous
? "  Escaped:  " + xmlEscape(cDangerous)
? "  Roundtrip: " + xmlUnescape(xmlEscape(cDangerous))
? ""
