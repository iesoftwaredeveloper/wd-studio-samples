<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:bsvc="urn:com.workday/bsvc"
    xmlns:wd="urn:com.workday/bsvc">
    <xsl:param name="web.service.version"/>
    
    <xsl:template match="/">
        <xsl:apply-templates select="//wd:Organization_Data"/>
    </xsl:template>
    
    <xsl:template match="wd:Organization_Data">
        <env:Envelope xmlns:env="http://schemas.xmlsoap.org/soap/envelope/" xmlns:wd="urn:com.workday/bsvc">
            <env:Header/>
            <env:Body>
                <bsvc:Put_Reference_Request xmlns:bsvc="urn:com.workday/bsvc">
                    <xsl:attribute name="bsvc:version" select="$web.service.version"/>
                    <bsvc:Reference_ID_Data>
                        <bsvc:ID>
                            <xsl:value-of select="wd:Reference_ID"/>
                        </bsvc:ID>
                        <bsvc:New_ID>
                            <xsl:choose>
                                <xsl:when test="contains(wd:Reference_ID,'_INACTIVE')">
                                    <xsl:value-of select="substring-before(wd:Reference_ID,'_INACTIVE')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="wd:Reference_ID"/>
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:value-of select="'_INACTIVE'"/>
                        </bsvc:New_ID>
                        <bsvc:Reference_ID_Type>
                            <xsl:value-of select="'Organization_Reference_ID'"/>
                        </bsvc:Reference_ID_Type>
                        <!-- <bsvc:Referenced_Object_Descriptor></bsvc:Referenced_Object_Descriptor> -->
                    </bsvc:Reference_ID_Data>
                </bsvc:Put_Reference_Request>
            </env:Body>
        </env:Envelope>
    </xsl:template>
</xsl:stylesheet>
