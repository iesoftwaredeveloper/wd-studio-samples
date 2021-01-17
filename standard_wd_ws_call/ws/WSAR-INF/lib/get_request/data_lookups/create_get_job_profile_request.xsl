<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:bsvc="urn:com.workday/bsvc"
    xmlns:intsys="java:com.workday.esb.intsys.xpath.ParsedIntegrationSystemFunctions"
    exclude-result-prefixes="xs intsys" version="2.0">
    <xsl:output method="xml" version="1.0" indent="yes" omit-xml-declaration="yes"/>

    <xsl:param name="web.service.get.request.type"/>
    <xsl:param name="web.service.lookup.request.type"/>
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
    <xsl:param name="lkp.job.profile.id"/>

    <xsl:variable name="lookup.job.requisition.data" select="document('mctx:vars/lookup.job.req.response.xml')"/>

    <xsl:template match="/">
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:bsvc="urn:com.workday/bsvc">
            <soapenv:Header>
                <bsvc:Include_Reference_Descriptors_In_Response>
                    <xsl:value-of select="$web.service.include.descriptors"/>
                </bsvc:Include_Reference_Descriptors_In_Response>
            </soapenv:Header>
            <soapenv:Body>
                <bsvc:Get_Job_Profiles_Request>
                    <xsl:attribute name="bsvc:version" select="$web.service.version"/>
                    <bsvc:Request_References>
                        <xsl:attribute name="bsvc:Skip_Non_Existing_Instances" select="1"/>
                        <xsl:choose>
                            <xsl:when test="$web.service.lookup.request.type = 'job_requisition'">
                                <xsl:for-each select="$lookup.job.requisition.data//bsvc:Job_Profile_Reference">
                                    <bsvc:Job_Profile_Reference>
                                        <bsvc:ID bsvc:type="Job_Profile_ID">
                                            <xsl:value-of select="bsvc:ID[@bsvc:type='Job_Profile_ID']"/>
                                        </bsvc:ID>
                                    </bsvc:Job_Profile_Reference>
                                </xsl:for-each>
                                <xsl:for-each select="$lookup.job.requisition.data//bsvc:Additional_Job_Profiles_Reference">
                                    <bsvc:Job_Profile_Reference>
                                        <bsvc:ID bsvc:type="Job_Profile_ID">
                                            <xsl:value-of select="bsvc:ID[@bsvc:type='Job_Profile_ID']"/>
                                        </bsvc:ID>
                                    </bsvc:Job_Profile_Reference>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <bsvc:Job_Profile_Reference>
                                    <bsvc:ID bsvc:type="Job_Profile_ID">
                                        <xsl:value-of select="$lkp.job.profile.id"/>
                                    </bsvc:ID>
                                </bsvc:Job_Profile_Reference>
                            </xsl:otherwise>
                        </xsl:choose>
                    </bsvc:Request_References>
                    <bsvc:Response_Filter>
                        <bsvc:Count>
                            <xsl:value-of select="$web.service.count"/>
                        </bsvc:Count>
                    </bsvc:Response_Filter>
                    <bsvc:Response_Group>
                        <bsvc:Include_Reference>
                            <xsl:value-of select="$web.service.include.reference"/>
                        </bsvc:Include_Reference>
                        <bsvc:Include_Job_Profile_Basic_Data>true</bsvc:Include_Job_Profile_Basic_Data>
                        <bsvc:Include_Job_Classifications_Data>true</bsvc:Include_Job_Classifications_Data>
                        <bsvc:Include_Job_Profile_Pay_Rate_Data>true</bsvc:Include_Job_Profile_Pay_Rate_Data>
                        <bsvc:Include_Job_Profile_Exempt_Data>true</bsvc:Include_Job_Profile_Exempt_Data>
                        <bsvc:Include_Workers_Compensation_Data>false</bsvc:Include_Workers_Compensation_Data>
                        <bsvc:Include_Responsibility_Qualifications>true</bsvc:Include_Responsibility_Qualifications>
                        <bsvc:Include_Work_Experience_Qualifications>false</bsvc:Include_Work_Experience_Qualifications>
                        <bsvc:Include_Education_Qualifications>false</bsvc:Include_Education_Qualifications>
                        <bsvc:Include_Language_Qualifications>false</bsvc:Include_Language_Qualifications>
                        <bsvc:Include_Competency_Qualifications>false</bsvc:Include_Competency_Qualifications>
                        <bsvc:Include_Certification_Qualifications>false</bsvc:Include_Certification_Qualifications>
                        <bsvc:Include_Certification_Reference_Only>false</bsvc:Include_Certification_Reference_Only>
                        <bsvc:Include_Training_Qualifications>false</bsvc:Include_Training_Qualifications>
                        <bsvc:Include_Job_Profile_Compensation_Data>false</bsvc:Include_Job_Profile_Compensation_Data>
                        <bsvc:Include_Skill_Qualifications>false</bsvc:Include_Skill_Qualifications>
                    </bsvc:Response_Group>
                </bsvc:Get_Job_Profiles_Request>
            </soapenv:Body>
        </soapenv:Envelope>
    </xsl:template>

</xsl:stylesheet>
