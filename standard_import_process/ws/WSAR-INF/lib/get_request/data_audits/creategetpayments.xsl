<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:wd="urn:com.workday/bsvc"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs wd" version="2.0">

    <xsl:param name="web.service.start.date"/>
    <xsl:param name="web.service.end.date"/>
    <xsl:param name="web.service.include.descriptors"/>
    <xsl:param name="web.service.request.type" select="'default'"/>
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

    <xsl:variable name="lookup.data" select="document('mctx:vars/lookup.data')"/>

    <xsl:template match="/">
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:bsvc="urn:com.workday/bsvc">
            <soapenv:Header>
                <bsvc:Workday_Common_Header>
                    <bsvc:Include_Reference_Descriptors_In_Response>
                        <xsl:value-of select="$web.service.include.descriptors"/>
                    </bsvc:Include_Reference_Descriptors_In_Response>
                </bsvc:Workday_Common_Header>
            </soapenv:Header>
            <soapenv:Body>
                <bsvc:Get_Payments_Request>
                    <xsl:attribute name="bsvc:version">
                        <xsl:value-of select="$web.service.version"/>
                    </xsl:attribute>
                    <bsvc:Request_Criteria>
                        <xsl:choose>
                            <xsl:when test="$web.service.request.type = 'default'">
                                <bsvc:General_Payment_Criteria>
                                    <xsl:if test="string-length($multi.instance.filter.2.wids) != 0 and $multi.instance.filter.2.wids != 'no'">
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
                                    <xsl:if test="string-length($multi.instance.filter.1.wids) != 0 and $multi.instance.filter.1.wids != 'no'">
                                        <xsl:for-each select="tokenize($multi.instance.filter.1.wids, ',')">
                                            <bsvc:Payment_Type_Reference>
                                                <bsvc:ID bsvc:type="WID">
                                                    <xsl:value-of select="normalize-space(.)"/>
                                                </bsvc:ID>
                                            </bsvc:Payment_Type_Reference>
                                        </xsl:for-each>
                                    </xsl:if>
                                    <xsl:if test="string-length($single.instance.filter.2.wids) != 0 and $single.instance.filter.2.wids != 'no'">
                                        <bsvc:Payment_Status_Reference>
                                            <bsvc:ID bsvc:type="WID">
                                                <xsl:value-of select="$single.instance.filter.2.wids"/>
                                            </bsvc:ID>
                                        </bsvc:Payment_Status_Reference>
                                    </xsl:if>
                                    <xsl:if test="string-length($multi.instance.filter.3.wids) != 0 and $multi.instance.filter.3.wids != 'no'">
                                        <xsl:for-each select="tokenize($multi.instance.filter.3.wids, ',')">
                                            <bsvc:Payment_Category_Reference>
                                                <bsvc:ID bsvc:type="WID">
                                                    <xsl:value-of select="normalize-space(.)"/>
                                                </bsvc:ID>
                                            </bsvc:Payment_Category_Reference>
                                        </xsl:for-each>
                                    </xsl:if>
                                    <xsl:if test="string-length($single.instance.filter.1.wids) != 0 and $single.instance.filter.1.wids != 'no'">
                                        <bsvc:Reconciliation_Status_Reference>
                                            <bsvc:ID bsvc:type="WID">
                                                <xsl:value-of select="$single.instance.filter.1.wids"/>
                                            </bsvc:ID>
                                        </bsvc:Reconciliation_Status_Reference>
                                    </xsl:if>
                                    <bsvc:Payment_Amount_Greater_Than>0.001</bsvc:Payment_Amount_Greater_Than>
                                </bsvc:General_Payment_Criteria>
                            </xsl:when>
                            <xsl:when test="$web.service.request.type = 'remittance'">
                                <bsvc:Remittance_File_Criteria>
                                    <bsvc:Remittance_File_Reference>
                                        <bsvc:ID bsvc:type="WID">
                                            <xsl:value-of select="$single.instance.filter.3.wids"/>
                                        </bsvc:ID>
                                    </bsvc:Remittance_File_Reference>
                                </bsvc:Remittance_File_Criteria>
                            </xsl:when>
                            <xsl:when test="$web.service.request.type = 'supplier_payee_list'">
                                <bsvc:General_Payment_Criteria>
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
                                </bsvc:General_Payment_Criteria>
                            </xsl:when>
                        </xsl:choose>
                    </bsvc:Request_Criteria>
                    <bsvc:Response_Filter>
                        <bsvc:Count>
                            <xsl:value-of select="$web.service.count"/>
                        </bsvc:Count>
                    </bsvc:Response_Filter>
                    <bsvc:Response_Group>
                        <bsvc:Include_Reference>
                            <xsl:value-of select="$include.reference"/>
                        </bsvc:Include_Reference>
                        <bsvc:Include_Originating_Bank_Data>
                            <xsl:value-of select="$include.originatingbankaccount"/>
                        </bsvc:Include_Originating_Bank_Data>
                        <bsvc:Include_Payroll_Remittance_Data>
                            <xsl:value-of select="$include.payrollremittance"/>
                        </bsvc:Include_Payroll_Remittance_Data>
                        <bsvc:Include_Payment_Group_Data>
                            <xsl:value-of select="$include.paymentgroupdata"/>
                        </bsvc:Include_Payment_Group_Data>
                    </bsvc:Response_Group>
                </bsvc:Get_Payments_Request>
            </soapenv:Body>
        </soapenv:Envelope>
    </xsl:template>
</xsl:stylesheet>
