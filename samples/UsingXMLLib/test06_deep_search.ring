/*
	XMLLib Demo 6 - Deep search (find/findAll)
*/

load "xmllib.ring"

# -------------------------------------------------------
# Demo 6: Deep search (find/findAll)
# -------------------------------------------------------
? "Demo 6: Deep search..."

cDeepXml = '<company>
  <departments>
    <department name="Engineering">
      <team name="Backend">
        <member>Alice</member>
        <member>Bob</member>
      </team>
      <team name="Frontend">
        <member>Charlie</member>
      </team>
    </department>
    <department name="Marketing">
      <team name="Digital">
        <member>Diana</member>
        <member>Eve</member>
      </team>
    </department>
  </departments>
</company>'

oRoot = xmlParse(cDeepXml)
if oRoot != NULL
	# Find all members regardless of nesting depth
	aMembers = oRoot.findAll("member")
	? "  All members found: " + len(aMembers)
	for oMember in aMembers
		? "    - " + oMember.text()
	next

	? ""

	# Find all teams
	aTeams = oRoot.findAll("team")
	? "  All teams:"
	for oTeam in aTeams
		? "    Team: " + oTeam.attr("name") + 
			" (" + oTeam.elementCount() + " members)"
	next

	? ""

	# Find by attribute
	oEng = oRoot.findByAttr("name", "Engineering")
	if oEng != NULL
		? "  Found Engineering department!"
	ok
ok
? ""
