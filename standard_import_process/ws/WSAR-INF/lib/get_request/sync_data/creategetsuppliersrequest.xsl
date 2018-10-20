<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:ecmc="https://ecmc.org/supplier_format"
    exclude-result-prefixes="ecmc"
    version="2.0">

    <xsl:param name="webservice.startdate"/>
    <xsl:param name="webservice.enddate"/>
    <xsl:param name="include.reference" select="false()"/>
    <xsl:param name="include.attachmentdata" select="false()"/>
    <xsl:param name="webservice.version"/>
    <xsl:param name="webservice.recordcount"/>
    <xsl:param name="single.instance.update.1.wid"/>
    <xsl:param name="single.instance.update.2.wid"/>
    <xsl:param name="single.instance.update.3.wid"/>
    <xsl:param name="multi.instance.update.1.wids"/>
    <xsl:param name="multi.instance.update.2.wids"/>
    <xsl:param name="multi.instance.update.3.wids"/>
    <xsl:param name="web.service.get.request.type" select="'default'"/>
    <xsl:param name="supplier.id"/>
    <xsl:variable name="supplier.data" select="document('mctx:vars/externalfile.data')"/>
    <xsl:variable name="lookup.data" select="document('mctx:vars/lookup.data')"/>

    <xsl:template match="/">
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:bsvc="urn:com.workday/bsvc">
            <soapenv:Header>
                <bsvc:Workday_Common_Header>
                    <bsvc:Include_Reference_Descriptors_In_Response>1</bsvc:Include_Reference_Descriptors_In_Response>
                </bsvc:Workday_Common_Header>
            </soapenv:Header>
            <soapenv:Body>
                <bsvc:Get_Suppliers_Request>
                    <xsl:attribute name="bsvc:version" select="$webservice.version"/>
                    <xsl:choose>
                        <xsl:when test="$web.service.get.request.type ='supplier_list'">
                            <bsvc:Request_References>
                                <xsl:for-each-group select="$supplier.data//ecmc:supplier_update_record" group-by="ecmc:supplier_id">
                                    <bsvc:Supplier_Reference>
                                        <bsvc:ID bsvc:type="Supplier_ID">
                                            <xsl:value-of select="current-grouping-key()"/>
                                        </bsvc:ID>
                                    </bsvc:Supplier_Reference>
                                </xsl:for-each-group>
                            </bsvc:Request_References>
                        </xsl:when>
                        <xsl:when test="$web.service.get.request.type ='lookup_list'">
                            <bsvc:Request_References>
                                <xsl:for-each-group select="$lookup.data//bsvc:Supplier_Data" group-by="bsvc:Supplier_ID">
                                    <bsvc:Supplier_Reference>
                                        <bsvc:ID bsvc:type="Supplier_ID">
                                            <xsl:value-of select="current-grouping-key()"/>
                                        </bsvc:ID>
                                    </bsvc:Supplier_Reference>
                                </xsl:for-each-group>
                            </bsvc:Request_References>
                        </xsl:when>
                        <xsl:when test="$web.service.get.request.type ='supplier_id'
                            or string-length(normalize-space($supplier.id)) &gt; 0">
                            <bsvc:Request_References>
                                 <bsvc:Supplier_Reference>
                                    <bsvc:ID bsvc:type="Supplier_ID">
                                        <xsl:value-of select="$supplier.id"/>
                                    </bsvc:ID>
                                </bsvc:Supplier_Reference>
                            </bsvc:Request_References>
                        </xsl:when>
                        <xsl:otherwise>
                            <bsvc:Request_Criteria>
                                <bsvc:Updated_From_Date>
                                    <xsl:value-of select="$webservice.startdate"/>
                                </bsvc:Updated_From_Date>
                                <bsvc:Updated_To_Date>
                                    <xsl:value-of select="$webservice.enddate"/>
                                </bsvc:Updated_To_Date>
                                <xsl:if test="string-length($multi.instance.update.1.wids) != 0
                                        and $multi.instance.update.1.wids != 'no'">
                                    <xsl:for-each select="tokenize($multi.instance.update.1.wids,',')">
                                        <xsl:if test="normalize-space(.) != 'no'">
                                            <bsvc:Supplier_Status_Reference>
                                                <bsvc:ID bsvc:type="WID">
                                                    <xsl:value-of select="normalize-space(.)"/>
                                                </bsvc:ID>
                                            </bsvc:Supplier_Status_Reference>
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:if>
                                <xsl:if test="string-length($multi.instance.update.2.wids) != 0
                                        and $multi.instance.update.2.wids != 'no'">
                                    <xsl:for-each select="tokenize($multi.instance.update.2.wids,',')">
                                        <xsl:if test="normalize-space(.) != 'no'">
                                            <bsvc:Supplier_Category_Reference>
                                                <bsvc:ID bsvc:type="WID">
                                                    <xsl:value-of select="normalize-space(.)"/>
                                                </bsvc:ID>
                                            </bsvc:Supplier_Category_Reference>
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:if>
                                <xsl:if test="string-length($multi.instance.update.3.wids) != 0
                                        and $multi.instance.update.3.wids != 'no'">
                                    <xsl:for-each select="tokenize($multi.instance.update.3.wids,',')">
                                        <xsl:if test="normalize-space(.) != 'no'">
                                            <bsvc:Supplier_Group_Reference>
                                                <bsvc:ID bsvc:type="WID">
                                                    <xsl:value-of select="normalize-space(.)"/>
                                                </bsvc:ID>
                                            </bsvc:Supplier_Group_Reference>
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:if>
                            </bsvc:Request_Criteria>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:variable name="recordcount">
                        <xsl:choose>
                            <xsl:when test="$web.service.get.request.type ='supplier_list'
                                and count($supplier.data//supplierid) &lt; 1000">
                                <xsl:value-of select="count($supplier.data//supplierid)"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$webservice.recordcount"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <bsvc:Response_Filter>
                        <bsvc:Count>
                            <xsl:value-of select="$recordcount"/>
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
                </bsvc:Get_Suppliers_Request>
            </soapenv:Body>
        </soapenv:Envelope>
    </xsl:template>
</xsl:stylesheet>
