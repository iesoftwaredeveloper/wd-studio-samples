<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:bsvc="urn:com.workday/bsvc"
    xmlns:intsys="java:com.workday.esb.intsys.xpath.ParsedIntegrationSystemFunctions"
    exclude-result-prefixes="xs intsys" version="2.0">
    <xsl:output method="xml" version="1.0" indent="yes" omit-xml-declaration="yes"/>

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
    <xsl:param name="include.roles"/>
    <xsl:param name="include.organizations"/>

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
                <bsvc:Get_Job_Requisitions_Request>
                    <xsl:attribute name="bsvc:version" select="$web.service.version"/>
                    <bsvc:Request_Criteria>
                        <xsl:if test="$web.service.request.type = 'default'">
                            <xsl:if test="$multi.instance.filter.1.wids != 'no'">
                                <xsl:for-each select="tokenize($multi.instance.filter.1.wids,',')">
                                    <bsvc:Job_Requisition_Status_Reference>
                                        <bsvc:ID bsvc:type="WID">
                                            <xsl:value-of select="normalize-space(.)"/>
                                        </bsvc:ID>
                                    </bsvc:Job_Requisition_Status_Reference>
                                </xsl:for-each>
                            </xsl:if>
                        </xsl:if>
                    </bsvc:Request_Criteria>
                    <bsvc:Response_Filter>
                        <!--<xsl:if test="$webservice.requesttype = 'benefits_data'">
                                    <bsvc:As_Of_Effective_Date>
                                        <xsl:value-of select="$web.service.end.date"/>
                                    </bsvc:As_Of_Effective_Date>
                                </xsl:if>-->
                        <bsvc:Count>
                            <xsl:value-of select="$web.service.count"/>
                        </bsvc:Count>
                    </bsvc:Response_Filter>
                    <bsvc:Response_Group>
                        <bsvc:Include_Reference>
                            <xsl:value-of select="$web.service.include.reference"/>
                        </bsvc:Include_Reference>
                        <bsvc:Include_Job_Requisition_Definition_Data>true</bsvc:Include_Job_Requisition_Definition_Data>
                        <bsvc:Include_Job_Requisition_Restrictions_Data>false</bsvc:Include_Job_Requisition_Restrictions_Data>
                        <bsvc:Include_Qualifications>true</bsvc:Include_Qualifications>
                        <bsvc:Include_Job_Requisition_Attachments>false</bsvc:Include_Job_Requisition_Attachments>
                        <bsvc:Include_Organizations>
                            <xsl:value-of select="$include.organizations"/>
                        </bsvc:Include_Organizations>
                        <bsvc:Include_Roles>
                            <xsl:value-of select="$include.roles"/>
                        </bsvc:Include_Roles>
                    </bsvc:Response_Group>
                </bsvc:Get_Job_Requisitions_Request>
            </soapenv:Body>
        </soapenv:Envelope>
    </xsl:template>

</xsl:stylesheet>
