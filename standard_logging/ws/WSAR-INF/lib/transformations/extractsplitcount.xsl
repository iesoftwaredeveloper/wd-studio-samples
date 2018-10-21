<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output method="xml"/>
    <xsl:param name="xmlsplit_tag"/>
    <xsl:param name="xmlmatch_value" select="''"/>
    
    <xsl:template match="/">
        <nodecount>
            <xsl:choose>
                <xsl:when test="string-length($xmlmatch_value) = 0">
                    <xsl:value-of select="count(//node()[name(.)=$xmlsplit_tag])"/>    
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="count(//node()[name(.)=$xmlsplit_tag and . = $xmlmatch_value])"/>
                </xsl:otherwise>
            </xsl:choose>
        </nodecount>
    </xsl:template>

</xsl:stylesheet>