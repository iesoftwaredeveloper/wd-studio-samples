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
        <xsl:apply-templates select="//wd:Job_Requisition"/>
    </xsl:template>
    
    <xsl:template match="wd:Job_Requisition">
        <env:Envelope xmlns:env="http://schemas.xmlsoap.org/soap/envelope/" xmlns:wd="urn:com.workday/bsvc">
            <env:Header/>
            <env:Body>
                <bsvc:Edit_Job_Requisition_Request>
                    <xsl:attribute name="bsvc:version" select="$web.service.version"/>
                    <bsvc:Business_Process_Parameters>
                        <bsvc:Auto_Complete>
                            <xsl:value-of select="$web.service.auto.complete"/>
                        </bsvc:Auto_Complete>
                        <bsvc:Run_Now>true</bsvc:Run_Now>
                    </bsvc:Business_Process_Parameters>
                    <bsvc:Edit_Job_Requisition_Data>
                        <xsl:copy-of select="bsvc:Job_Requisition_Reference"/>
                        <bsvc:Edit_Job_Requisition_Event_Data>
                            <bsvc:Edit_Job_Requisition_Reason_Reference>
                                <bsvc:ID bsvc:type="WID">
                                    <xsl:value-of select="$single.instance.update.1.wids"/>
                                </bsvc:ID>
                            </bsvc:Edit_Job_Requisition_Reason_Reference>
                            <bsvc:Job_Requisition_Data>
                                <xsl:apply-templates select=".//wd:Organization_Data"/>
                            </bsvc:Job_Requisition_Data>
                        </bsvc:Edit_Job_Requisition_Event_Data>
                    </bsvc:Edit_Job_Requisition_Data>
                </bsvc:Edit_Job_Requisition_Request>
            </env:Body>
        </env:Envelope>
    </xsl:template>

    <xsl:template match="wd:Organization_Data">
        <bsvc:Organization_Data>
            <xsl:attribute name="bsvc:Replace_All" select="true()"/>
            <xsl:attribute name="bsvc:Delete" select="false()"/>
            <xsl:apply-templates/>
        </bsvc:Organization_Data>
    </xsl:template>

    <xsl:template match="wd:Organization_Assignments_Data">
        <bsvc:Organization_Assignments_for_Job_Requisition_Data>
            <xsl:apply-templates/>
        </bsvc:Organization_Assignments_for_Job_Requisition_Data>
    </xsl:template>
    
    <xsl:template match="wd:Custom_Organization_Assignment_Reference">
        <bsvc:Region_Assignment_Reference>
                <bsvc:ID bsvc:type="Organization_Reference_ID">
                    <xsl:value-of select="substring-before(wd:ID[@wd:type = 'Organization_Reference_ID'],'_INACTIVE')"/>
                </bsvc:ID>
        </bsvc:Region_Assignment_Reference>
    </xsl:template>

    <xsl:template match="@*|node()">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
