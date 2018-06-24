<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:wd="urn:com.workday/bsvc"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs wd" version="2.0">

    <xsl:param name="web.service.request.type" select="'default'"/>
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

    <xsl:template match="/">
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:bsvc="urn:com.workday/bsvc">
            <soapenv:Header/>
            <soapenv:Body>
                <bsvc:Get_Assets_Request>
                    <xsl:attribute name="bsvc:version">
                        <xsl:value-of select="$web.service.version"/>
                    </xsl:attribute>
                    <bsvc:Request_Criteria>
                        <xsl:if test="$multi.instance.filter.1.wids != 'no'">
                            <xsl:for-each select="tokenize($multi.instance.filter.1.wids,',')">
                                <bsvc:Asset_Status_Reference>
                                    <bsvc:ID bsvc:type="WID">
                                        <xsl:value-of select="normalize-space(.)"/>
                                    </bsvc:ID>
                                </bsvc:Asset_Status_Reference>
                            </xsl:for-each>
                        </xsl:if>
                    </bsvc:Request_Criteria>
                    <bsvc:Response_Filter>
                        <bsvc:Count>
                            <xsl:value-of select="$web.service.count"/>
                        </bsvc:Count>
                    </bsvc:Response_Filter>
                    <bsvc:Response_Group>
                        <bsvc:Include_Reference>
                            <xsl:value-of select="$web.service.include.reference"/>
                        </bsvc:Include_Reference>
                        <bsvc:Include_Custodian_Data>false</bsvc:Include_Custodian_Data>
                        <bsvc:Include_Depreciation_Data>false</bsvc:Include_Depreciation_Data>
                        <bsvc:Include_Depreciation_Detail_Data>false</bsvc:Include_Depreciation_Detail_Data>
                        <bsvc:Include_Disposal_Data>false</bsvc:Include_Disposal_Data>
                        <bsvc:Include_Intercompany_Transfer_Data>false</bsvc:Include_Intercompany_Transfer_Data>
                        <bsvc:Include_Impairment_Data>false</bsvc:Include_Impairment_Data>
                        <bsvc:Include_Reinstatement_Data>false</bsvc:Include_Reinstatement_Data>
                        <bsvc:Include_In_Service_Schedule_Data>false</bsvc:Include_In_Service_Schedule_Data>
                        <bsvc:Include_Cost_Adjustment_Data>false</bsvc:Include_Cost_Adjustment_Data>
                        <bsvc:Include_Attachment_Data>false</bsvc:Include_Attachment_Data>
                        <bsvc:Include_Reclassification_Data>false</bsvc:Include_Reclassification_Data>
                        <bsvc:Include_Removal_Data>false</bsvc:Include_Removal_Data>
                    </bsvc:Response_Group>
                </bsvc:Get_Assets_Request>
            </soapenv:Body>
        </soapenv:Envelope>
    </xsl:template>
</xsl:stylesheet>
