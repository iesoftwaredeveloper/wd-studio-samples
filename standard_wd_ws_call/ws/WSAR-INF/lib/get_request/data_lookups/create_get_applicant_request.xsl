<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:bsvc="urn:com.workday/bsvc"
    xmlns:wd="urn:com.workday/bsvc"
    xmlns:intsys="java:com.workday.esb.intsys.xpath.ParsedIntegrationSystemFunctions"
    exclude-result-prefixes="xs intsys wd" version="2.0">
    <xsl:output method="xml" version="1.0" indent="yes" omit-xml-declaration="yes"/>
    
    <!-- Filter Parameters -->
    <xsl:param name="multi.instance.filter.1.wids"/>
    <xsl:param name="multi.instance.filter.2.wids"/>
    <xsl:param name="multi.instance.filter.3.wids"/>
    <xsl:param name="single.instance.filter.1.wids"/>
    <xsl:param name="single.instance.filter.2.wids"/>
    <xsl:param name="single.instance.filter.3.wids"/>
    <xsl:param name="candidate.id"/>
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
                <bsvc:Get_Applicants_Request>
                    <xsl:attribute name="bsvc:version" select="$web.service.version"/>
                    <bsvc:Request_References>
                        <bsvc:Applicant_Reference>
                            <bsvc:ID bsvc:type="Applicant_ID">
                                <xsl:value-of select="$candidate.id"/>
                            </bsvc:ID>
                        </bsvc:Applicant_Reference>
                    </bsvc:Request_References>
                    <bsvc:Response_Filter>
                        <bsvc:As_Of_Effective_Date>
                            <xsl:value-of select="$web.service.effective.date"/>
                        </bsvc:As_Of_Effective_Date>
                        <bsvc:Count>
                            <xsl:value-of select="$web.service.count"/>
                        </bsvc:Count>
                    </bsvc:Response_Filter>
                    <bsvc:Response_Group>
                        <bsvc:Include_Reference>true</bsvc:Include_Reference>
                        <bsvc:Include_Personal_Information>true</bsvc:Include_Personal_Information>
                        <bsvc:Include_Recruiting_Information>false</bsvc:Include_Recruiting_Information>
                        <bsvc:Include_Qualification_Profile>false</bsvc:Include_Qualification_Profile>
                        <bsvc:Include_Resume>false</bsvc:Include_Resume>
                        <bsvc:Include_Background_Check>false</bsvc:Include_Background_Check>
                        <bsvc:Include_External_Integration_ID_Data>true</bsvc:Include_External_Integration_ID_Data>
                    </bsvc:Response_Group>
                </bsvc:Get_Applicants_Request>
            </soapenv:Body>
        </soapenv:Envelope>
    </xsl:template>

</xsl:stylesheet>
