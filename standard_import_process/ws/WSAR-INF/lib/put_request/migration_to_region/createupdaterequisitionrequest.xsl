<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:bsvc="urn:com.workday/bsvc"
    exclude-result-prefixes="xs" version="2.0">
    <xsl:output method="xml" version="1.0" encoding="iso-8859-1" indent="yes" omit-xml-declaration="yes"/>
    
    <xsl:param name="webservice.version"/>

    <xsl:template match="/">
        <xsl:apply-templates select=".//bsvc:Requisition[.//bsvc:Requisition_Document_Status_Reference/@bsvc:Descriptor='Draft']/bsvc:Requisition_Reference"/>
    </xsl:template>
    
    <xsl:template match="bsvc:Requisition_Reference">
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:bsvc="urn:com.workday/bsvc">
            <soapenv:Header/>
            <soapenv:Body>
                <bsvc:Cancel_Requisition_Request xmlns:bsvc="urn:com.workday/bsvc">
                    <xsl:attribute name="bsvc:version" select="$webservice.version"/>
                    <bsvc:Requisition_to_Cancel_Reference>
                        <bsvc:ID bsvc:type="WID">
                            <xsl:value-of select="bsvc:ID[@bsvc:type='WID']"/>
                        </bsvc:ID>
                    </bsvc:Requisition_to_Cancel_Reference>
                </bsvc:Cancel_Requisition_Request>
            </soapenv:Body>
        </soapenv:Envelope>
    </xsl:template>
    
</xsl:stylesheet>
