<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:wd="urn:com.workday/bsvc"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs wd" version="2.0">

    <xsl:param name="web.service.request.type" select="'default'"/>
    <xsl:param name="multi.instance.filter.1.wids"/>
    <xsl:param name="multi.instance.filter.2.wids"/>
    <xsl:param name="multi.instance.filter.3.wids"/>
    <xsl:param name="single.instance.filter.1.wids"/>
    <xsl:param name="single.instance.filter.2.wids"/>
    <xsl:param name="single.instance.filter.3.wids"/>
    <xsl:param name="web.service.version"/>
    <xsl:param name="web.service.count"/>
    <xsl:param name="web.service.include.descriptors"/>
    <xsl:param name="web.service.include.reference"/>
    <xsl:param name="web.service.start.date"/>
    <xsl:param name="web.service.end.date"/>

    <xsl:template match="/">
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:bsvc="urn:com.workday/bsvc">
            <soapenv:Header/>
            <soapenv:Body>
                <bsvc:Get_Supplier_Invoices_Request>
                    <xsl:attribute name="bsvc:version">
                        <xsl:value-of select="$web.service.version"/>
                    </xsl:attribute>
                    <bsvc:Request_Criteria>
                        <xsl:choose>
                            <xsl:when test="$webservice.requesttype = 'supplier_payee_list'">
                                <bsvc:Invoice_Due_Date_On_or_After>
                                    <xsl:value-of select="$web.service.startdate"/>
                                </bsvc:Invoice_Due_Date_On_or_After>
                                <bsvc:Invoice_Due_Date_On_or_Before>
                                    <xsl:value-of select="$web.service.enddate"/>
                                </bsvc:Invoice_Due_Date_On_or_Before>
                            </xsl:when>
                        </xsl:choose>
                        <xsl:if test="$multi.instance.filter.1.wids != 'no'">
                            <xsl:for-each select="tokenize($multi.instance.filter.1.wids,',')">
                                <bsvc:Invoice_Status_Reference>
                                    <bsvc:ID bsvc:type="WID">
                                        <xsl:value-of select="normalize-space(.)"/>
                                    </bsvc:ID>
                                </bsvc:Invoice_Status_Reference>
                            </xsl:for-each>
                        </xsl:if>
                    </bsvc:Request_Criteria>
                    <bsvc:Response_Filter>
                        <bsvc:Count>
                            <xsl:value-of select="$web.service.count"/>
                        </bsvc:Count>
                    </bsvc:Response_Filter>
                    <bsvc:Response_Group>
                        <bsvc:Include_Reference>
                            <xsl:value-of select="$web.service.include.reference"/>
                        </bsvc:Include_Reference>
                    </bsvc:Response_Group>
                </bsvc:Get_Supplier_Invoices_Request>
            </soapenv:Body>
        </soapenv:Envelope>
    </xsl:template>
</xsl:stylesheet>
