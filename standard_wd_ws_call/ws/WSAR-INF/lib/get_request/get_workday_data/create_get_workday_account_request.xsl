<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:bsvc="urn:com.workday/bsvc"
    xmlns:wd="urn:com.workday/bsvc"
    xmlns:intsys="java:com.workday.esb.intsys.xpath.ParsedIntegrationSystemFunctions"
    exclude-result-prefixes="#all" version="2.0">
    <xsl:output method="xml" version="1.0" indent="yes" omit-xml-declaration="yes"/>
    
    <!-- Filter Parameters -->
    <xsl:param name="multi.instance.filter.1.wids"/>
    <xsl:param name="multi.instance.filter.2.wids"/>
    <xsl:param name="multi.instance.filter.3.wids"/>
    <xsl:param name="single.instance.filter.1.wids"/>
    <xsl:param name="single.instance.filter.2.wids"/>
    <xsl:param name="single.instance.filter.3.wids"/>
    <xsl:param name="lkp.worker.id"/>
    <xsl:param name="lkp.worker.type"/>
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
                <bsvc:Get_Workday_Account_Request>
                    <xsl:attribute name="bsvc:version" select="$web.service.version"/>
                    <bsvc:Request_References>
                        <xsl:choose>
                            <xsl:when test="$web.service.lookup.request.type = 'worker_response'">
                                <xsl:for-each select="//wd:User_Account_Data">
                                    <bsvc:Workday_Account_Reference>
                                        <bsvc:ID bsvc:type="WorkdayUserName">
                                            <xsl:value-of select="wd:User_Name"/>
                                        </bsvc:ID>
                                    </bsvc:Workday_Account_Reference>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:when test="$web.service.lookup.request.type = 'username_parameter'">
                                <bsvc:Workday_Account_Reference>
                                    <bsvc:ID>
                                        <xsl:attribute name="bsvc:type">
                                            <xsl:choose>
                                                <xsl:when test="lower-case($lkp.worker.type) = 'employee'">
                                                    <xsl:value-of select="'Employee_ID'"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="'Contingent_Worker_ID'"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:attribute>
                                        <xsl:value-of select="$lkp.worker.id"/>
                                    </bsvc:ID>
                                </bsvc:Workday_Account_Reference>
                            </xsl:when>
                        </xsl:choose>
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
                        <bsvc:Include_Reference>
                            <xsl:value-of select="$web.service.include.reference"/>
                        </bsvc:Include_Reference>
                    </bsvc:Response_Group>
                </bsvc:Get_Workday_Account_Request>
            </soapenv:Body>
        </soapenv:Envelope>
    </xsl:template>

</xsl:stylesheet>
