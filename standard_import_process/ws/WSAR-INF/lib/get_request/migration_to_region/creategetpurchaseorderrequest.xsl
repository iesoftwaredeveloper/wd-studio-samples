<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    exclude-result-prefixes="xsl">
    <xsl:output method="xml" version="1.0"
        encoding="iso-8859-1" indent="yes" omit-xml-declaration="yes"/>
    
    <xsl:param name="purchaseorder.number" select="''"/>
    <xsl:param name="webservice.startdate"/>
    <xsl:param name="webservice.enddate"/>
    <xsl:param name="include.reference" select="false()"/>
    <xsl:param name="include.attachmentdata" select="false()"/>
    <xsl:param name="webservice.filterobject.1.wid"/>
    <xsl:param name="webservice.filterobject.2.wid"/>
    <xsl:param name="webservice.filterobject.3.wid"/>
    <xsl:param name="webservice.filterobject.4.wid"/>
    <xsl:param name="webservice.filterobject.5.wid"/>
    <xsl:param name="webservice.filterobject.6.wid"/>
    <xsl:param name="webservice.version"/>
    <xsl:param name="webservice.recordcount"/>
    
    <xsl:template match="/">
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" 
            xmlns:bsvc="urn:com.workday/bsvc">
            <soapenv:Header/>
            <soapenv:Body>
                <bsvc:Get_Purchase_Orders_Request>
                    <xsl:attribute name="bsvc:version">
                        <xsl:value-of select="$webservice.version"/>
                    </xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="string-length($purchaseorder.number) != 0">
                            <bsvc:Request_References>
                                <bsvc:Purchase_Order_Reference>
                                    <bsvc:ID bsvc:type="Document_Number">
                                        <xsl:value-of select="$purchaseorder.number"/>
                                    </bsvc:ID>
                                </bsvc:Purchase_Order_Reference>
                            </bsvc:Request_References>
                        </xsl:when>
                        <xsl:otherwise>
                            <bsvc:Request_Criteria>
                                <xsl:if test="string-length($webservice.filterobject.4.wid) != 0
                                        and $webservice.filterobject.4.wid != 'no'">
                                    <xsl:for-each select="tokenize($webservice.filterobject.4.wid,',')">
                                        <xsl:if test="normalize-space(.) != 'no'">
                                            <bsvc:Organization_Reference>
                                                <bsvc:ID bsvc:type="WID">
                                                    <xsl:value-of select="normalize-space(.)"/>
                                                </bsvc:ID>
                                            </bsvc:Organization_Reference>
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:if>
                                <xsl:if test="string-length($webservice.filterobject.6.wid) != 0
                                    and $webservice.filterobject.5.wid != 'no'">
                                    <xsl:for-each select="tokenize($webservice.filterobject.6.wid,',')">
                                        <xsl:if test="normalize-space(.) != 'no'">
                                            <bsvc:Supplier_Reference>
                                                <bsvc:ID bsvc:type="WID">
                                                    <xsl:value-of select="normalize-space(.)"/>
                                                </bsvc:ID>
                                            </bsvc:Supplier_Reference>
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:if>
                                <bsvc:Updated_From_Date>
                                    <xsl:value-of select="$webservice.startdate"/>
                                </bsvc:Updated_From_Date>
                                <bsvc:Updated_To_Date>
                                    <xsl:value-of select="$webservice.enddate"/>
                                </bsvc:Updated_To_Date>
                                <xsl:if test="string-length($webservice.filterobject.5.wid) != 0
                                        and $webservice.filterobject.5.wid != 'no'">
                                    <xsl:for-each select="tokenize($webservice.filterobject.5.wid,',')">
                                        <xsl:if test="normalize-space(.) != 'no'">
                                            <bsvc:Purchase_Order_Change_Type_Reference>
                                                <bsvc:ID bsvc:type="WID">
                                                    <xsl:value-of select="normalize-space(.)"/>
                                                </bsvc:ID>
                                            </bsvc:Purchase_Order_Change_Type_Reference>
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:if>
                            </bsvc:Request_Criteria>
                        </xsl:otherwise>
                    </xsl:choose>
                    <bsvc:Response_Filter>
                        <bsvc:Count>
                            <xsl:value-of select="$webservice.recordcount"/>
                        </bsvc:Count>
                    </bsvc:Response_Filter>
                    <bsvc:Response_Group>
                        <bsvc:Include_Reference>
                            <xsl:value-of select="$include.reference"/>
                        </bsvc:Include_Reference>
                        <bsvc:Include_Attachment_Data>
                            <xsl:value-of select="$include.attachmentdata"/>
                        </bsvc:Include_Attachment_Data>
                    </bsvc:Response_Group>
                </bsvc:Get_Purchase_Orders_Request>
            </soapenv:Body>
        </soapenv:Envelope>
    </xsl:template>
</xsl:stylesheet>