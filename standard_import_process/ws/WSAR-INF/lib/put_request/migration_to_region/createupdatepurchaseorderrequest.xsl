<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tns="http://yourcompany.com/textschema/Accounting_Technology_Common/projectdatatoupdate.xsd"
    xmlns:wd="urn:com.workday/bsvc"
    xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"
    xmlns:intsys="java:com.workday.esb.intsys.xpath.ParsedIntegrationSystemFunctions"
    exclude-result-prefixes="xs env tns xsl intsys"
    version="2.0">

    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" version="1.0" indent="yes"/>

    <xsl:param name="web.service.version"/>
    <xsl:param name="web.service.add.only"/>
    <xsl:param name="web.service.auto.complete"/>
    <xsl:param name="business.process.defaultcomment"/>

    <xsl:template match="/">
        <xsl:apply-templates select="//wd:Purchase_Order"/>
    </xsl:template>

    <xsl:template match="wd:Purchase_Order">
        <env:Envelope xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"
            xmlns:wd="urn:com.workday/bsvc">
            <env:Header/>
            <env:Body>
                <wd:Submit_Purchase_Order_Request>
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
                    <xsl:apply-templates select=".//wd:Purchase_Order_Data"/>
                </wd:Submit_Purchase_Order_Request>
            </env:Body>
        </env:Envelope>
    </xsl:template>

    <xsl:template match="wd:Submit">
        <wd:Submit>1</wd:Submit>
    </xsl:template>

    <xsl:template match="wd:Worktags_Reference">
        <wd:Intercompany_Affiliate_Reference>
            <wd:ID>
                <xsl:attribute name="wd:type" select="'Organization_Reference_ID'"/>
                <xsl:value-of select="replace(wd:ID[@wd:type='Organization_Reference_ID'],'_INACTIVE','')"/>
            </wd:ID>
        </wd:Intercompany_Affiliate_Reference>
    </xsl:template>

    <xsl:template match="wd:Purchase_Order_Data">
        <wd:Purchase_Order_Data>
            <wd:Submit>1</wd:Submit>
            <xsl:apply-templates/>
        </wd:Purchase_Order_Data>
    </xsl:template>

    <xsl:template match="wd:Purchase_Order_ID">
        <wd:Purchase_Order_ID>
            <xsl:value-of select="'REG-'"/>
            <xsl:value-of select="."/>
        </wd:Purchase_Order_ID>
    </xsl:template>

    <xsl:template match="wd:Document_Number">
        <wd:Document_Number>
            <xsl:value-of select="'REG-'"/>
            <xsl:value-of select="."/>
        </wd:Document_Number>
    </xsl:template>

    <xsl:template match="wd:Goods_Line_Data">
        <wd:Goods_Line_Replacement_Data>
            <xsl:apply-templates/>
        </wd:Goods_Line_Replacement_Data>
    </xsl:template>

    <xsl:template match="wd:Issue_Option_Reference">
        <wd:Issue_Option_Reference>
            <wd:ID wd:type="Purchase_Order_Issue_Option_ID">PRINT</wd:ID>
        </wd:Issue_Option_Reference>
    </xsl:template>

    <xsl:template match="wd:Purchase_Order_Document_Status_Reference"/>

    <xsl:template match="wd:Bill_To_Address_Data"/>

    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
