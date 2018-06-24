<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:bsvc="urn:com.workday/bsvc"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:wd="urn:com.workday/bsvc"
    exclude-result-prefixes="xs xsl"
    version="2.0">

    <xsl:output indent="yes" method="xml"/>

    <xsl:template match="/">
        <consolidate_data>
            <xsl:apply-templates select="//wd:Response_Data"/>
        </consolidate_data>
    </xsl:template>

    <xsl:template match="@*|node()">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
