<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:bsvc="urn:com.workday/bsvc"
    xmlns:is="java:com.workday.esb.intsys.xpath.ParsedIntegrationSystemFunctions"
    xmlns:wd="urn:com.workday/bsvc">

    <xsl:param name="multi.instance.update.1.wids"/>
    <xsl:param name="multi.instance.update.2.wids"/>
    <xsl:param name="multi.instance.update.3.wids"/>
    <xsl:param name="single.instance.update.1.wids"/>
    <xsl:param name="single.instance.update.2.wids"/>
    <xsl:param name="single.instance.update.3.wids"/>
    <xsl:param name="single.instance.update.1.name"/>
    <xsl:param name="single.instance.update.2.name"/>
    <xsl:param name="single.instance.update.3.name"/>
    <xsl:param name="web.service.version"/>
    <xsl:param name="web.service.count"/>
    <xsl:param name="update.hierarchies"/>
    <xsl:param name="web.service.request.type" select="'default'"/>

    <xsl:template match="/">
        <xsl:apply-templates select="//wd:Organization_Data"/>
    </xsl:template>
    
    <xsl:template match="wd:Organization_Data">
        <env:Envelope xmlns:env="http://schemas.xmlsoap.org/soap/envelope/" xmlns:wd="urn:com.workday/bsvc">
            <env:Header/>
            <env:Body>
                <bsvc:Organization_Add_Update xmlns:bsvc="urn:com.workday/bsvc">
                    <xsl:attribute name="bsvc:version" select="$web.service.version"/>
                    <bsvc:Organization_Data>
                        <xsl:attribute name="bsvc:Effective_Date" select="current-date()"/>
                        <bsvc:Organization_Reference_ID>
                            <xsl:value-of select="substring-before(wd:Reference_ID,'_INACTIVE')"/>
                        </bsvc:Organization_Reference_ID>
                        <bsvc:Include_Organization_ID_in_Name>
                            <xsl:choose>
                                <xsl:when test="string-length(wd:Include_Organization_ID_in_Name) = 0">
                                    <xsl:value-of select="0"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="wd:Include_Organization_ID_in_Name"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </bsvc:Include_Organization_ID_in_Name>
                        <bsvc:Integration_ID_Data>
                            <bsvc:ID bsvc:System_ID="Workday">
                                <xsl:value-of select="substring-before(wd:Reference_ID,'_INACTIVE')"/>
                            </bsvc:ID>
                        </bsvc:Integration_ID_Data>
                        <bsvc:Organization_Name>
                            <xsl:value-of select="wd:Name"/>
                        </bsvc:Organization_Name>
                        <bsvc:Availability_Date>
                            <xsl:choose>
                                <xsl:when test="string-length(wd:Availibility_Date) = 0">
                                    <xsl:value-of select="1900-01-01"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="wd:Availibility_Date"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </bsvc:Availability_Date>
                        <bsvc:Include_Organization_Code_In_Name>
                            <xsl:choose>
                                <xsl:when test="string-length(wd:Include_Organization_Code_In_Name) = 0">
                                    <xsl:value-of select="0"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="wd:Include_Organization_Code_In_Name"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </bsvc:Include_Organization_Code_In_Name>
                        <bsvc:Organization_Code>
                            <xsl:value-of select="wd:Organization_Code"/>
                        </bsvc:Organization_Code>
                        <!-- <bsvc:Include_Leader_In_Name>
                            <xsl:value-of select="wd:Include_Leader_In_Name"/>
                        </bsvc:Include_Leader_In_Name> -->
                        <!-- <bsvc:Frozen_Status>false</bsvc:Frozen_Status>
                        <bsvc:Job_Management_Enabled>true</bsvc:Job_Management_Enabled>
                        <bsvc:Position_Management_Enabled>true</bsvc:Position_Management_Enabled> -->
                        <xsl:if test="$update.hierarchies = 'yes' and string-length(wd:Hierarchy_Data/wd:Superior_Organization_Reference) != 0">
                            <bsvc:Superior_Organization_Reference>
                                <bsvc:Organization_Reference>
                                    <bsvc:Integration_ID_Reference>
                                        <bsvc:ID bsvc:System_ID="Workday">
                                            <xsl:value-of select="substring-before(wd:Hierarchy_Data/wd:Superior_Organization_Reference/wd:ID[@wd:type='Organization_Reference_ID'],'_INACTIVE')"/>
                                        </bsvc:ID>
                                    </bsvc:Integration_ID_Reference>
                                </bsvc:Organization_Reference>
                            </bsvc:Superior_Organization_Reference>
                        </xsl:if>
                        <bsvc:Organization_Type_Reference>
                            <bsvc:Organization_Type_Name>
                                <xsl:value-of select="$single.instance.update.1.name"/>
                            </bsvc:Organization_Type_Name>
                        </bsvc:Organization_Type_Reference>
                        <bsvc:Organization_Subtype_Reference>
                            <bsvc:Organization_Subtype_Name>
                                <xsl:value-of select="is:getIntegrationMapValue('Organization Subtype Name Lookup', wd:Organization_Subtype_Reference/@wd:Descriptor)"/>
                            </bsvc:Organization_Subtype_Name>
                        </bsvc:Organization_Subtype_Reference>
                        <bsvc:Organization_Visibility_Reference>
                            <bsvc:Organization_Visibility_Name>Everyone</bsvc:Organization_Visibility_Name>
                        </bsvc:Organization_Visibility_Reference>
                        <!-- <bsvc:Primary_Business_Site_Reference>
                            <bsvc:Business_Site_Reference>
                                <bsvc:Integration_ID_Reference bsvc:Descriptor="string">
                                <bsvc:ID bsvc:System_ID="string">string</bsvc:ID>
                            </bsvc:Integration_ID_Reference>
                            </bsvc:Business_Site_Reference>
                        </bsvc:Primary_Business_Site_Reference> -->
                        <!-- <bsvc:Container_Organization_Reference>
                            <bsvc:Organization_Reference>
                                <bsvc:Integration_ID_Reference bsvc:Descriptor="string">
                                    <bsvc:ID bsvc:System_ID="string">string</bsvc:ID>
                                </bsvc:Integration_ID_Reference>
                            </bsvc:Organization_Reference>
                        </bsvc:Container_Organization_Reference> -->
                    </bsvc:Organization_Data>
                </bsvc:Organization_Add_Update>
            </env:Body>
        </env:Envelope>
    </xsl:template>
</xsl:stylesheet>
