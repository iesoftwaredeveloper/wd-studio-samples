<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:bsvc="urn:com.workday/bsvc" xmlns:wd="urn:com.workday/bsvc" exclude-result-prefixes="xs" version="2.0">
    <xsl:output method="xml" version="1.0" encoding="iso-8859-1" indent="yes" omit-xml-declaration="yes"/>

    <xsl:param name="webservice.version"/>
    <xsl:param name="add.only"/>
    <xsl:param name="auto.complete"/>
    <xsl:param name="webservice.recordcount"/>
    <xsl:param name="businessprocess.defaultcomment"/>

    <xsl:template match="/">
        <xsl:apply-templates select=".//bsvc:Receipt"/>
    </xsl:template>

    <xsl:template match="bsvc:Receipt">
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:bsvc="urn:com.workday/bsvc">
            <soapenv:Header/>
            <soapenv:Body>
                <wd:Submit_Receipt_Request>
                    <xsl:attribute name="wd:version">
                        <xsl:value-of select="$webservice.version"/>
                    </xsl:attribute>
                    <xsl:attribute name="wd:Add_Only">
                        <xsl:choose>
                            <xsl:when test="string-length($add.only) = 0">
                                <xsl:value-of select="'1'"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$add.only"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:apply-templates select="ancestor-or-self::wd:Receipt_Reference"/>
                    <wd:Business_Process_Parameters>
                        <wd:Auto_Complete>
                            <xsl:choose>
                                <xsl:when test="string-length($auto.complete) = 0">
                                    <xsl:value-of select="'0'"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$auto.complete"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </wd:Auto_Complete>
                        <wd:Comment_Data>
                            <wd:Comment>
                                <xsl:value-of select="$businessprocess.defaultcomment"/>
                            </wd:Comment>
                        </wd:Comment_Data>
                    </wd:Business_Process_Parameters>
                    <xsl:apply-templates select=".//wd:Receipt_Data"/>
                </wd:Submit_Receipt_Request>
            </soapenv:Body>
        </soapenv:Envelope>
    </xsl:template>
    
    <xsl:template match="wd:Submit">
        <wd:Submit>1</wd:Submit>
    </xsl:template>
    
    <xsl:template match="wd:Receipt_Data">
        <wd:Receipt_Data>
            <wd:Submit>1</wd:Submit>
            <xsl:apply-templates/>
        </wd:Receipt_Data>
    </xsl:template>
    
    <xsl:template match="@*|node()">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
