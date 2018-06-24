<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:wd="urn:com.workday.report/Supplier_Listing" version="2.0">
    
    <xsl:param name="page.current" select="1"/>
    <xsl:param name="lineending" select="'CRLF'"/>
    <xsl:variable name="linefeed">
        <xsl:text>&#xA;</xsl:text>
    </xsl:variable>
    <xsl:variable name="carriagereturn">
        <xsl:text>&#x0D;</xsl:text>
    </xsl:variable>
    <xsl:variable name="line_ending">
        <xsl:choose>
            <xsl:when test="$lineending = 'CRLF'">
                <xsl:value-of select="$carriagereturn"/>
                <xsl:value-of select="$linefeed"/>
            </xsl:when>
            <xsl:when test="$lineending = 'LFCR'">
                <xsl:value-of select="$linefeed"/>
                <xsl:value-of select="$carriagereturn"/>
            </xsl:when>
            <xsl:when test="$lineending = 'CR'">
                <xsl:value-of select="$carriagereturn"/>
            </xsl:when>
            <xsl:when test="$lineending = 'LF'">
                <xsl:value-of select="$linefeed"/>
            </xsl:when>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="delimiter">
        <xsl:text>&#x09;</xsl:text>
    </xsl:variable>
    <xsl:variable name="employee.data" select="document('mctx:vars/employee.data')"/>
    
    <xsl:output method="text" version="1.0" encoding="UTF-8" indent="yes"/>
    
    <xsl:template match="/">
        <xsl:if test="number($page.current) = 1">
            <xsl:call-template name="create_header_record"/>
        </xsl:if>
        <xsl:apply-templates select="wd:Report_Entry"/>
    </xsl:template>

    <xsl:template match="wd:Report_Entry">
        <xsl:variable name="defaultaddr">
            <xsl:choose>
                <xsl:when
                    test="contains(normalize-space(wd:DefaultAddress),'United States of America')">
                    <xsl:call-template name="change-case">
                        <xsl:with-param name="text"
                            select="substring-before(normalize-space(wd:DefaultAddress), 'United States of America')"/>
                        <xsl:with-param name="case" select="'u'"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="contains(normalize-space(wd:DefaultAddress),'Canada')">
                    <xsl:call-template name="change-case">
                        <xsl:with-param name="text"
                            select="substring-before(normalize-space(wd:DefaultAddress), 'Canada')"/>
                        <xsl:with-param name="case" select="'u'"/>
                    </xsl:call-template>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="remitaddr">
            <xsl:choose>
                <xsl:when
                    test="contains(normalize-space(wd:RemitAddress),'United States of America')">
                    <xsl:call-template name="change-case">
                        <xsl:with-param name="text"
                            select="substring-before(normalize-space(wd:RemitAddress), 'United States of America')"/>
                        <xsl:with-param name="case" select="'u'"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="contains(normalize-space(wd:RemitAddress),'Canada')">
                    <xsl:call-template name="change-case">
                        <xsl:with-param name="text"
                            select="substring-before(normalize-space(wd:RemitAddress), 'Canada')"/>
                        <xsl:with-param name="case" select="'u'"/>
                    </xsl:call-template>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>

        <xsl:if test="count($employee.data//employees/employee[(default_address = $defaultaddr 
            or default_address = $remitaddr) and string-length(default_address) != 0]) != 0">
            <xsl:value-of select="wd:Supplier_ID"/>
            <xsl:value-of select="$delimiter"/>
            <xsl:value-of select="wd:Supplier_Name"/>
            <xsl:value-of select="$delimiter"/>
            <xsl:value-of select="wd:Date_Supplier_Created"/>
            <xsl:value-of select="$delimiter"/>
            <xsl:value-of select="normalize-space(wd:DefaultAddress)"/>
            <xsl:value-of select="$delimiter"/>
            <xsl:value-of select="normalize-space(wd:RemitAddress)"/>
            <xsl:value-of select="$delimiter"/>
            <xsl:apply-templates select="$employee.data//employees/employee[default_address = $defaultaddr 
                 and string-length(default_address) != 0]"/>
            <xsl:value-of select="$delimiter"/>
            <xsl:apply-templates select="$employee.data//employees/employee[default_address = $remitaddr 
                and string-length(default_address) != 0]"/>
            <xsl:value-of select="$line_ending"/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="employee">
        <xsl:value-of select="concat(@employeename,'-',@employeeid)"/>
        <xsl:value-of select="';'"/>
    </xsl:template>

    <xsl:template name="create_header_record">
        <xsl:value-of select="'SupplierId'"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="'SupplierName'"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="'SupplierCreatedDate'"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="'SupplierDefaultAddress'"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="'SupplierRemitAddress'"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="'EmployeesMatchingDefaultAddress'"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="'EmployeesMatchingRemitAddress'"/>
        <xsl:value-of select="$line_ending"/>
    </xsl:template>

    <xsl:template name="change-case">
        <xsl:param name="text"/>
        <xsl:param name="case" select="'u'"/>
        <xsl:choose>
            <xsl:when test="translate(substring($case,1,1), 'U', 'u') = 'u'">
                <xsl:value-of
                    select="translate($text,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
            </xsl:when>
            <xsl:when test="translate(substring($case,1,1), 'L', 'l') = 'l'">
                <xsl:value-of
                    select="translate($text,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$text"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="string-replace-all">
        <xsl:param name="text"/>
        <xsl:param name="replace"/>
        <xsl:param name="by"/>
        <xsl:choose>
            <xsl:when test="contains($text, $replace)">
                <xsl:value-of select="substring-before($text,$replace)"/>
                <xsl:value-of select="$by"/>
                <xsl:call-template name="string-replace-all">
                    <xsl:with-param name="text" select="substring-after($text,$replace)"/>
                    <xsl:with-param name="replace" select="$replace"/>
                    <xsl:with-param name="by" select="$by"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$text"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>