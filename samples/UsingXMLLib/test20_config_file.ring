/*
	XMLLib Demo 20 - Configuration file (read/write)
*/

load "xmllib.ring"

# -------------------------------------------------------
# Demo 20: Configuration file (read/write)
# -------------------------------------------------------
? "Demo 20: Config file roundtrip..."

# Write config
oXml = new XMLWriter
oXml.addDeclaration()
oXml.startElement("appConfig")
oXml.addElement("appName", "MyRingApp")
oXml.addElement("version", "1.0.0")
oXml.startElement("database")
oXml.addElement("host", "localhost")
oXml.addElement("port", "5432")
oXml.addElement("name", "mydb")
oXml.addElement("user", "admin")
oXml.endElement()
oXml.startElement("features")
oXml.addElementAttrs("feature", "true", [["name", "caching"]])
oXml.addElementAttrs("feature", "false", [["name", "debug"]])
oXml.addElementAttrs("feature", "true", [["name", "logging"]])
oXml.endElement()
oXml.endElement()

oXml.save("demo20_config.xml")
? "  Saved config"

# Read config back
oConf = xmlParseFile("demo20_config.xml")
if oConf != NULL
	? "  App: " + oConf.child("appName").text()
	? "  Version: " + oConf.child("version").text()

	oDB = oConf.child("database")
	? "  DB Host: " + oDB.child("host").text()
	? "  DB Port: " + oDB.child("port").text()

	aFeatures = oConf.child("features").children("feature")
	? "  Features:"
	for oFeat in aFeatures
		? "    " + oFeat.attr("name") + " = " + oFeat.text()
	next
ok
? ""
