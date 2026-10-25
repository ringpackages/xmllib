XML_ELEMENT     = 1
XML_TEXT        = 2
XML_COMMENT     = 3
XML_CDATA       = 4
XML_PI          = 5
XML_DOCUMENT    = 6

XML_TAB = char(9)
XML_LF  = char(10)
XML_CR  = char(13)

# Parser flat buffer arrays (global)
aFBType  = []
aFBTag   = []
aFBText  = []
aFBAttrs = []
aFBKids  = []
nFBCount = 0
