<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    exclude-result-prefixes="xsl">
    <xsl:output method="xml" version="1.0"
        encoding="iso-8859-1" indent="yes" omit-xml-declaration="yes"/>
    
    <xsl:param name="suppliercontract.number" select="''"/>
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
                <bsvc:Get_Supplier_Contracts_Request>
                    <xsl:attribute name="bsvc:version">
                        <xsl:value-of select="$webservice.version"/>
                    </xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="string-length($suppliercontract.number) != 0">
                            <bsvc:Request_References>
                                <bsvc:Supplier_Contract_Reference>
                                    <bsvc:ID bsvc:type="Document_Number">
                                        <xsl:value-of select="$suppliercontract.number"/>
                                    </bsvc:ID>
                                </bsvc:Supplier_Contract_Reference>
                            </bsvc:Request_References>
                        </xsl:when>
                        <xsl:otherwise>
                            <bsvc:Request_Criteria>
                                <xsl:if test="string-length($webservice.filterobject.4.wid) != 0
                                        and $webservice.filterobject.4.wid != 'no'">
                                    <xsl:for-each select="tokenize($webservice.filterobject.4.wid,',')">
                                        <xsl:if test="normalize-space(.) != 'no'">
                                            <bsvc:Company_Reference>
                                                <bsvc:ID bsvc:type="WID">
                                                    <xsl:value-of select="normalize-space(.)"/>
                                                </bsvc:ID>
                                            </bsvc:Company_Reference>
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:if>
                                <bsvc:Contract_Start_Date_On_or_Before>
                                    <xsl:value-of select="$webservice.startdate"/>
                                </bsvc:Contract_Start_Date_On_or_Before>
                                <bsvc:Contract_End_Date_On_or_After>
                                    <xsl:value-of select="$webservice.enddate"/>
                                </bsvc:Contract_End_Date_On_or_After>
                                <xsl:if test="string-length($webservice.filterobject.5.wid) != 0
                                        and $webservice.filterobject.5.wid != 'no'">
                                    <xsl:for-each select="tokenize($webservice.filterobject.5.wid,',')">
                                        <xsl:if test="normalize-space(.) != 'no'">
                                            <bsvc:Contract_Type_Reference>
                                                <bsvc:ID bsvc:type="WID">
                                                    <xsl:value-of select="normalize-space(.)"/>
                                                </bsvc:ID>
                                            </bsvc:Contract_Type_Reference>
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
                    </bsvc:Response_Group>
                </bsvc:Get_Supplier_Contracts_Request>
            </soapenv:Body>
        </soapenv:Envelope>
    </xsl:template>
</xsl:stylesheet>