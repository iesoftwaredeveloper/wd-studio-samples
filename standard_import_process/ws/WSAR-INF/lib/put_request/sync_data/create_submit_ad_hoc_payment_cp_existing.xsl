<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fhcpd="https://github.com/firehawk-consulting/firehawk/schemas/generic_payment_data.xsd"
    xmlns:wd="urn:com.workday/bsvc"
    xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"
    xmlns:intsys="java:com.workday.esb.intsys.xpath.ParsedIntegrationSystemFunctions"
    exclude-result-prefixes="xs env fhcpd xsl intsys"
    version="2.0">

    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" version="1.0" indent="yes"/>

    <xsl:param name="web.service.add.only"/>
    <xsl:param name="web.service.auto.complete"/>
    <xsl:param name="web.service.version"/>
    <xsl:param name="web.service.submit"/>
    <xsl:param name="single.instance.update.1.wids" select="'INACTIVE'"/>
    <xsl:param name="single.instance.update.2.wids" select="'INACTIVE'"/>
    <xsl:param name="single.instance.update.3.wids" select="'INACTIVE'"/>
    <xsl:param name="business.process.defaultcomment"/>
    <xsl:variable name="adhocpayment.filedata" select="document('mctx:vars/filedetails.xml')"/>
    
    <xsl:function name="fhcpd:getRegionValue">
        <xsl:param name="BUName"/>
        <xsl:param name="BUID"/>
        <xsl:choose>
            <xsl:when test="$BUID = '50160'">
                <xsl:value-of select="'38015'"/>
            </xsl:when>
            <xsl:when test="contains(lower-case($BUName),'zzz')">
                <xsl:value-of select="'00'"/>
                <xsl:value-of select="substring($BUID,3,3)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="substring-before($BUID,'_INACTIVE')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <xsl:template match="/">
        <xsl:apply-templates select="//wd:Ad_hoc_Payment_Data" mode="#default"/>
    </xsl:template>

    <xsl:template match="wd:Ad_hoc_Payment_Data" mode="#default">
        <consolidated_wrap>
            <xsl:if test="xs:boolean($web.service.add.only) = false()">
                <env:Envelope xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"
                    xmlns:wd="urn:com.workday/bsvc">
                    <env:Header/>
                    <env:Body>
                        <wd:Cancel_Ad_hoc_Payment_Request>
                            <xsl:attribute name="wd:version" select="$web.service.version"/>
                            <wd:Ad_hoc_Payment_Reference>
                                <wd:ID wd:type="Ad_hoc_Payment_Reference_ID">
                                    <xsl:value-of select="wd:Ad_hoc_Payment_ID"/>
                                </wd:ID>
                            </wd:Ad_hoc_Payment_Reference>
                            <wd:Void_Check>true</wd:Void_Check>
                            <wd:Reason_for_Cancel>
                                <xsl:value-of select="'Reissue Payment'"/>
                            </wd:Reason_for_Cancel>
                        </wd:Cancel_Ad_hoc_Payment_Request>
                    </env:Body>
                </env:Envelope>
            </xsl:if>
            <env:Envelope xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"
                xmlns:wd="urn:com.workday/bsvc">
                <env:Header/>
                <env:Body>
                    <wd:Submit_Ad_hoc_Payment_Request>
                        <xsl:attribute name="wd:version" select="$web.service.version"/>
                        <xsl:attribute name="wd:Add_Only">
                            <xsl:value-of select="$web.service.add.only"/>
                        </xsl:attribute>
                        <wd:Business_Process_Parameters>
                            <wd:Auto_Complete>
                                <xsl:choose>
                                    <xsl:when test="string-length($web.service.auto.complete) = 0">
                                        <xsl:value-of select="'0'"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="$web.service.auto.complete"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </wd:Auto_Complete>
                            <wd:Comment_Data>
                                <wd:Comment>
                                    <xsl:value-of select="$business.process.defaultcomment"/>
                                </wd:Comment>
                            </wd:Comment_Data>
                        </wd:Business_Process_Parameters>
                        <xsl:apply-templates select="." mode="header">
                            <xsl:with-param name="ad.hoc.payment.id" select="wd:Ad_hoc_Payment_ID"/>
                        </xsl:apply-templates>
                    </wd:Submit_Ad_hoc_Payment_Request>
                </env:Body>
            </env:Envelope>
        </consolidated_wrap>
    </xsl:template>

    <xsl:template match="wd:Ad_hoc_Payment_Data" mode="header">
        <xsl:param name="ad.hoc.payment.id"/>
        <wd:Ad_hoc_Payment_Data>
            <wd:Ad_hoc_Payment_ID>
                <xsl:value-of select="concat($ad.hoc.payment.id,'.reissue')"/>
            </wd:Ad_hoc_Payment_ID>
            <wd:Submit>
                <xsl:value-of select="$web.service.submit"/>
            </wd:Submit>
            <wd:Payment_Date>
                <xsl:value-of select="current-date()"/>
            </wd:Payment_Date>
            <xsl:apply-templates select="node()[not(self::wd:Submit)
                and not(self::wd:Payment_Date)
                and not(self::wd:Ad_hoc_Payment_ID)]">
                <xsl:with-param name="ad.hoc.payment.id" select="$ad.hoc.payment.id"/>
            </xsl:apply-templates>
        </wd:Ad_hoc_Payment_Data>
    </xsl:template>

    <xsl:template match="wd:Address_Data">
        <xsl:param name="ad.hoc.payment.id"/>
        <wd:Address_Data>
            <xsl:attribute name="wd:Effective_Date" select="current-date()"/>
            <xsl:attribute name="wd:Do_Not_Replace_All" select="false()"/>
            <xsl:apply-templates select="node()">
                <xsl:with-param name="ad.hoc.payment.id" select="$ad.hoc.payment.id"/>
            </xsl:apply-templates>
        </wd:Address_Data>
    </xsl:template>

    <xsl:template match="wd:Address_Line_Data">
        <xsl:param name="ad.hoc.payment.id"/>
        <xsl:variable name="address_type" select="@wd:Type"/>
        <wd:Address_Line_Data>
            <xsl:attribute name="wd:Type" select="$address_type"/>
            <xsl:choose>
                <xsl:when test="exists($adhocpayment.filedata//fhcpd:ad_hoc_payment[fhcpd:payment_reference_id=$ad.hoc.payment.id]/fhcpd:address_data)
                    and $address_type = 'ADDRESS_LINE_1'">
                    <xsl:value-of select="$adhocpayment.filedata//fhcpd:ad_hoc_payment[fhcpd:payment_reference_id=$ad.hoc.payment.id]/fhcpd:address_data/fhcpd:address_line_1"/>
                </xsl:when>
                <xsl:when test="exists($adhocpayment.filedata//fhcpd:ad_hoc_payment[fhcpd:payment_reference_id=$ad.hoc.payment.id]/fhcpd:address_data)
                    and $address_type = 'ADDRESS_LINE_2'">
                    <xsl:value-of select="$adhocpayment.filedata//fhcpd:ad_hoc_payment[fhcpd:payment_reference_id=$ad.hoc.payment.id]/fhcpd:address_data/fhcpd:address_line_2"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </wd:Address_Line_Data>
    </xsl:template>

    <xsl:template match="wd:Postal_Code">
        <xsl:param name="ad.hoc.payment.id"/>
        <wd:Postal_Code>
            <xsl:choose>
                <xsl:when test="exists($adhocpayment.filedata//fhcpd:ad_hoc_payment[fhcpd:payment_reference_id=$ad.hoc.payment.id]/fhcpd:address_data)">
                    <xsl:value-of select="$adhocpayment.filedata//fhcpd:ad_hoc_payment[fhcpd:payment_reference_id=$ad.hoc.payment.id]/fhcpd:address_data/fhcpd:postal_code"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </wd:Postal_Code>
    </xsl:template>

    <xsl:template match="wd:Municipality">
        <xsl:param name="ad.hoc.payment.id"/>
        <wd:Municipality>
            <xsl:choose>
                <xsl:when test="exists($adhocpayment.filedata//fhcpd:ad_hoc_payment[fhcpd:payment_reference_id=$ad.hoc.payment.id]/fhcpd:address_data)">
                    <xsl:value-of select="$adhocpayment.filedata//fhcpd:ad_hoc_payment[fhcpd:payment_reference_id=$ad.hoc.payment.id]/fhcpd:address_data/fhcpd:city"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </wd:Municipality>
    </xsl:template>

    <xsl:template match="wd:Country_Region_Reference">
        <xsl:param name="ad.hoc.payment.id"/>
        <wd:Country_Region_Reference>
            <wd:ID wd:type="ISO_3166-2_Code">
            <xsl:choose>
                <xsl:when test="exists($adhocpayment.filedata//fhcpd:ad_hoc_payment[fhcpd:payment_reference_id=$ad.hoc.payment.id]/fhcpd:address_data)">
                    <xsl:value-of select="$adhocpayment.filedata//fhcpd:ad_hoc_payment[fhcpd:payment_reference_id=$ad.hoc.payment.id]/fhcpd:address_data/fhcpd:state"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="wd:ID[@wd:type='ISO_3166-2_Code']"/>
                </xsl:otherwise>
            </xsl:choose>
            </wd:ID>
        </wd:Country_Region_Reference>
    </xsl:template>

    <xsl:template match="wd:Worktags_Reference">
        <xsl:variable name="count_of_custom_org" select="count(.//wd:ID[@wd:type='Custom_Organization_Reference_ID'])"/>
        <wd:Worktags_Reference>
            <xsl:choose>
                <xsl:when test="$count_of_custom_org != 0">
                    <wd:ID wd:type="Organization_Reference_ID">
                        <xsl:value-of select="fhcpd:getRegionValue(@wd:Descriptor,wd:ID[@wd:type='Custom_Organization_Reference_ID'])"/>
                    </wd:ID>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="wd:ID"/>
                </xsl:otherwise>
            </xsl:choose>
        </wd:Worktags_Reference>
    </xsl:template>

    <xsl:template match="wd:Memo">
        <xsl:param name="ad.hoc.payment.id"/>
        <wd:Memo>
            <xsl:value-of select="'REISSUE CHECK: '"/>
            <xsl:value-of select="$adhocpayment.filedata//fhcpd:ad_hoc_payment[fhcpd:payment_reference_id=$ad.hoc.payment.id]/fhcpd:check_number"/>
           <!-- <xsl:value-of select="' - '"/>
            <xsl:value-of select="."/> -->
        </wd:Memo>
    </xsl:template>

    <!-- Nodes to Remove -->
    <xsl:template match="wd:Supplier_Invoice_Line_ID"/>
    <xsl:template match="wd:Address_ID"/>

    <xsl:template match="@*|node()">
        <xsl:param name="ad.hoc.payment.id"/>
        <xsl:copy>
            <xsl:apply-templates select="@*|node()">
                <xsl:with-param name="ad.hoc.payment.id" select="$ad.hoc.payment.id"/>
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
