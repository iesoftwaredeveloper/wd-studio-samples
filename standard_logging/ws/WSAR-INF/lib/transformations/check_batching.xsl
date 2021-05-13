<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema">
    <xsl:param name="file.number.total"/>
    <xsl:param name="file.number.current"/>
    <xsl:param name="record.count.total"/>
    <xsl:param name="record.counter"/>
    <xsl:param name="web.service.calls.total"/>
    <xsl:param name="web.service.calls.counter"/>
    <xsl:param name="continue.loop"/>
    <xsl:param name="force-close"/>
    <xsl:variable name="linefeed"><xsl:text>&#xA;</xsl:text></xsl:variable>
    <xsl:variable name="carriagereturn"><xsl:text>&#13;</xsl:text></xsl:variable>
    <!--<xsl:param name="last.message"/>-->
    <xsl:template match="/">
        <xsl:variable name="last.message" select="blankxml"/>
        <output>
            <log_message>
                <xsl:value-of select="'File Number Total: '"/>
                <xsl:value-of select="$file.number.total"/>
                <xsl:value-of select="$linefeed"/>
                <xsl:value-of select="'File Number Current: '"/>
                <xsl:value-of select="$file.number.current"/>
                <xsl:value-of select="$linefeed"/>
                <xsl:value-of select="'Record Count Total: '"/>
                <xsl:value-of select="$record.count.total"/>
                <xsl:value-of select="$linefeed"/>
                <xsl:value-of select="'Record Counter: '"/>
                <xsl:value-of select="$record.counter"/>
                <xsl:value-of select="$linefeed"/>
                <xsl:value-of select="'Web Service Calls Count Total: '"/>
                <xsl:value-of select="$web.service.calls.total"/>
                <xsl:value-of select="$linefeed"/>
                <xsl:value-of select="'Web Service Calls Counter: '"/>
                <xsl:value-of select="$web.service.calls.counter"/>
                <xsl:value-of select="$linefeed"/>
                <xsl:value-of select="'Continue Loop'"/>
                <xsl:value-of select="$continue.loop"/>
            </log_message>
            <close_batch>
                <xsl:choose>
                    <xsl:when test="$force-close = 'yes'">
                        <xsl:value-of select="'true'"/>
                    </xsl:when>
                    <xsl:when test="($file.number.current = $file.number.total 
                        and ($record.counter = $record.count.total 
                            or ($record.count.total = -1 and xs:boolean($last.message))
                            and $web.service.calls.total = $web.service.calls.counter)
                            and $continue.loop = 'false')">
                        <xsl:value-of select="'true'"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="'false'"/>
                    </xsl:otherwise>
                </xsl:choose>
            </close_batch>
        </output>
    </xsl:template>
</xsl:stylesheet>
