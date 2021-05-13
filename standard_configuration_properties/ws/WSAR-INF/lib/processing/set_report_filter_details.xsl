<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:fhc="https://github.com/firehawk-consulting/firehawk/schemas/configuration_file_sync_data.xsd"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output indent="yes" omit-xml-declaration="no"/>

    <xsl:param name="web.service.start.date"/>
    <xsl:param name="web.service.end.date"/>
    <xsl:param name="lp.source.filter.wid"/>
    <xsl:param name="lp.source.structure.filter.wid"/>
    <xsl:param name="lp.period.filter.wid"/>
    <xsl:param name="lp.single.instance.filter.1.wids"/>
    <xsl:param name="lp.single.instance.filter.2.wids"/>
    <xsl:param name="lp.single.instance.filter.3.wids"/>
    <xsl:param name="lp.multi.instance.filter.1.wids"/>
    <xsl:param name="lp.multi.instance.filter.2.wids"/>
    <xsl:param name="lp.multi.instance.filter.3.wids"/>
    <xsl:param name="multi.instance.filter.1.wids"/>
    <xsl:param name="multi.instance.filter.2.wids"/>
    <xsl:param name="multi.instance.filter.3.wids"/>
    <xsl:param name="single.instance.filter.1.wids"/>
    <xsl:param name="single.instance.filter.2.wids"/>
    <xsl:param name="single.instance.filter.3.wids"/>

    <xsl:template match="/">
        <fhc:report_filters>
            <xsl:apply-templates select="//fhc:process//fhc:report_filters"/>
        </fhc:report_filters>
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
                    <xsl:when test="@fhc:filtername = 'lp_single_instance_1_wids'">
                        <xsl:value-of select="$lp.single.instance.filter.1.wids"/>
                    </xsl:when>
                    <xsl:when test="@fhc:filtername = 'lp_single_instance_2_wids'">
                        <xsl:value-of select="$lp.single.instance.filter.2.wids"/>
                    </xsl:when>
                    <xsl:when test="@fhc:filtername = 'lp_single_instance_3_wids'">
                        <xsl:value-of select="$lp.single.instance.filter.3.wids"/>
                    </xsl:when>
                    <xsl:when test="@fhc:filtername = 'lp_period_wid'">
                        <xsl:value-of select="$lp.period.filter.wid"/>
                    </xsl:when>
                    <xsl:when test="@fhc:filtername = 'lp_multi_instance_1_wids'">
                        <xsl:for-each select="tokenize($lp.multi.instance.filter.1.wids, ',')">
                            <xsl:value-of select="normalize-space(.)"/>
                            <xsl:value-of select="if (position() != last()) then '!' else ''"/>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="@fhc:filtername = 'lp_multi_instance_2_wids'">
                        <xsl:for-each select="tokenize($lp.multi.instance.filter.2.wids, ',')">
                            <xsl:value-of select="normalize-space(.)"/>
                            <xsl:value-of select="if (position() != last()) then '!' else ''"/>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="@fhc:filtername = 'lp_multi_instance_3_wids'">
                        <xsl:for-each select="tokenize($lp.multi.instance.filter.3.wids, ',')">
                            <xsl:value-of select="normalize-space(.)"/>
                            <xsl:value-of select="if (position() != last()) then '!' else ''"/>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="@fhc:filtername = 'multi_instance_filter_1_wids'">
                        <xsl:for-each select="tokenize($multi.instance.filter.1.wids, ',')">
                            <xsl:value-of select="normalize-space(.)"/>
                            <xsl:value-of select="if (position() != last()) then '!' else ''"/>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="@fhc:filtername = 'multi_instance_filter_2_wids'">
                        <xsl:for-each select="tokenize($multi.instance.filter.2.wids, ',')">
                            <xsl:value-of select="normalize-space(.)"/>
                            <xsl:value-of select="if (position() != last()) then '!' else ''"/>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="@fhc:filtername = 'multi_instance_filter_3_wids'">
                        <xsl:for-each select="tokenize($multi.instance.filter.3.wids, ',')">
                            <xsl:value-of select="normalize-space(.)"/>
                            <xsl:value-of select="if (position() != last()) then '!' else ''"/>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$single.instance.filter.1.wids"/>
                    </xsl:otherwise>
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
