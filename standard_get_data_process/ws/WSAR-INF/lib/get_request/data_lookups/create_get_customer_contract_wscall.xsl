<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:wd="urn:com.workday/bsvc"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tfxc="https://github.com/firehawk-consulting/firehawk/schemas/text_to_xml/transform_file_to_xml_unparsed.xsd"
    exclude-result-prefixes="xs wd"
    version="2.0">

    <xsl:param name="web.service.start.date"/>
    <xsl:param name="web.service.end.date"/>
    <xsl:param name="web.service.include.descriptors"/>
    <xsl:param name="web.service.get.request.type" select="'default'"/>
    <xsl:param name="web.service.put.lookup.wd.data.request.type" select="'default'"/>
    <xsl:param name="include.reference" select="false()"/>
    <xsl:param name="include.originatingbankaccount" select="true()"/>
    <xsl:param name="include.payrollremittance" select="false()"/>
    <xsl:param name="include.paymentgroupdata" select="true()"/>
    <xsl:param name="multi.instance.filter.1.wids"/>
    <xsl:param name="multi.instance.filter.2.wids"/>
    <xsl:param name="multi.instance.filter.3.wids"/>
    <xsl:param name="single.instance.filter.1.wids"/>
    <xsl:param name="single.instance.filter.2.wids"/>
    <xsl:param name="single.instance.filter.3.wids"/>
    <xsl:param name="web.service.version"/>
    <xsl:param name="web.service.count"/>

    <xsl:variable name="source.data" select="document('mctx:vars/source.data')"/>

    <xsl:template match="/">
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
            xmlns:bsvc="urn:com.workday/bsvc">
            <soapenv:Header>
                <bsvc:Workday_Common_Header>
                    <bsvc:Include_Reference_Descriptors_In_Response>
                        <xsl:value-of select="$web.service.include.descriptors"/>
                    </bsvc:Include_Reference_Descriptors_In_Response>
                </bsvc:Workday_Common_Header>
            </soapenv:Header>
            <soapenv:Body>
                <bsvc:Get_Customer_Contracts_Request>
                    <xsl:attribute name="bsvc:version" select="$web.service.version"/>
                    <!-- <xsl:attribute name="web_service_version" select="$web.service.put.lookup.wd.data.request.type"/>
                    <xsl:attribute name="lookup_data_count" select="count($lookup.data//tfxc:col2)"/>-->
                    <xsl:if test="$web.service.put.lookup.wd.data.request.type = 'contract_list'">
                        <bsvc:Request_Criteria>
                            <xsl:for-each select="$source.data//C_WDContract">
                                <xsl:if test="string-length(normalize-space(.)) != 0 and normalize-space(.) != 'null'">
                                        <bsvc:Customer_Contract_ID>
                                            <xsl:value-of select="normalize-space(.)"/>
                                        </bsvc:Customer_Contract_ID>
                                </xsl:if>
                            </xsl:for-each>
                        </bsvc:Request_Criteria>
                    </xsl:if>
                    <bsvc:Response_Filter>
                        <bsvc:Count>
                            <xsl:value-of select="$web.service.count"/>
                        </bsvc:Count>
                    </bsvc:Response_Filter>
                    <bsvc:Response_Group>
                        <bsvc:Include_Reference>
                            <xsl:value-of select="$include.reference"/>
                        </bsvc:Include_Reference>
                        <bsvc:Include_Customer_Contract_Data>true</bsvc:Include_Customer_Contract_Data>
                    </bsvc:Response_Group>
                </bsvc:Get_Customer_Contracts_Request>
            </soapenv:Body>
        </soapenv:Envelope>
    </xsl:template>
</xsl:stylesheet>
