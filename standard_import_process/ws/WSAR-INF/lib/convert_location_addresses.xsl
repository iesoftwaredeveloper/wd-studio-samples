<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:wd="urn:com.workday.report/Location_Directory"
    version="2.0">
    <xsl:output method="xml" version="1.0" indent="yes"/>
    
    <xsl:template match="/wd:Report_Data">
        <employees>
            <xsl:apply-templates select="wd:Report_Entry"/>
        </employees>
    </xsl:template>
    
    <xsl:template match="wd:Report_Entry">
        <employee>
            <employee_id>
                <xsl:value-of select="wd:Location/wd:ID[@wd:type='Location_ID']"/>
            </employee_id>
            <default_address>
                <xsl:call-template name="change-case">
                    <xsl:with-param name="text" select="normalize-space(wd:Primary_Address_-_Full)"/>
                    <xsl:with-param name="case" select="'u'"/>
                </xsl:call-template>
            </default_address>
        </employee>
    </xsl:template>
    
    <xsl:template name="change-case">
        <xsl:param name="text"/>
        <xsl:param name="case" select="'u'"/>
        <xsl:choose>
            <xsl:when test="translate(substring($case,1,1), 'U', 'u') = 'u'">
                <xsl:value-of select="translate($text,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
            </xsl:when>
            <xsl:when test="translate(substring($case,1,1), 'L', 'l') = 'l'">
                <xsl:value-of select="translate($text,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$text"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>