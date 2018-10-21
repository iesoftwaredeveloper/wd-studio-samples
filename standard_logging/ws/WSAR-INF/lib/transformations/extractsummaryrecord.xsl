<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output method="text"/>
    <xsl:param name="xmltagtocopy"/>
    <xsl:variable name="linefeed"><xsl:text>&#xA;</xsl:text></xsl:variable>
    <xsl:variable name="carriagereturn"><xsl:text>&#13;</xsl:text></xsl:variable>
    <xsl:variable name="space" select="' '"/>
    <xsl:variable name="delimiter"><xsl:text>&#x09;</xsl:text></xsl:variable>
    
     <xsl:template match="/">
         <xsl:apply-templates select="//node()[name(.) = $xmltagtocopy]"/>
     </xsl:template>
    
    <xsl:template match="@*|node()">
        <xsl:value-of select="."/>
    </xsl:template>
</xsl:stylesheet>