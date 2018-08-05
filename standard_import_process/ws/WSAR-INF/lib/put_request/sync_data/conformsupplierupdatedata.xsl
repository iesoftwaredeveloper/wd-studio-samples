<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tns="http://yourcompany.com/textschema/Accounting_Technology_Common/supplierdatatoupdate.xsd"
    exclude-result-prefixes="xs tns" version="2.0">

    <xsl:output method="xml" version="1.0" indent="yes"/>

    <xsl:template match="/">
        <supplierupdatefile>
            <xsl:for-each-group select="//supplier_updatedata" group-by="supplierid">
                <supplier_updatedata>
                    <xsl:attribute name="supplierid" select="current-grouping-key()"/>
                    <xsl:apply-templates select="current-group()"/>
                </supplier_updatedata>
            </xsl:for-each-group>
        </supplierupdatefile>
    </xsl:template>

    <xsl:template match="supplier_updatedata">
        <supplierdetaildata>
            <xsl:apply-templates/>
        </supplierdetaildata>
    </xsl:template>

    <xsl:template match="@*|node()">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>