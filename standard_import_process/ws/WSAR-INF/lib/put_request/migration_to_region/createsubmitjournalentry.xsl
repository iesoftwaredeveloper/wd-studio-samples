<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:bsvc="urn:com.workday/bsvc"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    exclude-result-prefixes="xs xsl"
    version="2.0">

    <xsl:output indent="yes" method="xml"/>

    <xsl:template match="/">
        
        <env:Envelope xmlns:env="http://schemas.xmlsoap.org/soap/envelope/" xmlns:wd="urn:com.workday/bsvc">
            <env:Header/>
            <xsl:if test="count(//bsvc:Journal_Entry_Line_Replacement_Data) != 0">
                <env:Body>
                    <xsl:copy-of select="bsvc:Import_Accounting_Journal_Request"/>
                </env:Body>
            </xsl:if>
        </env:Envelope>
    </xsl:template>

</xsl:stylesheet>
