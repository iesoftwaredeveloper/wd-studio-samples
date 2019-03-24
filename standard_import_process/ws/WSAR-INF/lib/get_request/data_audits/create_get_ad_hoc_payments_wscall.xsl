<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:wd="urn:com.workday/bsvc"
    xmlns:fhcpd="https://github.com/firehawk-consulting/firehawk/schemas/generic_payment_data.xsd"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs wd fhcpd"
    version="2.0">

    <xsl:param name="web.service.start.date"/>
    <xsl:param name="web.service.end.date"/>
    <xsl:param name="web.service.include.descriptors"/>
    <xsl:param name="web.service.get.request.type" select="'default'"/>
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

    <xsl:variable name="lookup.data" select="document('mctx:vars/filedetails.xml')"/>

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
                <bsvc:Get_Ad_hoc_Payments_Request>
                    <xsl:attribute name="bsvc:version">
                        <xsl:value-of select="$web.service.version"/>
                    </xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="$web.service.get.request.type = 'payment_list'">
                            <bsvc:Request_References>
                                <xsl:for-each select="$lookup.data//fhcpd:payment_reference_id">
                                    <bsvc:Ad_hoc_Payment_Reference>
                                        <bsvc:ID>
                                            <xsl:attribute name="bsvc:type" select="@fhcpd:reference_id_type"/>
                                            <xsl:value-of select="normalize-space(.)"/>
                                        </bsvc:ID>
                                    </bsvc:Ad_hoc_Payment_Reference>
                                </xsl:for-each>
                            </bsvc:Request_References>
                        </xsl:when>
                        <xsl:otherwise>
                            <bsvc:Request_Criteria>
                                <xsl:choose>
                                    <xsl:when test="$web.service.get.request.type = 'default'">
                                        <xsl:if test="string-length($multi.instance.filter.2.wids) != 0
                                                and $multi.instance.filter.2.wids != 'no'">
                                            <xsl:for-each select="tokenize($multi.instance.filter.2.wids, ',')">
                                                <bsvc:Bank_Account_Reference>
                                                  <bsvc:ID bsvc:type="WID">
                                                  <xsl:value-of select="normalize-space(.)"/>
                                                  </bsvc:ID>
                                                </bsvc:Bank_Account_Reference>
                                            </xsl:for-each>
                                        </xsl:if>
                                        <bsvc:Payment_Date_on_Date_Or_After>
                                            <xsl:value-of select="$web.service.start.date"/>
                                        </bsvc:Payment_Date_on_Date_Or_After>
                                        <bsvc:Payment_Date_on_Date_Or_Before>
                                            <xsl:value-of select="$web.service.end.date"/>
                                        </bsvc:Payment_Date_on_Date_Or_Before>
                                        <bsvc:Payment_Amount_Greater_Than>0.001</bsvc:Payment_Amount_Greater_Than>
                                    </xsl:when>
                                    <xsl:when test="$web.service.get.request.type = 'supplier_payee_list'">
                                        <xsl:for-each select="$lookup.data//wd:Supplier_Data">
                                            <bsvc:Payee_Reference>
                                                <bsvc:ID bsvc:type="Supplier_ID">
                                                  <xsl:value-of select="wd:Supplier_ID"/>
                                                </bsvc:ID>
                                            </bsvc:Payee_Reference>
                                        </xsl:for-each>
                                        <bsvc:Payment_Date_on_Date_Or_After>
                                            <xsl:value-of select="$web.service.start.date"/>
                                        </bsvc:Payment_Date_on_Date_Or_After>
                                        <bsvc:Payment_Date_on_Date_Or_Before>
                                            <xsl:value-of select="$web.service.end.date"/>
                                        </bsvc:Payment_Date_on_Date_Or_Before>
                                    </xsl:when>
                                </xsl:choose>
                            </bsvc:Request_Criteria>
                        </xsl:otherwise>
                    </xsl:choose>
                    <bsvc:Response_Filter>
                        <bsvc:Count>
                            <xsl:value-of select="$web.service.count"/>
                        </bsvc:Count>
                    </bsvc:Response_Filter>
                    <bsvc:Response_Group>
                        <bsvc:Include_Reference>
                            <xsl:value-of select="$include.reference"/>
                        </bsvc:Include_Reference>
                    </bsvc:Response_Group>
                </bsvc:Get_Ad_hoc_Payments_Request>
            </soapenv:Body>
        </soapenv:Envelope>
    </xsl:template>
</xsl:stylesheet>
