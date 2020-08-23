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
    <xsl:param name="lkp.cost.center.id"/>
    
    <xsl:template match="/">
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:bsvc="urn:com.workday/bsvc">
            <soapenv:Header>
                <bsvc:Include_Reference_Descriptors_In_Response>
                    <xsl:value-of select="$web.service.include.descriptors"/>
                </bsvc:Include_Reference_Descriptors_In_Response>
            </soapenv:Header>
            <soapenv:Body>
                <bsvc:Get_Organizations_Request>
                    <xsl:attribute name="bsvc:version" select="$web.service.version"/>
                    <bsvc:Request_References>
                        <xsl:attribute name="bsvc:Skip_Non_Existing_Instances" select="1"/>
                        <bsvc:Organization_Reference>
                            <bsvc:ID bsvc:type="Organization_Reference_ID">
                                <xsl:value-of select="$lkp.cost.center.id"/>
                            </bsvc:ID>
                        </bsvc:Organization_Reference>
                    </bsvc:Request_References>
                    <bsvc:Response_Filter>
                        <bsvc:Count>
                            <xsl:value-of select="$web.service.count"/>
                        </bsvc:Count>
                    </bsvc:Response_Filter>
                    <bsvc:Response_Group>
                        <!--<bsvc:Include_Reference>
                            <xsl:value-of select="$web.service.include.reference"/>
                        </bsvc:Include_Reference>-->
                        <bsvc:Include_Roles_Data>false</bsvc:Include_Roles_Data>
                        <bsvc:Include_Hierarchy_Data>true</bsvc:Include_Hierarchy_Data>
                        <bsvc:Include_Supervisory_Data>false</bsvc:Include_Supervisory_Data>
                        <bsvc:Include_Staffing_Restrictions_Data>false</bsvc:Include_Staffing_Restrictions_Data>
                    </bsvc:Response_Group>
                </bsvc:Get_Organizations_Request>
            </soapenv:Body>
        </soapenv:Envelope>
    </xsl:template>
    
</xsl:stylesheet>
