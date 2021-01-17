<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:bsvc="urn:com.workday/bsvc"
    xmlns:fhcsi="https://github.com/firehawk-consulting/firehawk/schemas/financials/supplierinvoicedatastandard.xsd"
    exclude-result-prefixes="#all">
    <xsl:output method="xml" version="1.0" encoding="iso-8859-1" indent="yes" omit-xml-declaration="yes"/>

    <xsl:param name="purchaseorder.number" select="''"/>
    <xsl:param name="web.service.startdate"/>
    <xsl:param name="web.service.enddate"/>
    <xsl:param name="web.service.include.reference" select="false()"/>
    <xsl:param name="include.attachmentdata" select="false()"/>
    <xsl:param name="web.service.version"/>
    <xsl:param name="web.service.count"/>
    <xsl:param name="web.service.request.type" select="'default'"/>
    <xsl:param name="web.service.put.lookup.wd.data.request.type" select="'default'"/>

    <xsl:template match="/">
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" 
            xmlns:bsvc="urn:com.workday/bsvc">
            <soapenv:Header/>
            <soapenv:Body>
                <!-- <bsvc:Request> -->
                    <xsl:choose>
                        <xsl:when test="$web.service.put.lookup.wd.data.request.type = 'cXML_po'">
                            <xsl:call-template name="get_purchase_order">
                                <xsl:with-param name="po.number" select="//fhcsi:workday_po_number"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:when test="$web.service.request.type = 'default'">
                            <xsl:call-template name="get_purchase_order">
                                <xsl:with-param name="po.number" select="$purchaseorder.number"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:when test="$web.service.request.type = 'per_po'">
                            <xsl:call-template name="get_purchase_orders"/>
                        </xsl:when>
                    </xsl:choose>
                <!-- </bsvc:Request> -->
            </soapenv:Body>
        </soapenv:Envelope>
    </xsl:template>

    <xsl:template name="get_purchase_order">
        <xsl:param name="po.number"/>
        <bsvc:Get_Purchase_Orders_Request>
            <xsl:attribute name="bsvc:version">
                <xsl:value-of select="$web.service.version"/>
            </xsl:attribute>
            <xsl:choose>
                <xsl:when test="string-length($po.number) != 0">
                    <bsvc:Request_References>
                        <xsl:for-each select="tokenize($po.number, ',')">
                            <xsl:if test=". != 'POSB-'">
                                <bsvc:Purchase_Order_Reference>
                                    <bsvc:ID bsvc:type="Document_Number">
                                        <xsl:value-of select="normalize-space(.)"/>
                                    </bsvc:ID>
                                </bsvc:Purchase_Order_Reference>
                            </xsl:if>
                        </xsl:for-each>
                    </bsvc:Request_References>
                </xsl:when>
                <xsl:otherwise>
                    <bsvc:Request_Criteria>
                        <bsvc:Updated_From_Date>
                            <xsl:value-of select="$web.service.startdate"/>
                        </bsvc:Updated_From_Date>
                        <bsvc:Updated_To_Date>
                            <xsl:value-of select="$web.service.enddate"/>
                        </bsvc:Updated_To_Date>
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
                    <xsl:value-of select="$web.service.include.reference"/>
                </bsvc:Include_Reference>
                <bsvc:Include_Attachment_Data>
                    <xsl:value-of select="$include.attachmentdata"/>
                </bsvc:Include_Attachment_Data>
            </bsvc:Response_Group>
        </bsvc:Get_Purchase_Orders_Request>
    </xsl:template>
    
    <xsl:template name="get_purchase_orders">
        <xsl:for-each select="tokenize($purchaseorder.number, ',')">
            <xsl:if test=". != 'POSB-'">
                <bsvc:Get_Purchase_Orders_Request>
                    <xsl:attribute name="bsvc:version">
                        <xsl:value-of select="$web.service.version"/>
                    </xsl:attribute>
                    <bsvc:Request_References>
                        <bsvc:Purchase_Order_Reference>
                            <bsvc:ID bsvc:type="Document_Number">
                                <xsl:value-of select="normalize-space(.)"/>
                            </bsvc:ID>
                        </bsvc:Purchase_Order_Reference>
                    </bsvc:Request_References>
                    <bsvc:Response_Filter>
                        <bsvc:Count>
                            <xsl:value-of select="$web.service.count"/>
                        </bsvc:Count>
                    </bsvc:Response_Filter>
                    <bsvc:Response_Group>
                        <bsvc:Include_Reference>
                            <xsl:value-of select="$web.service.include.reference"/>
                        </bsvc:Include_Reference>
                        <bsvc:Include_Attachment_Data>
                            <xsl:value-of select="$include.attachmentdata"/>
                        </bsvc:Include_Attachment_Data>
                    </bsvc:Response_Group>
                </bsvc:Get_Purchase_Orders_Request>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>