<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:ns1="http://www.taleo.com/ws/integration/toolkit/2005/07"
    exclude-result-prefixes="ns1 xsd xsi"
    version="2.0">
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" version="1.0" indent="yes" omit-xml-declaration="yes"/>
    
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="@*|node()">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="ns1:field[@name='National_ID']"/>
    <xsl:template match="ns1:field[@name='Last_ProviderStatus']"/>
    <xsl:template match="ns1:field[@name='Last_Screening_Date']"/>
</xsl:stylesheet>