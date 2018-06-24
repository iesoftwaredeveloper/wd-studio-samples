<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:bsvc="urn:com.workday/bsvc">

    <xsl:param name="multi.instance.filter.1.wids"/>
    <xsl:param name="multi.instance.filter.2.wids"/>
    <xsl:param name="multi.instance.filter.3.wids"/>
    <xsl:param name="single.instance.filter.1.wids"/>
    <xsl:param name="single.instance.filter.2.wids"/>
    <xsl:param name="single.instance.filter.3.wids"/>
    <xsl:param name="web.service.version"/>
    <xsl:param name="web.service.count"/>
    <xsl:param name="include.inactive"/>
    <xsl:param name="web.service.include.descriptors"/>
    <xsl:param name="web.service.request.type" select="'default'"/>

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
                <bsvc:Get_Organizations_Request>
                    <xsl:attribute name="bsvc:version" select="$web.service.version"/>
                    <bsvc:Request_Criteria>
                        <xsl:if test="$multi.instance.filter.1.wids != 'no'">
                            <xsl:for-each select="tokenize($multi.instance.filter.1.wids,',')">
                                <bsvc:Organization_Type_Reference>
                                    <bsvc:ID bsvc:type="WID">
                                        <xsl:value-of select="normalize-space(.)"/>
                                    </bsvc:ID>
                                </bsvc:Organization_Type_Reference>
                            </xsl:for-each>
                        </xsl:if>
                        <xsl:if test="$single.instance.filter.1.wids != 'no'">
                            <bsvc:Organization_Type_Reference>
                                <bsvc:ID bsvc:type="WID">
                                    <xsl:value-of select="normalize-space(.)"/>
                                </bsvc:ID>
                            </bsvc:Organization_Type_Reference>
                        </xsl:if>
                        <bsvc:Include_Inactive>
                            <xsl:value-of select="$include.inactive"/>
                        </bsvc:Include_Inactive>
                    </bsvc:Request_Criteria>
                    <bsvc:Response_Filter>
                        <!-- <bsvc:As_Of_Effective_Date></bsvc:As_Of_Effective_Date>
                        <bsvc:As_Of_Entry_DateTime></bsvc:As_Of_Entry_DateTime> -->
                        <bsvc:Count>
                            <xsl:value-of select="$web.service.count"/>
                        </bsvc:Count>
                    </bsvc:Response_Filter>
                    <bsvc:Response_Group>
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