<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:wd="urn:com.workday/bsvc"
    xmlns:bsvc="urn:com.workday/bsvc"
    exclude-result-prefixes="xsl wd bsvc env" version="2.0">

    <xsl:output indent="yes" method="xml"/>
    
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
    <xsl:param name="web.service.lookup.request.type" select="'job_req_organization_list'"/>

    <xsl:template match="/">
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:bsvc="urn:com.workday/bsvc">
            <soapenv:Header>
                <wd:Workday_Common_Header>
                    <wd:Include_Reference_Descriptors_In_Response>
                        <xsl:value-of select="$web.service.include.descriptors"/>
                    </wd:Include_Reference_Descriptors_In_Response>
                </wd:Workday_Common_Header>
            </soapenv:Header>
            <soapenv:Body>
                <wd:Get_Organizations_Request>
                    <xsl:attribute name="wd:version" select="$web.service.version"/>
                    <xsl:choose>
                        <xsl:when test="$web.service.lookup.request.type = 'default'">
                            <wd:Request_Criteria>
                                <xsl:if test="$multi.instance.filter.1.wids != 'no'">
                                    <xsl:for-each select="tokenize($multi.instance.filter.1.wids, ',')">
                                        <wd:Organization_Type_Reference>
                                            <wd:ID wd:type="WID">
                                                <xsl:value-of select="normalize-space(.)"/>
                                            </wd:ID>
                                        </wd:Organization_Type_Reference>
                                    </xsl:for-each>
                                </xsl:if>
                                <xsl:if test="$single.instance.filter.1.wids != 'no'">
                                    <wd:Organization_Type_Reference>
                                        <wd:ID wd:type="WID">
                                            <xsl:value-of select="normalize-space(.)"/>
                                        </wd:ID>
                                    </wd:Organization_Type_Reference>
                                </xsl:if>
                                <wd:Include_Inactive>
                                    <xsl:value-of select="$include.inactive"/>
                                </wd:Include_Inactive>
                            </wd:Request_Criteria>
                        </xsl:when>
                        <xsl:when test="$web.service.lookup.request.type = 'job_req_organization_list'">
                            <wd:Request_References wd:Skip_Non_Existing_Instances="true">
                                <xsl:apply-templates select="//wd:Supervisory_Organization_Reference"/>
                                <!--<xsl:apply-templates select="//wd:Primary_Location_Reference"/>
                                <xsl:apply-templates select="//wd:Additional_Locations_Reference"/>-->
                            </wd:Request_References>
                        </xsl:when>
                    </xsl:choose>
                    <wd:Response_Filter>
                        <!-- <bsvc:As_Of_Effective_Date></bsvc:As_Of_Effective_Date>
                        <bsvc:As_Of_Entry_DateTime></bsvc:As_Of_Entry_DateTime> -->
                        <wd:Count>
                            <xsl:value-of select="$web.service.count"/>
                        </wd:Count>
                    </wd:Response_Filter>
                    <wd:Response_Group>
                        <wd:Include_Roles_Data>false</wd:Include_Roles_Data>
                        <wd:Include_Hierarchy_Data>false</wd:Include_Hierarchy_Data>
                        <wd:Include_Supervisory_Data>false</wd:Include_Supervisory_Data>
                        <wd:Include_Staffing_Restrictions_Data>false</wd:Include_Staffing_Restrictions_Data>
                    </wd:Response_Group>
                </wd:Get_Organizations_Request>
            </soapenv:Body>
        </soapenv:Envelope>
    </xsl:template>

    <xsl:template match="wd:Supervisory_Organization_Reference">
        <wd:Organization_Reference>
            <xsl:copy-of select="wd:ID" copy-namespaces="no"/>
        </wd:Organization_Reference>
    </xsl:template>

</xsl:stylesheet>
