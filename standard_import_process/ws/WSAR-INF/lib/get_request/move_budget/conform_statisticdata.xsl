<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:sd="urn:com.workday.report/Statistic_Data_for_Headcount_Cost_of_Workforce"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output method="xml" version="1.0"
        encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
    
    <xsl:template match="/">
        <sd:response_data>
            <xsl:apply-templates select="//sd:Report_Data"/>
        </sd:response_data>
    </xsl:template>
    
    <xsl:template match="sd:Report_Data">
        <xsl:for-each-group select="sd:Report_Entry" group-by="sd:Company/sd:ID[@sd:type='Company_Reference_ID']">
            <sd:company_statistics>
                <xsl:attribute name="company_id" select="current-grouping-key()"/>
                <xsl:apply-templates select="current-group()"/>
            </sd:company_statistics>
        </xsl:for-each-group>
    </xsl:template>
    
    <xsl:template match="sd:Report_Entry">
        <sd:monthly_detail>
            <xsl:attribute name="month" select="upper-case(format-date(sd:Fiscal_Period_End_Date,'[MN,*-3]'))"/>
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
