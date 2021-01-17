<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:bsvc="urn:com.workday/bsvc" xmlns:wd="urn:com.workday/bsvc" xmlns:intsys="java:com.workday.esb.intsys.xpath.ParsedIntegrationSystemFunctions" exclude-result-prefixes="xs intsys wd" version="2.0">
    <xsl:output method="xml" version="1.0" indent="yes" omit-xml-declaration="yes"/>

    <!-- Filter Parameters -->
    <xsl:param name="multi.instance.filter.1.wids"/>
    <xsl:param name="multi.instance.filter.2.wids"/>
    <xsl:param name="multi.instance.filter.3.wids"/>
    <xsl:param name="single.instance.filter.1.wids"/>
    <xsl:param name="single.instance.filter.2.wids"/>
    <xsl:param name="single.instance.filter.3.wids"/>
    <xsl:param name="worker.id"/>
    <!-- Standard Web Service Parameters -->
    <xsl:param name="web.service.lookup.request.type"/>
    <xsl:param name="web.service.get.request.type"/>
    <xsl:param name="web.service.version"/>
    <xsl:param name="web.service.count"/>
    <xsl:param name="web.service.include.descriptors"/>
    <xsl:param name="web.service.include.reference"/>
    <xsl:param name="web.service.start.date"/>
    <xsl:param name="web.service.end.date"/>
    <xsl:param name="web.service.effective.date"/>
    <xsl:param name="is.system.wid"/>
    <xsl:param name="transaction.log.service.name"/>
    
    <xsl:variable name="ssn.data.check" select="document('mctx:vars/ssn.data.response.xml')"/>

    <xsl:template match="/">
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:bsvc="urn:com.workday/bsvc">
            <soapenv:Header>
                <bsvc:Workday_Common_Header>
                    <bsvc:Include_Reference_Descriptors_In_Response>
                        <xsl:value-of select="$web.service.include.descriptors"/>
                    </bsvc:Include_Reference_Descriptors_In_Response>
                </bsvc:Workday_Common_Header>
            </soapenv:Header>
            <soapenv:Body>
                <bsvc:Get_Former_Workers_Request>
                    <xsl:attribute name="bsvc:version" select="$web.service.version"/>
                    <xsl:choose>
                        <xsl:when test="$web.service.lookup.request.type = 'ssn'">
                            <bsvc:Request_Criteria>
                                <bsvc:National_ID_Criteria_Data>
                                    <bsvc:Identifier_ID>
                                        <xsl:value-of select="$ssn.data.check//ssn"/>
                                    </bsvc:Identifier_ID>
                                    <bsvc:Country_Reference>
                                        <bsvc:ID bsvc:type="ISO_3166-1_Alpha-3_Code">USA</bsvc:ID>
                                    </bsvc:Country_Reference>
                                </bsvc:National_ID_Criteria_Data>
                            </bsvc:Request_Criteria>
                        </xsl:when>
                        <xsl:otherwise>
                            <bsvc:Request_References>
                                <bsvc:Former_Worker_Reference>
                                    <bsvc:ID bsvc:type="Former_Worker_ID">
                                        <xsl:value-of select="normalize-space($worker.id)"/>
                                    </bsvc:ID>
                                </bsvc:Former_Worker_Reference>
                            </bsvc:Request_References>
                        </xsl:otherwise>
                    </xsl:choose>
                    <bsvc:Response_Filter>
                        <!--<bsvc:As_Of_Effective_Date>
                            <xsl:value-of select="$web.service.effective.date"/>
                        </bsvc:As_Of_Effective_Date>-->
                        <bsvc:Count>
                            <xsl:value-of select="$web.service.count"/>
                        </bsvc:Count>
                    </bsvc:Response_Filter>
                    <bsvc:Former_Worker_Response_Group>
                        <bsvc:Include_Former_Worker_Attachments>false</bsvc:Include_Former_Worker_Attachments>
                    </bsvc:Former_Worker_Response_Group>
                </bsvc:Get_Former_Workers_Request>
            </soapenv:Body>
        </soapenv:Envelope>
    </xsl:template>

</xsl:stylesheet>
