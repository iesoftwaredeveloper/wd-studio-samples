<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:fhc="https://github.com/firehawk-consulting/firehawk/schemas/configuration_file_sync_data.xsd" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output indent="yes" omit-xml-declaration="no"/>
    <xsl:param name="running.process"/>
    <xsl:param name="web.service.start.date"/>
    <xsl:param name="web.service.end.date"/>
    <xsl:param name="lp.source.filter.wid"/>
    <xsl:param name="lp.source.structure.filter.wid"/>
    <xsl:param name="lp.period.filter.wid"/>

    <xsl:template match="/">
        <xsl:apply-templates select="//fhc:process[@fhc:process_name = $running.process]"/>
    </xsl:template>

    <xsl:template match="fhc:report_filters">
        <fhc:report_filter>
            <xsl:for-each select="fhc:report_filter">
                <xsl:value-of select="if (position() = 1) then '?' else ''"/>
                <xsl:value-of select="."/>
                <xsl:choose>
                    <xsl:when test="@fhc:filtername = 'start_date'">
                        <xsl:value-of select="format-dateTime($web.service.start.date, '[Y0001]-[M01]-[D01]')"/>
                    </xsl:when>
                    <xsl:when test="@fhc:filtername = 'end_date'">
                        <xsl:value-of select="format-dateTime($web.service.end.date, '[Y0001]-[M01]-[D01]')"/>
                    </xsl:when>
                    <xsl:when test="@fhc:filtername = 'additional_options'">
                        <xsl:value-of select="'f6949d8151bb100018a5d49a49fc2463'"/>
                    </xsl:when>
                    <xsl:when test="@fhc:filtername = 'lp_source_wid'">
                        <xsl:for-each select="tokenize($lp.source.filter.wid, ',')">
                            <xsl:value-of select="normalize-space(.)"/>
                            <xsl:value-of select="if (position() != last()) then '!' else ''"/>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="@fhc:filtername = 'lp_source_plan_structure_wid'">
                        <xsl:value-of select="$lp.source.structure.filter.wid"/>
                    </xsl:when>
                    <xsl:when test="@fhc:filtername = 'lp_period_wid'">
                        <xsl:value-of select="$lp.period.filter.wid"/>
                    </xsl:when>
                </xsl:choose>
                <xsl:value-of select="if (position() != last()) then '&amp;' else ''"/>
            </xsl:for-each>
        </fhc:report_filter>
    </xsl:template>

    <xsl:template match="@* | node()">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
