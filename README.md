# XMLLib Package

## Overview

XMLLib is a pure Ring library for building and parsing XML documents. 

It requires no external dependencies and works on Windows, Linux, and macOS.

## Features

- Build XML documents with the `XMLWriter` class
- Parse XML strings and files into a tree of `XMLNode` objects (`xmlParse()`, `xmlParseFile()` or the `XMLParser` class)
- Navigate the tree: child elements by tag, by index, first/last child
- Deep search by tag name, attribute value, or text content
- XPath-like queries (simplified subset)
- Pretty-printed output with configurable indentation
- XML declaration and processing instructions
- CDATA sections and comments
- Namespace-prefixed elements with `xmlns` declarations
- Attribute handling (get, set, remove, check)
- Escaping and unescaping of the five standard XML entities
- Save to file and load from file
- Convert XML to Ring lists and back
- Modify parsed trees (add/remove children, change text, update attributes)
- Tree visualization for debugging

## Installation

	ringpm install xmllib from ringpackages

## Screen Shots

![Screen Shot 1](https://raw.githubusercontent.com/ringpackages/xmllib/main/images/xmllib_shot1.png)

![Screen Shot 2](https://raw.githubusercontent.com/ringpackages/xmllib/main/images/xmllib_shot2.png)

## Quick Start

### Build XML

```ring
load "xmllib.ring"

oXml = new XMLWriter
oXml.addDeclaration()
oXml.startElement("person")
oXml.addElement("name", "Adam")
oXml.addElement("age", "30")
oXml.endElement()
oXml.save("person.xml")
```

### Parse XML

```ring
load "xmllib.ring"

oRoot = xmlParseFile("person.xml")
? oRoot.child("name").text()     # Output: Adam
? oRoot.child("age").text()      # Output: 30
```

### Quick Functions

```ring
load "xmllib.ring"

# Quick XML string
cXml = quickXML("person", [["name", "Adam"], ["age", "30"]])

# Quick XML file
quickXMLFile("person.xml", "person", [["name", "Adam"], ["age", "30"]])

# Parse string
oRoot = xmlParse("<root><item>Hello</item></root>")

# Parse file
oRoot = xmlParseFile("person.xml")

# Escape/Unescape
? xmlEscape("Tom & Jerry <2>")       # Output: Tom &amp; Jerry &lt;2&gt;
? xmlUnescape("Tom &amp; Jerry")     # Output: Tom & Jerry

# XML to Ring list and back
aData = xmlToList("<root><item>Hello</item></root>")
cXml = listToXML(aData)              # Output: <root><item>Hello</item></root>
```

---

## API Reference

### Quick Functions

| Function | Description |
|----------|-------------|
| `quickXML(cRootTag, aChildrenList)` | Return a pretty-printed XML string: a root element containing one element per `[tag, text]` pair (no declaration) |
| `quickXMLFile(cFileName, cRootTag, aChildrenList)` | Same as `quickXML()` with an XML declaration, saved to a file; returns true if the file exists |
| `xmlParse(cXml)` | Parse an XML string; returns the root `XMLNode`, or `NULL` if there is no root element |
| `xmlParseFile(cFileName)` | Parse an XML file; prints an error and returns `NULL` if the file is not found |
| `xmlEscape(cStr)` | Escape `&`, `<`, `>`, `"` and `'` (non-string values are converted to strings first) |
| `xmlUnescape(cStr)` | Convert `&lt;`, `&gt;`, `&quot;`, `&apos;` and `&amp;` back to characters (numeric references such as `&#65;` are left as is) |
| `xmlTrim(cStr)` | Remove leading and trailing spaces, tabs and line breaks |
| `xmlToList(cXml)` | Convert XML to a Ring list (see below); returns `[]` if parsing fails |
| `listToXML(aList)` | Convert a list produced by `xmlToList()` back to a compact XML string |

#### List Format

`xmlToList()` converts each element to a list with three keys, and each text node to a plain string:

```ring
[ :tag = "order", :attrs = [["id", "1001"]], :children = [ "text", [ :tag = ... ], ... ] ]
```

Whitespace text between elements is kept as string children. Comments, CDATA sections and processing instruction data are not preserved by the conversion.

---

### XMLWriter Class

Build XML documents with optional pretty-printing. Output is collected in memory until you call `output()` or `save()`.

#### Configuration

| Method | Description |
|--------|-------------|
| `setIndent(cNewIndent)` | Set indentation string (default: two spaces) |
| `setPrettyPrint(lFlag)` | Enable/disable indentation and line breaks (default: true); affects content added after the call |
| `setVersion(cVer)` | Set XML version used by the declaration (default: "1.0") |
| `setEncoding(cEnc)` | Set encoding used by the declaration (default: "UTF-8") |
| `setStandalone(lFlag)` | Add `standalone="yes"` to the declaration created by `addDeclaration()` |

#### Declaration and Processing Instructions

| Method | Description |
|--------|-------------|
| `addDeclaration()` | Add `<?xml version="..." encoding="..."?>` declaration |
| `addPI(cTarget, cPIData)` | Add processing instruction `<?target data?>` |

#### Elements

Attribute lists are lists of `[name, value]` pairs. Text and attribute values are escaped.

| Method | Description |
|--------|-------------|
| `startElement(cTag)` | Open element (must close with `endElement()`) |
| `startElementAttrs(cTag, aAttrs)` | Open element with attributes |
| `endElement()` | Close most recent open element (prints a warning if none is open) |
| `addElement(cTag, cText)` | Add complete element with text |
| `addElementAttrs(cTag, cText, aAttrs)` | Add element with attributes and text |
| `addEmptyElement(cTag)` | Add self-closing element `<tag/>` |
| `addEmptyElementAttrs(cTag, aAttrs)` | Add self-closing element with attributes |
| `addRawElement(cTag, cRawContent)` | Add element with unescaped content |

#### Text, Comments, CDATA

| Method | Description |
|--------|-------------|
| `addText(cText)` | Add escaped text content on its own line |
| `addRawText(cText)` | Add unescaped text as is (no indentation or line break) |
| `addComment(cText)` | Add `<!-- comment -->` |
| `addCDATA(cText)` | Add `<![CDATA[...]]>` |

#### Namespaces

| Method | Description |
|--------|-------------|
| `startElementNS(cPrefix, cLocalName, cNSURI)` | Open `<prefix:localName xmlns:prefix="uri">` (close with `endElement()`) |
| `addElementNS(cPrefix, cLocalName, cText)` | Add `<prefix:localName>text</prefix:localName>` (no `xmlns` declaration) |

#### Convenience

| Method | Description |
|--------|-------------|
| `addElements(aList)` | Add one element per `[tag, text]` pair |
| `addFromList(cTag, aList)` | Add element `cTag` with children from `[tag, value]` pairs: a string value adds an element, a list value adds a nested structure (other values are skipped) |
| `addListAsElements(cTag, aItems)` | Add one `cTag` element for each item (items are converted to strings) |

#### Output and State

| Method | Description |
|--------|-------------|
| `output()` | Return the XML as a string |
| `toString()` | Alias for `output()` |
| `save(cFileName)` | Save to file, adding a declaration if `addDeclaration()` was not called; returns true if the file exists |
| `count()` | Return the number of open elements |
| `closeAll()` | Close all open elements |
| `reset()` | Clear the content and open elements (settings are kept) |

The configuration and building methods (including `closeAll()` and `reset()`) return `self`, so they can be chained. `output()`, `toString()`, `save()` and `count()` return values.

---

### XMLNode Class

Represents a node in the parsed XML tree. `xmlParse()` returns the root element as an `XMLNode`.

#### Node Types

| Constant | Value | Description |
|----------|-------|-------------|
| `XML_ELEMENT` | 1 | Element node |
| `XML_TEXT` | 2 | Text node |
| `XML_COMMENT` | 3 | Comment node |
| `XML_CDATA` | 4 | CDATA section |
| `XML_PI` | 5 | Processing instruction (`cTag` holds the target, `cText` the data) |
| `XML_DOCUMENT` | 6 | Defined for completeness; not created by the parser |

#### Properties

| Property | Description |
|----------|-------------|
| `nType` | Node type constant |
| `cTag` | Tag name (elements) or target (processing instructions) |
| `cText` | Text content (text, comment, CDATA, processing instruction) |
| `aAttrs` | Attributes list of `[name, value]` pairs |
| `aChildren` | Child nodes list |
| `oParent` | Parent node (not set by the parser or `addChild()`, so it is `NULL` unless you assign it) |

Text nodes are part of `aChildren`, including whitespace between elements. Methods that work by index (`childCount()`, `childAt()`, `firstChild()`, `lastChild()`, `removeChild()`) count these text nodes too; use `elements()` or `elementCount()` to work with elements only.

#### Text and Attributes

| Method | Description |
|--------|-------------|
| `tag()` | Get tag name |
| `text()` | Get the text of the node and all descendants (text and CDATA; comments are excluded) |
| `directText()` | Get only the text of direct text children |
| `attr(cName)` | Get attribute value (empty string if not found) |
| `hasAttr(cName)` | Check if attribute exists |
| `setAttr(cName, cValue)` | Set or update attribute |
| `removeAttr(cName)` | Remove attribute |
| `attrs()` | Get all attributes as `[name, value]` pairs |
| `attrCount()` | Count attributes |

#### Child Navigation

| Method | Description |
|--------|-------------|
| `child(cTagName)` | Get first child element with the tag (`NULL` if not found) |
| `children(cTagName)` | Get all child elements with the tag |
| `childAt(nIndex)` | Get child node by index, 1-based (`NULL` if out of range) |
| `childCount()` | Count all child nodes (including text nodes) |
| `elementCount()` | Count element children only |
| `elements()` | Get all element children |
| `firstChild()` | Get first child node (`NULL` if none) |
| `lastChild()` | Get last child node (`NULL` if none) |
| `parent()` | Get `oParent` (see Properties) |

#### Deep Search

| Method | Description |
|--------|-------------|
| `find(cTagName)` | Find first element with the tag: direct children are checked first, then each child's subtree (`NULL` if not found) |
| `findAll(cTagName)` | Find all descendant elements with the tag, in document order |
| `findByAttr(cAttrName, cAttrValue)` | Find first element with the attribute value, starting with the node itself (`NULL` if not found) |
| `findAllByAttr(cAttrName, cAttrValue)` | Find all elements with the attribute value, including the node itself |
| `findByText(cSearchText)` | Find the first descendant element whose `text()` contains the search text (case-sensitive; returns the outermost match) |

#### XPath-like Queries

`xpath(cPath)` supports a small subset of XPath:

| Pattern | Example | Result |
|---------|---------|--------|
| `tag` | `xpath("book")` | List of direct child elements with the tag |
| `tag1/tag2` | `xpath("books/book")` | Follows the first `tag1` child, then applies the rest of the path (`NULL` if a step is not found) |
| `//tag` | `xpath("//title")` | List of all descendant elements with the tag |
| `tag[@attr='val']` | `xpath("book[@id='1']")` | List of direct child elements with the tag and attribute value |

The attribute filter works only on direct children and cannot be combined with a path (`books/book[@id='1']` returns an empty list). An empty path returns `NULL`.

#### Modification

| Method | Description |
|--------|-------------|
| `addChild(oChild)` | Append a child node |
| `removeChild(nIndex)` | Remove child node by index (text nodes count) |
| `removeChildByTag(cTagName)` | Remove first child element with the tag |
| `setText(cNewText)` | Remove direct text children and append one text node |

All modification methods return `self`.

#### Output

| Method | Description |
|--------|-------------|
| `toXml()` | Pretty-printed XML string with two-space indentation |
| `toXmlCompact()` | XML string without indentation; text is kept exactly as parsed |
| `toXmlCustom(cIndStr)` | Pretty-printed XML string with a custom indent string |
| `saveToFile(cFileName)` | Save `toXml()` with an XML declaration; returns true if the file exists |
| `printTree()` | Print the tree to the screen (whitespace-only text and processing instructions are not shown) |

In pretty-printed output, text is trimmed with `xmlTrim()`, whitespace-only text (spaces, tabs, line breaks) is dropped, and an element whose only child is a text shorter than 60 characters is written on one line. This means a parsed pretty-printed document is saved again without extra blank lines.

---

### XMLParser Class

Thin wrapper over the parse functions.

| Method | Description |
|--------|-------------|
| `parseString(cXml)` | Same as `xmlParse(cXml)` |
| `parseFile(cFileName)` | Same as `xmlParseFile(cFileName)` |

**Supports:** Elements, attributes (double or single quotes, or no value), text, comments, CDATA, processing instructions, nested structures, and entity unescaping in text and attribute values. A UTF-8 BOM, the XML declaration, and comments, processing instructions and DOCTYPE before the root element are skipped.

---

## Usage Examples

### Example 1: Configuration File

```ring
load "xmllib.ring"

# Write config
oXml = new XMLWriter
oXml.addDeclaration()
oXml.startElement("config")
oXml.addElement("host", "localhost")
oXml.addElement("port", "8080")
oXml.addElement("debug", "false")
oXml.endElement()
oXml.save("config.xml")

# Read config
oConf = xmlParseFile("config.xml")
cHost = oConf.child("host").text()
cPort = oConf.child("port").text()
```

### Example 2: Data Exchange

```ring
load "xmllib.ring"

# Build order XML
oXml = new XMLWriter
oXml.startElementAttrs("order", [["id", "1001"]])
oXml.addElement("customer", "Ring Developer")
oXml.startElement("items")
for aItem in [["Keyboard", "49.99"], ["Mouse", "29.99"]]
    oXml.addElementAttrs("item", aItem[1], [["price", aItem[2]]])
next
oXml.endElement()
oXml.endElement()
oXml.save("order.xml")
```

### Example 3: RSS Feed

```ring
load "xmllib.ring"

oXml = new XMLWriter
oXml.addDeclaration()
oXml.startElementAttrs("rss", [["version", "2.0"]])
oXml.startElement("channel")
oXml.addElement("title", "My Blog")
oXml.addElement("link", "https://example.com")

oXml.startElement("item")
oXml.addElement("title", "First Post")
oXml.addElement("description", "Hello World!")
oXml.endElement()

oXml.endElement()
oXml.endElement()
oXml.save("feed.xml")
```

### Example 4: SOAP Message

```ring
load "xmllib.ring"

oXml = new XMLWriter
oXml.addDeclaration()
oXml.startElementNS("soap", "Envelope", 
    "http://schemas.xmlsoap.org/soap/envelope/")
oXml.startElement("soap:Body")
oXml.startElement("GetProduct")
oXml.addElement("ProductId", "12345")
oXml.endElement()
oXml.endElement()
oXml.endElement()
oXml.save("request.xml")
```

### Example 5: Parse and Modify

```ring
load "xmllib.ring"

oRoot = xmlParseFile("config.xml")
oRoot.child("debug").setText("true")
oRoot.setAttr("modified", "2026-02-04")
oRoot.saveToFile("config_updated.xml")
```

### Example 6: Search and Filter

```ring
load "xmllib.ring"

oRoot = xmlParseFile("catalog.xml")

# Find all products over $50
aProducts = oRoot.findAll("product")
for oProd in aProducts
    nPrice = number(oProd.child("price").text())
    if nPrice > 50
        ? oProd.child("name").text() + ": $" + oProd.child("price").text()
    ok
next
```

---

## License

MIT License
