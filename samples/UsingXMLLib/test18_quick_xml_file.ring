/*
	XMLLib Demo 18 - Quick XML file creation
*/

load "xmllib.ring"

# -------------------------------------------------------
# Demo 18: Quick XML file creation
# -------------------------------------------------------
? "Demo 18: Quick XML file..."

quickXMLFile("demo18_person.xml", "employee", [
	["name", "Ahmed"],
	["title", "Software Engineer"],
	["department", "R&D"],
	["email", "ahmed@example.com"]
])
? "  Created: demo18_person.xml"
? "  Content:"
? read("demo18_person.xml")
? ""
