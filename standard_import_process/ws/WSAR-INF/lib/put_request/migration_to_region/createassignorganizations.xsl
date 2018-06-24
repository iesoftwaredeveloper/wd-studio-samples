<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:wd="urn:com.workday/bsvc"
    xmlns:bsvc="urn:com.workday/bsvc"
    xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"
    xmlns:intsys="java:com.workday.esb.intsys.xpath.ParsedIntegrationSystemFunctions"
    exclude-result-prefixes="xs env xsl intsys"
    version="2.0">
    
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" version="1.0" indent="yes"/>
    <xsl:param name="web.service.version"/>
    <xsl:param name="web.service.count"/>
    <xsl:param name="web.service.add.only"/>
    <xsl:param name="web.service.submit"/>
    <xsl:param name="web.service.effective.date"/>
    <xsl:param name="web.service.auto.complete"/>
    <xsl:param name="disable.optional.worktag.balancing"/>
    <xsl:param name="web.service.lock.transaction"/>
    <xsl:param name="web.service.request.type" select="'default'"/>
    <xsl:param name="default.memo"/>
    
    <xsl:template match="/">
        <xsl:apply-templates select="//wd:Worker"/>
    </xsl:template>
    
    <xsl:template match="wd:Worker">
        <env:Envelope xmlns:env="http://schemas.xmlsoap.org/soap/envelope/" xmlns:wd="urn:com.workday/bsvc">
            <env:Header/>
            <env:Body>
                <bsvc:Assign_Organization_Request>
                    <xsl:attribute name="bsvc:version" select="$web.service.version"/>
                    <bsvc:Business_Process_Parameters>
                        <bsvc:Auto_Complete>
                            <xsl:value-of select="$web.service.auto.complete"/>
                        </bsvc:Auto_Complete>
                        <bsvc:Run_Now>true</bsvc:Run_Now>
                        <!--<bsvc:Comment_Data>
                            <bsvc:Comment>string</bsvc:Comment>
                            <bsvc:Worker_Reference bsvc:Descriptor="string">
                                <bsvc:ID bsvc:type="string">string</bsvc:ID>
                            </bsvc:Worker_Reference>
                        </bsvc:Comment_Data>-->
                    </bsvc:Business_Process_Parameters>
                    <bsvc:Assign_Organization_Data>
                        <xsl:attribute name="bsvc:As_Of_Effective_Date" select="$web.service.effective.date"/>
                        <xsl:apply-templates select=".//wd:Position_Data/wd:Position_Reference"/>
                        <xsl:apply-templates select="wd:Worker_Reference"/>
                        <xsl:apply-templates select=".//wd:Position_Organization_Data[wd:Organization_Data/wd:Used_in_Change_Organization_Assignments = 1]/wd:Organization_Reference"/>
                        <!--<bsvc:Check_Position_Budget_Sub_Process>
                            <bsvc:Business_Sub_Process_Parameters>
                                <bsvc:Skip>true</bsvc:Skip>
                                <bsvc:Business_Process_Comment_Data>
                                    <bsvc:Comment>string</bsvc:Comment>
                                    <bsvc:Worker_Reference bsvc:Descriptor="string">
                                        <bsvc:ID bsvc:type="string">string</bsvc:ID>
                                    </bsvc:Worker_Reference>
                                </bsvc:Business_Process_Comment_Data>
                            </bsvc:Business_Sub_Process_Parameters>
                        </bsvc:Check_Position_Budget_Sub_Process>-->
                    </bsvc:Assign_Organization_Data>
                </bsvc:Assign_Organization_Request>
            </env:Body>
        </env:Envelope>
    </xsl:template>

    <xsl:template match="wd:Organization_Reference">
        <bsvc:Organization_Reference>
            <bsvc:ID bsvc:type="Organization_Reference_ID">
                <xsl:value-of select="replace(upper-case(bsvc:ID[@bsvc:type = 'Organization_Reference_ID']),'_INACTIVE','')"/>
            </bsvc:ID>
        </bsvc:Organization_Reference>
    </xsl:template>

    <xsl:template match="@*|node()">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
