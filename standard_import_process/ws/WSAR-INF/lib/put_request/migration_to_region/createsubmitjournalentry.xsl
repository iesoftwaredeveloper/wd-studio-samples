<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:bsvc="urn:com.workday/bsvc"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    exclude-result-prefixes="xs xsl"
    version="2.0">

    <xsl:output indent="yes" method="xml"/>

    <xsl:param name="web.service.version"/>
    <xsl:param name="web.service.count"/>
    <xsl:param name="web.service.add.only"/>
    <xsl:param name="web.service.submit"/>
    <xsl:param name="web.service.auto.complete"/>
    
    <xsl:template match="/">
        <consolidated_wrap>
        <env:Envelope xmlns:env="http://schemas.xmlsoap.org/soap/envelope/" xmlns:wd="urn:com.workday/bsvc">
            <env:Header/>
            <xsl:if test="count(//bsvc:Journal_Entry_Line_Replacement_Data) != 0">
                <env:Body>
                    <bsvc:Unpost-Reverse_Accounting_Journal_Request>
                        <xsl:attribute name="bsvc:version" select="$web.service.version"/>
                        <bsvc:Accounting_Journal_Reference>
                            <bsvc:ID bsvc:type="Accounting_Journal_ID">
                                <xsl:value-of select="bsvc:Import_Accounting_Journal_Request//bsvc:Accounting_Journal_ID"/>
                            </bsvc:ID>
                        </bsvc:Accounting_Journal_Reference>
                        <bsvc:Financials_Business_Process_Parameters>
                            <bsvc:Auto_Complete>
                                <xsl:value-of select="$web.service.auto.complete"/>
                            </bsvc:Auto_Complete>
                            <bsvc:Comment_Data>
                                <bsvc:Comment>
                                    <xsl:value-of select="'Reprocess Integration JE'"/>
                                </bsvc:Comment>
                            </bsvc:Comment_Data>
                        </bsvc:Financials_Business_Process_Parameters>
                    </bsvc:Unpost-Reverse_Accounting_Journal_Request>
                </env:Body>
            </xsl:if>
        </env:Envelope>

        <env:Envelope xmlns:env="http://schemas.xmlsoap.org/soap/envelope/" xmlns:wd="urn:com.workday/bsvc">
            <env:Header/>
            <xsl:if test="count(//bsvc:Journal_Entry_Line_Replacement_Data) != 0">
                <env:Body>
                    <xsl:copy-of select="bsvc:Import_Accounting_Journal_Request"/>
                </env:Body>
            </xsl:if>
        </env:Envelope>
        </consolidated_wrap>
    </xsl:template>

</xsl:stylesheet>
