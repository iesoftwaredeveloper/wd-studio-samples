<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:bsvc="urn:com.workday/bsvc"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:je="urn:com.workday.report/Journal_Entry_Extract_for_Conversion"
    exclude-result-prefixes="xs je xsl"
    version="2.0">

    <xsl:output indent="yes" method="xml"/>

    <xsl:param name="running.process"/>
    <xsl:param name="multi.instance.update.1.wids"/>
    <xsl:param name="multi.instance.update.2.wids"/>
    <xsl:param name="multi.instance.update.3.wids"/>
    <xsl:param name="single.instance.update.1.wids"/>
    <xsl:param name="single.instance.update.2.wids"/>
    <xsl:param name="single.instance.update.3.wids"/>
    <xsl:param name="single.instance.update.1.name"/>
    <xsl:param name="single.instance.update.2.name"/>
    <xsl:param name="single.instance.update.3.name"/>
    <xsl:param name="web.service.version"/>
    <xsl:param name="web.service.count"/>
    <xsl:param name="web.service.add.only"/>
    <xsl:param name="web.service.submit"/>
    <xsl:param name="web.service.auto.complete"/>
    <xsl:param name="disable.optional.worktag.balancing" select="true()"/>
    <xsl:param name="web.service.lock.transaction"/>
    <xsl:param name="web.service.request.type" select="'default'"/>
    <xsl:param name="default.memo"/>

    <xsl:variable name="period-delim"><xsl:text>/</xsl:text></xsl:variable>
    <xsl:variable name="key-delim"><xsl:text>-</xsl:text></xsl:variable>

    <xsl:function name="je:forceValue">
        <xsl:param name="inputValue"/>
        <xsl:choose>
            <xsl:when test="$inputValue = ''">
                <xsl:value-of select="''"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$inputValue"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="je:getRegionValue">
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
        <consolidate_data>
            <xsl:apply-templates select="//je:Report_Data"/>
        </consolidate_data>
    </xsl:template>

    <xsl:template match="je:Report_Data">
        <xsl:for-each-group select="je:Report_Entry" group-by="je:Company">
            <xsl:for-each-group select="current-group()" group-by="je:forceValue(je:Period)">
                <xsl:for-each-group select="current-group()" group-by="je:forceValue(je:Book_Code/je:ID[@je:type='Book_Code_ID'])">
                    <xsl:variable name="book_code" select="je:Book_Code/je:ID[@je:type='Book_Code_ID']"/>
                    <xsl:variable name="period_end_date">
                        <xsl:value-of select="concat(substring(je:Period,7,4),'-',substring(je:Period,1,2),'-',substring(je:Period,4,2))"/>
                    </xsl:variable>
                    <journal_request>
                        <xsl:attribute name="journal_id">
                            <xsl:value-of select="je:Company/je:ID[@je:type = 'Organization_Reference_ID']"/>
                            <xsl:value-of select="'-'"/>
                            <xsl:value-of select="format-date(xs:date($period_end_date),'[Y0001][M01][D01]')"/>
                            <xsl:value-of select="'-'"/>
                            <xsl:value-of select="$book_code"/>
                            <xsl:if test="$running.process = 'Journal Entry Beginning Balances (2017)'">
                                <xsl:value-of select="'-begbal'"/>
                            </xsl:if>
                        </xsl:attribute>
                        <xsl:apply-templates select="current-group()"/>
                    </journal_request>
                </xsl:for-each-group>
            </xsl:for-each-group>
        </xsl:for-each-group>
    </xsl:template>

    <xsl:template match="je:Report_Entry">
        <journal_line>
            <xsl:attribute name="line_key">
                <xsl:value-of select="je:Account/je:ID[@je:type = 'Ledger_Account_ID']"/>
                <xsl:value-of select="$key-delim"/>
                <xsl:value-of select="je:Bank_Account/je:ID[@je:type = 'WID']"/>
                <xsl:value-of select="$key-delim"/>
                <xsl:value-of select="je:Cost_Center/je:ID[@je:type = 'Organization_Reference_ID']"/>
                <xsl:value-of select="$key-delim"/>
                <xsl:value-of select="je:Functional_Class/je:ID[@je:type = 'WID']"/>
                <xsl:value-of select="$key-delim"/>
                <xsl:value-of select="je:Intercompany_Affiliate/je:ID[@je:type = 'Organization_Reference_ID']"/>
                <xsl:value-of select="$key-delim"/>
                <xsl:value-of select="je:Project/je:ID[@je:type = 'Project_ID']"/>
                <xsl:value-of select="$key-delim"/>
                <xsl:value-of select="je:Region/je:ID[@je:type = 'Organization_Reference_ID']"/>
                <xsl:value-of select="$key-delim"/>
                <xsl:value-of select="je:Revenue_Category/je:ID[@je:type = 'Revenue_Category_ID']"/>
                <xsl:value-of select="$key-delim"/>
                <xsl:value-of select="je:Spend_Category/je:ID[@je:type = 'Spend_Category_ID']"/>
                <xsl:value-of select="$key-delim"/>
                <xsl:value-of select="je:Supplier/je:ID[@je:type = 'Supplier_ID']"/>
                <xsl:value-of select="$key-delim"/>
                <xsl:value-of select="je:Customer/je:ID[@je:type = 'Customer_ID']"/>
            </xsl:attribute>
            <credit_amount>
                <xsl:value-of select="xs:decimal(je:Credit_Amount)"/>
            </credit_amount>
            <debit_amount>
                <xsl:value-of select="xs:decimal(je:Debit_Amount)"/>
            </debit_amount>
        </journal_line>
    </xsl:template>

</xsl:stylesheet>
