<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:wd="urn:com.workday/bsvc"
    xmlns:bsvc="urn:com.workday/bsvc"
    xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"
    xmlns:fhc="http://firehawk.github.com"
    xmlns:intsys="java:com.workday.esb.intsys.xpath.ParsedIntegrationSystemFunctions"
    exclude-result-prefixes="xs env xsl intsys fhc"
    version="2.0">
    
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" version="1.0" indent="yes"/>
    <xsl:param name="single.instance.update.2.wids"/>
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

    <xsl:variable name="open.paren"><xsl:text>(</xsl:text></xsl:variable>

    <xsl:function name="fhc:getRegionValue">
        <xsl:param name="BUName"/>
        <xsl:param name="BUID"/>
        <xsl:choose>
            <xsl:when test="$BUID = '50160'">
                <xsl:value-of select="'38015'"/>
            </xsl:when>
            <xsl:when test="contains(lower-case($BUName),'zzz')">
                <xsl:value-of select="'00'"/>
                <xsl:value-of select="substring($BUID,3,3)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="substring-before($BUID,'_INACTIVE')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <xsl:template match="/">
        <xsl:apply-templates select="//wd:Asset"/>
    </xsl:template>
    
    <xsl:template match="wd:Asset">
        <env:Envelope xmlns:env="http://schemas.xmlsoap.org/soap/envelope/" xmlns:wd="urn:com.workday/bsvc">
            <env:Header/>
            <env:Body>
                <bsvc:Transfer_Asset_Request>
                    <xsl:attribute name="bsvc:version" select="$web.service.version"/>
                        <bsvc:Business_Process_Parameters>
                            <bsvc:Auto_Complete>
                                <xsl:value-of select="$web.service.auto.complete"/>
                            </bsvc:Auto_Complete>
                        </bsvc:Business_Process_Parameters>
                        <bsvc:Business_Asset_Reference>
                            <bsvc:ID bsvc:type="WID">
                                <xsl:value-of select="bsvc:Asset_Reference/bsvc:ID[@bsvc:type='WID']"/>
                            </bsvc:ID>
                        </bsvc:Business_Asset_Reference>
                        <xsl:apply-templates select=".//bsvc:Asset_Data"/>
                </bsvc:Transfer_Asset_Request>
            </env:Body>
        </env:Envelope>
    </xsl:template>

    <xsl:template match="wd:Asset_Data">
        <bsvc:Asset_Transfer_Data>
            <bsvc:Transfer_Date>
                <xsl:value-of select="$web.service.effective.date"/>
            </bsvc:Transfer_Date>
            <!--<bsvc:Transfer_To_Worker_Reference bsvc:Descriptor="string">
                <bsvc:ID bsvc:type="string">string</bsvc:ID>
            </bsvc:Transfer_To_Worker_Reference>
            <bsvc:Default_Location_and_Worktags_from_Worker>true</bsvc:Default_Location_and_Worktags_from_Worker>
            <bsvc:Transfer_To_Location_Reference bsvc:Descriptor="string">
                <bsvc:ID bsvc:type="string">string</bsvc:ID>
            </bsvc:Transfer_To_Location_Reference> -->
            <xsl:apply-templates select=".//bsvc:Acquisition_Data/bsvc:Worktag_Reference"/>
        </bsvc:Asset_Transfer_Data>
    </xsl:template>

    <xsl:template match="wd:Worktag_Reference">
        <xsl:choose>
            <xsl:when test="contains(wd:ID[@wd:type='Organization_Reference_ID'],'_INACTIVE')">
                <wd:Worktags_Reference>
                    <wd:ID wd:type="Organization_Reference_ID">
                        <xsl:value-of select="fhc:getRegionValue(@wd:Descriptor,wd:ID[@wd:type = 'Organization_Reference_ID'])"/>
                    </wd:ID>
                </wd:Worktags_Reference>
            </xsl:when>
            <xsl:otherwise>
                <bsvc:Worktags_Reference>
                    <xsl:copy-of select="bsvc:ID[@bsvc:type != 'WID']"/>
                </bsvc:Worktags_Reference>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="@*|node()">
        <xsl:param name="definition.name"/>
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*|node()">
                <xsl:with-param name="definition.name" select="$definition.name"/>
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
