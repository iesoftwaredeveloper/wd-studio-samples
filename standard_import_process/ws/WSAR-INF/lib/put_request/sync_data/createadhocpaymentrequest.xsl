<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ecmc="https://ecmc.org/ad_hoc_payment_format"
    xmlns:wd="urn:com.workday/bsvc"
    xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"
    xmlns:intsys="java:com.workday.esb.intsys.xpath.ParsedIntegrationSystemFunctions"
    exclude-result-prefixes="xs env ecmc xsl intsys"
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

    <xsl:template match="/">
        <xsl:apply-templates select="//ecmc:ad_hoc_payment" mode="#default"/>
    </xsl:template>

    <xsl:template match="ecmc:ad_hoc_payment" mode="#default">
        <env:Envelope xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"
            xmlns:wd="urn:com.workday/bsvc">
            <env:Header/>
            <env:Body>
                <wd:Submit_Ad_hoc_Payment_Request>
                    <xsl:attribute name="wd:version">
                        <xsl:value-of select="$web.service.version"/>
                    </xsl:attribute>
                    <xsl:attribute name="wd:Add_Only">
                        <xsl:choose>
                            <xsl:when test="string-length($web.service.add.only) = 0">
                                <xsl:value-of select="'1'"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$web.service.add.only"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:apply-templates select="ancestor-or-self::wd:Purchase_Order_Reference"/>
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
                    <xsl:apply-templates select="." mode="header"/>
                </wd:Submit_Ad_hoc_Payment_Request>
            </env:Body>
        </env:Envelope>
    </xsl:template>

    <xsl:template match="ecmc:ad_hoc_payment" mode="header">
        <wd:Ad_hoc_Payment_Data>
            <wd:Ad_hoc_Payment_ID>
                <xsl:value-of select="ecmc:ad_hoc_payment_id"/>
            </wd:Ad_hoc_Payment_ID>
            <wd:Submit>
                <xsl:value-of select="$web.service.submit"/>
            </wd:Submit>
            <wd:Company_Reference>
                <wd:ID wd:type="WID">
                    <xsl:value-of select="$single.instance.update.1.wids"/>
                </wd:ID>
            </wd:Company_Reference>
            <wd:Bank_Account_Reference>
                <wd:ID wd:type="WID">
                    <xsl:value-of select="$single.instance.update.2.wids"/>
                </wd:ID>
            </wd:Bank_Account_Reference>
            <wd:Currency_Reference>
                <wd:ID wd:type="WID">
                    <xsl:value-of select="$single.instance.update.3.wids"/>
                </wd:ID>
            </wd:Currency_Reference>
            <wd:Payment_Date>
                <xsl:value-of select="ecmc:payment_date"/>
            </wd:Payment_Date>
            <wd:Control_Total_Amount>
                <xsl:value-of select="ecmc:control_total_amount"/>
            </wd:Control_Total_Amount>
            <wd:Memo>
                <xsl:value-of select="ecmc:memo"/>
            </wd:Memo>
            <wd:Invoice_Line_Replacement_Data>
                <xsl:apply-templates select=".//ecmc:ad_hoc_payment_line"/>
            </wd:Invoice_Line_Replacement_Data>
        </wd:Ad_hoc_Payment_Data>
    </xsl:template>

    <xsl:template match="ecmc:ad_hoc_payment_line">
        <wd:Line_Order>
            <xsl:value-of select="ecmc:line_order"/>
        </wd:Line_Order>
        <wd:Intercompany_Affiliate_Reference>
            <wd:ID wd:type="Company_Reference_ID">
                <xsl:value-of select="ecmc:company_id"/>
            </wd:ID>
        </wd:Intercompany_Affiliate_Reference>
        <wd:Item_Description>
            <xsl:value-of select="ecmc:item_description"/>
        </wd:Item_Description>
    </xsl:template>

    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
