<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:wd="urn:com.workday/bsvc"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output method="xml" version="1.0"
        encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
    
    <xsl:template match="/">
        <wd:response_data>
            <xsl:apply-templates select="//wd:Response_Data/wd:Worker"/>
        </wd:response_data>
    </xsl:template>
    
    <xsl:template match="wd:Worker">
        <wd:Worker>
            <xsl:apply-templates select=".//wd:Worker_Reference"/>
            <xsl:apply-templates select=".//wd:Address_Data[.//wd:Type_Data/wd:Type_Reference/@wd:Descriptor = 'Home']"/>
        </wd:Worker>
    </xsl:template>
    
    <xsl:template match="wd:Address_Data">
        <wd:Address_Data>
            <xsl:attribute name="address_type" select=".//wd:Type_Data/wd:Type_Reference/@wd:Descriptor"/>
            <xsl:attribute name="address_usage" select=".//wd:Use_For_Reference/@wd:Descriptor"/>
            <xsl:apply-templates select="wd:Address_Line_Data"/>
            <wd:full_address_line>
                <xsl:value-of select="wd:Address_Line_Data[@wd:Type = 'ADDRESS_LINE_1']"/>
                <xsl:value-of select="' '"/>
                <xsl:value-of select="wd:Address_Line_Data[@wd:Type = 'ADDRESS_LINE_2']"/>
            </wd:full_address_line>
            <wd:clean_address_line_1>
                <xsl:value-of select="translate(normalize-space(wd:Address_Line_Data[@wd:Type = 'ADDRESS_LINE_1']), '_','')"/>
            </wd:clean_address_line_1>
            <xsl:apply-templates select="wd:Municipality"/>
            <xsl:apply-templates select="wd:Country_Region_Reference"/>
            <xsl:apply-templates select="wd:Postal_Code"/>
            <xsl:apply-templates select="wd:Country_Reference"/>
        </wd:Address_Data>
    </xsl:template>
    
    <xsl:template match="@*|node()">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
