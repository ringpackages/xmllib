/*
	XMLLib Demo 16 - Print tree visualization
*/

load "xmllib.ring"

# -------------------------------------------------------
# Demo 16: Print tree visualization
# -------------------------------------------------------
? "Demo 16: Tree visualization..."

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
	oRoot.printTree()
ok
? ""
