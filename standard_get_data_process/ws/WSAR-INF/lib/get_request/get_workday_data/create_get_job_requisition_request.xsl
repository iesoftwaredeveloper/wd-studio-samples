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
    
    <xsl:param name="is.system.wid"/>
    
    <xsl:param name="job.req.include.definition.data"/>
    <xsl:param name="job.req.include.restrictions.data"/>
    <xsl:param name="job.req.include.qualifications"/>
    <xsl:param name="job.req.include.attachments"/>
    <xsl:param name="job.req.include.roles"/>
    <xsl:param name="job.req.include.organizations"/>

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
                        <xsl:if test="$web.service.request.type = 'transaction_log'">
                            <bsvc:Transaction_Log_Criteria_Data>
                                <bsvc:Transaction_Date_Range_Data>
                                    <bsvc:Updated_From>
                                        <xsl:value-of select="$web.service.start.date"/>
                                    </bsvc:Updated_From>
                                    <bsvc:Updated_Through>
                                        <xsl:value-of select="$web.service.end.date"/>
                                    </bsvc:Updated_Through>
                                    <!--<bsvc:Effective_From>2018-11-01T05:36:46+00:00</bsvc:Effective_From>
                                    <bsvc:Effective_Through>2013-05-22T01:02:49+00:00</bsvc:Effective_Through>-->
                                </bsvc:Transaction_Date_Range_Data>
                                <!--<bsvc:Transaction_Type_References>
                                    <bsvc:Transaction_Type_Reference bsvc:Descriptor="string">
                                        <bsvc:ID bsvc:type="string">string</bsvc:ID>
                                    </bsvc:Transaction_Type_Reference>
                                </bsvc:Transaction_Type_References>-->
                                <bsvc:Subscriber_Reference bsvc:Descriptor="string">
                                    <bsvc:ID bsvc:type="WID">
                                        <xsl:value-of select="$is.system.wid"/>
                                    </bsvc:ID>
                                </bsvc:Subscriber_Reference>
                            </bsvc:Transaction_Log_Criteria_Data>
                        </xsl:if>
                        <!--<bsvc:Job_Requisition_Status_Reference bsvc:Descriptor="string">
                            <bsvc:ID bsvc:type="string">string</bsvc:ID>
                        </bsvc:Job_Requisition_Status_Reference>
                        <bsvc:Supervisory_Organization_Reference bsvc:Descriptor="string">
                            <bsvc:ID bsvc:type="string">string</bsvc:ID>
                        </bsvc:Supervisory_Organization_Reference>
                        <bsvc:Field_And_Parameter_Criteria_Data>
                            <bsvc:Provider_Reference bsvc:Descriptor="string">
                                <bsvc:ID bsvc:type="string">string</bsvc:ID>
                            </bsvc:Provider_Reference>
                        </bsvc:Field_And_Parameter_Criteria_Data>
                        <bsvc:Primary_Location_Reference bsvc:Descriptor="string">
                            <bsvc:ID bsvc:type="string">string</bsvc:ID>
                        </bsvc:Primary_Location_Reference>
                        <bsvc:Additional_Locations_Reference bsvc:Descriptor="string">
                            <bsvc:ID bsvc:type="string">string</bsvc:ID>
                        </bsvc:Additional_Locations_Reference>-->
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
                        <bsvc:Include_Job_Requisition_Definition_Data>
                            <xsl:value-of select="$job.req.include.definition.data"/>
                        </bsvc:Include_Job_Requisition_Definition_Data>
                        <bsvc:Include_Job_Requisition_Restrictions_Data>
                            <xsl:value-of select="$job.req.include.restrictions.data"/>
                        </bsvc:Include_Job_Requisition_Restrictions_Data>
                        <bsvc:Include_Qualifications>
                            <xsl:value-of select="$job.req.include.qualifications"/>
                        </bsvc:Include_Qualifications>
                        <bsvc:Include_Job_Requisition_Attachments>
                            <xsl:value-of select="$job.req.include.attachments"/>
                        </bsvc:Include_Job_Requisition_Attachments>
                        <bsvc:Include_Organizations>
                            <xsl:value-of select="$job.req.include.organizations"/>
                        </bsvc:Include_Organizations>
                        <bsvc:Include_Roles>
                            <xsl:value-of select="$job.req.include.roles"/>
                        </bsvc:Include_Roles>
                    </bsvc:Response_Group>
                </bsvc:Get_Job_Requisitions_Request>
            </soapenv:Body>
        </soapenv:Envelope>
    </xsl:template>

</xsl:stylesheet>
