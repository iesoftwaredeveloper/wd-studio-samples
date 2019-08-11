<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tfxc="https://github.com/firehawk-consulting/firehawk/schemas/text_to_xml/transform_file_to_xml_unparsed.xsd"
    xmlns:is="java:com.workday.esb.intsys.xpath.ParsedIntegrationSystemFunctions"
    xmlns:fhcf="https://github.com/firehawk-consulting/firehawk/schemas"
    xmlns:tv="java:com.workday.esb.intsys.TypedValue"
    exclude-result-prefixes="xsl fhcf tfxc is xs">
    <xsl:output method="xml" version="1.0"
        encoding="iso-8859-1" indent="yes" omit-xml-declaration="yes"/>

    <xsl:param name="document.number" select="''"/>
    <xsl:param name="webservice.filterobject.1.wid"/>
    <xsl:param name="webservice.filterobject.2.wid"/>
    <xsl:param name="webservice.filterobject.3.wid"/>
    <xsl:param name="webservice.filterobject.4.wid"/>
    <xsl:param name="webservice.filterobject.5.wid"/>
    <xsl:param name="webservice.filterobject.6.wid"/>
    <xsl:param name="web.service.startdate"/>
    <xsl:param name="web.service.enddate"/>
    <xsl:param name="web.service.include.reference" select="false()"/>
    <xsl:param name="include.attachmentdata" select="false()"/>
    <xsl:param name="web.service.version"/>
    <xsl:param name="web.service.count"/>
    <xsl:param name="web.service.request.type" select="'default'"/>
    
    <xsl:variable name="suppliercontract.list" select="document('mctx:vars/source.data')"/>
    
    <xsl:variable name="column_headers">
        <xsl:apply-templates select="$suppliercontract.list//tfxc:record[1]" mode="col_header"/>
    </xsl:variable>
    
    <xsl:template match="/">
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" 
            xmlns:bsvc="urn:com.workday/bsvc">
            <soapenv:Header/>
            <soapenv:Body>
                <bsvc:Get_Supplier_Contracts_Request>
                    <xsl:attribute name="bsvc:version">
                        <xsl:value-of select="$web.service.version"/>
                    </xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="string-length($document.number) != 0">
                            <bsvc:Request_References>
                                <bsvc:Supplier_Contract_Reference>
                                    <bsvc:ID bsvc:type="Supplier_Contract_ID">
                                        <xsl:value-of select="$document.number"/>
                                    </bsvc:ID>
                                </bsvc:Supplier_Contract_Reference>
                            </bsvc:Request_References>
                        </xsl:when>
                        <xsl:when test="$web.service.request.type = 'per_supplier_contract'">
                            <bsvc:Request_References>
                                <xsl:for-each select="distinct-values($suppliercontract.list//tfxc:record[position() != 1]//node()[name() != ''][fhcf:get-column-position('idnumber1')])">
                                    <xsl:if test="normalize-space(.) != ''">
                                        <bsvc:Supplier_Contract_Reference>
                                            <bsvc:ID bsvc:type="Supplier_Contract_ID">
                                                <xsl:value-of select="fhcf:ApplyReverseMap('Supplier Contract Lookup',normalize-space(.),'','Supplier_Contract_ID')"/>
                                            </bsvc:ID>
                                        </bsvc:Supplier_Contract_Reference>
                                    </xsl:if>
                                </xsl:for-each>
                            </bsvc:Request_References>
                        </xsl:when>
                        <xsl:when test="$web.service.request.type = 'per_supplier'">
                            <bsvc:Request_Criteria>
                                <xsl:for-each select="distinct-values($suppliercontract.list//tfxc:record[position() != 1]//node()[name() != ''][fhcf:get-column-position('idnumber1')])">
	                                <xsl:if test="normalize-space(.) != ''">
	                                   <bsvc:Supplier_Reference>
	                                       <bsvc:ID bsvc:type="Supplier_ID">
	                                            <xsl:value-of select="normalize-space(.)"/>
	                                       </bsvc:ID>
	                                   </bsvc:Supplier_Reference>
	                               </xsl:if>
                                </xsl:for-each>
                            </bsvc:Request_Criteria>
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
                                    <xsl:value-of select="$web.service.startdate"/>
                                </bsvc:Contract_Start_Date_On_or_Before>
                                <bsvc:Contract_End_Date_On_or_After>
                                    <xsl:value-of select="$web.service.enddate"/>
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
                            <xsl:value-of select="$web.service.count"/>
                        </bsvc:Count>
                    </bsvc:Response_Filter>
                    <bsvc:Response_Group>
                        <bsvc:Include_Reference>
                            <xsl:value-of select="$web.service.include.reference"/>
                        </bsvc:Include_Reference>
                    </bsvc:Response_Group>
                </bsvc:Get_Supplier_Contracts_Request>
            </soapenv:Body>
        </soapenv:Envelope>
    </xsl:template>
    
    <xsl:function name="fhcf:get-column-position" as="xs:integer">
        <xsl:param name="column_name_lkp"/>
        <xsl:variable name="column_exists" select="count($column_headers//node()[. = $column_name_lkp])"/>
        <xsl:choose>
            <xsl:when test="$column_exists = 0">
                <xsl:value-of select="0"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="count($column_headers//node()[. = $column_name_lkp]/preceding-sibling::node()) + 1"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <xsl:template match="tfxc:record" mode="col_header">
        <xsl:for-each select=".//node()[name() != '']">
            <xsl:variable name="temp_element" select="name()"/>
            <xsl:element name="{$temp_element}">
                <xsl:value-of select="lower-case(replace(replace(replace(., ' ', ''), '_', ''), '/', ''))"/>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>

    <xsl:function name="fhcf:ApplyReverseMap">
        <xsl:param name="mapName"/>
        <xsl:param name="externalValue"/>
        <xsl:param name="overrideExternalValue"/>
        <xsl:param name="referenceId"/>
        <xsl:variable name="lookup" select="is:integrationMapReverseLookup(string($mapName), string($externalValue))"/>
        <xsl:variable name="overrideLookup">
            <xsl:if test="string-length($overrideExternalValue) != 0">
                <xsl:value-of select="is:integrationMapReverseLookup(string($mapName), string($overrideExternalValue))"/>
            </xsl:if>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="string-length($overrideLookup) != 0">
                <xsl:value-of select="tv:getReferenceData($overrideLookup[1], string($referenceId))"/>
            </xsl:when>
            <xsl:when test="count($lookup) != 0">
                <xsl:value-of select="tv:getReferenceData($lookup[1], string($referenceId))"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$externalValue"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
</xsl:stylesheet>
