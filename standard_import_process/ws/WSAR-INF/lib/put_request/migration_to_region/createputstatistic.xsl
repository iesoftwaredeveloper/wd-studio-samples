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
    <xsl:param name="single.instance.update.2.wids"/>
    <xsl:param name="web.service.version"/>
    <xsl:param name="web.service.count"/>
    <xsl:param name="web.service.add.only"/>
    <xsl:param name="web.service.submit"/>
    <xsl:param name="web.service.auto.complete"/>
    <xsl:param name="disable.optional.worktag.balancing"/>
    <xsl:param name="web.service.lock.transaction"/>
    <xsl:param name="web.service.request.type" select="'default'"/>
    <xsl:param name="default.memo"/>

    <xsl:variable name="open.paren"><xsl:text>(</xsl:text></xsl:variable>
    
    <xsl:template match="/">
        <xsl:apply-templates select="//wd:Statistic"/>
    </xsl:template>
    
    <xsl:template match="wd:Statistic">
        <env:Envelope xmlns:env="http://schemas.xmlsoap.org/soap/envelope/" xmlns:wd="urn:com.workday/bsvc">
            <env:Header/>
            <env:Body>
                <bsvc:Put_Statistic_Request>
                    <xsl:attribute name="bsvc:version" select="$web.service.version"/>
                        <xsl:apply-templates>
                            <xsl:with-param name="definition.name" select="normalize-space(substring-before(wd:Statistic_Reference/@wd:Descriptor,$open.paren))"/>
                        </xsl:apply-templates>
                </bsvc:Put_Statistic_Request>
            </env:Body>
        </env:Envelope>
    </xsl:template>

    <xsl:template match="wd:Statistic_Values_Replacement_Data">
        <xsl:param name="definition.name"/>
        <wd:Statistic_Values_Replacement_Data>
            <xsl:apply-templates>
                <xsl:with-param name="definition.name" select="$definition.name"/>
            </xsl:apply-templates>
        </wd:Statistic_Values_Replacement_Data>
    </xsl:template>

    <xsl:template match="wd:Worktag_Reference">
        <xsl:param name="definition.name"/>
        <wd:Worktag_Reference>
            <xsl:copy-of select="wd:ID[@wd:type != 'WID']"/>
        </wd:Worktag_Reference>
        <xsl:if test="contains(wd:ID[@wd:type='Organization_Reference_ID'],'_INACTIVE')">
            <wd:Worktag_Reference>
                <wd:ID wd:type="Organization_Reference_ID">
                    <xsl:value-of select="substring-before(wd:ID[@wd:type = 'Organization_Reference_ID'],'_INACTIVE')"/>
                </wd:ID>
            </wd:Worktag_Reference>
        </xsl:if>
        <xsl:if test="$definition.name = 'Attrition' 
            or $definition.name = 'Starts'
            or $definition.name = 'Earn Outs'
            or $definition.name = 'Leads'
            or $definition.name = 'BOM Active'
            or $definition.name = 'Total Student Population'">
            <wd:Worktag_Reference>
                <wd:ID wd:type="WID">
                    <xsl:value-of select="$single.instance.update.2.wids"/>
                </wd:ID>
            </wd:Worktag_Reference>
        </xsl:if>
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
