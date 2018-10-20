<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fhc="https://firehawk-consulting.com/data_lookups"
    xmlns:sd="urn:com.workday.report/Statistic_Data_for_Headcount_Cost_of_Workforce"
    exclude-result-prefixes="xs fhc"
    version="2.0">
    <xsl:output method="xml" version="1.0"
        encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>

    <xsl:function name="fhc:forceValue">
        <xsl:param name="inputValue"/>
        <xsl:choose>
            <xsl:when test="$inputValue = ''">
                <xsl:value-of select="' '"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$inputValue"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <xsl:function name="fhc:getCompanyValue">
        <xsl:param name="CompanyID"/>
        <xsl:param name="AllocationID"/>
        <xsl:choose>
            <xsl:when test="string-length(normalize-space(fhc:forceValue($AllocationID))) != 0">
                <xsl:value-of select="$AllocationID"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$CompanyID"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <xsl:template match="/">
        <sd:response_data>
            <xsl:apply-templates select="//sd:Report_Data"/>
        </sd:response_data>
    </xsl:template>
    
    <xsl:template match="sd:Report_Data">
        <xsl:for-each-group select="sd:Report_Entry" group-by="fhc:getCompanyValue(sd:Company/sd:ID[@sd:type='Company_Reference_ID'],fhc:forceValue(sd:allocation_only_group/sd:referenceID))">
            <sd:company_statistics>
                <xsl:attribute name="company_id" select="current-grouping-key()"/>
                <xsl:apply-templates select="current-group()">
                    <xsl:with-param name="cpny_lkp" select="sd:Company/sd:ID[@sd:type='Company_Reference_ID']"/>
                </xsl:apply-templates>
            </sd:company_statistics>
        </xsl:for-each-group>
    </xsl:template>
    
    <xsl:template match="sd:Report_Entry">
        <xsl:param name="cpny_lkp"/>
        <sd:monthly_detail>
            <xsl:attribute name="month" select="upper-case(format-date(sd:Fiscal_Period_End_Date,'[MN,*-3]'))"/>
            <xsl:attribute name="company_lkp" select="sd:Company/sd:ID[@sd:type='Company_Reference_ID']"/>
            <sd:type>
                <xsl:choose>
                    <xsl:when test="contains(sd:Statistic_Definition/@sd:Descriptor,'Percent')">
                        <xsl:value-of select="'percent_of_salary'"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="'amount_per_hc'"/>
                    </xsl:otherwise>
                </xsl:choose>
            </sd:type>
            <sd:cost_center>
                <xsl:if test="sd:Cost_Center/sd:ID[@sd:type='Organization_Reference_ID'] != '5000'">
                    <xsl:value-of select="sd:Cost_Center/sd:ID[@sd:type='Organization_Reference_ID']"/>
                </xsl:if>
            </sd:cost_center>
            <sd:spend_category>
                <xsl:value-of select="sd:Spend_Category/sd:ID[@sd:type='Spend_Category_ID']"/>
            </sd:spend_category>
            <sd:value>
                <xsl:value-of select="sd:Value"/>
            </sd:value>
        </sd:monthly_detail>
    </xsl:template>
    
    <xsl:template match="@*|node()">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
