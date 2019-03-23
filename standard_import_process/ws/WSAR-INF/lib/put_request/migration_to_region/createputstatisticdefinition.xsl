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
    <xsl:param name="web.service.add.only"/>
    <xsl:param name="web.service.submit"/>
    <xsl:param name="web.service.auto.complete"/>
    <xsl:param name="disable.optional.worktag.balancing"/>
    <xsl:param name="web.service.lock.transaction"/>
    <xsl:param name="web.service.request.type" select="'default'"/>
    <xsl:param name="default.memo"/>

    <xsl:template match="/">
        <xsl:apply-templates select="//wd:Statistic_Definition"/>
    </xsl:template>

    <xsl:template match="wd:Statistic_Definition">
        <env:Envelope xmlns:env="http://schemas.xmlsoap.org/soap/envelope/" xmlns:wd="urn:com.workday/bsvc">
            <env:Header/>
            <env:Body>
                <bsvc:Put_Statistic_Definition_Request>
                    <xsl:attribute name="bsvc:version" select="$web.service.version"/>
                    <xsl:apply-templates/>
                </bsvc:Put_Statistic_Definition_Request>
            </env:Body>
        </env:Envelope>
    </xsl:template>

    <xsl:template match="wd:Statistic_Definition_Data">
        <wd:Statistic_Definition_Data>
            <xsl:apply-templates/>
        </wd:Statistic_Definition_Data>
    </xsl:template>

    <xsl:template match="wd:Required_Dimensions_Reference">
        <xsl:choose>
            <xsl:when test="wd:ID[@wd:type='WID'] = $single.instance.update.1.wids">
                <wd:Required_Dimensions_Reference>
                    <wd:ID wd:type="WID">
                        <xsl:value-of select="$single.instance.update.2.wids"/>
                    </wd:ID>
                </wd:Required_Dimensions_Reference>
            </xsl:when>
            <xsl:otherwise>
                <wd:Required_Dimensions_Reference>
                    <xsl:copy-of select="wd:ID[@wd:type = 'WID']"/>
                </wd:Required_Dimensions_Reference>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="wd:Statistic_Definition_Reference">
        <wd:Statistic_Definition_Reference>
            <wd:ID wd:type="Statistic_Definition_ID">
                <xsl:value-of select="concat(wd:ID[@wd:type='Statistic_Definition_ID'],'_PLAN')"/>
            </wd:ID>
        </wd:Statistic_Definition_Reference>
    </xsl:template>

    <xsl:template match="@*|node()">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
