<?xml version="1.0" encoding="UTF-8"?>
<!-- Copyright 2014 Matthew Davis -->
<!-- This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
    
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
    
    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/> -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">

    <xsl:param name="file-pattern"/>
    <xsl:param name="file-list"/>
    
    <xsl:output method="xml" version="1.0"
        encoding="UTF-8" indent="yes" omit-xml-declaration="no"/>
    
    <xsl:template match="/">
        <xsl:variable name="file-match">
            <xsl:value-of select="$file-pattern"/>
        </xsl:variable>
        <files-to-process>
            <filecount>
                <xsl:choose>
                    <xsl:when test="$file-list = '[]'">
                        <xsl:value-of select="0"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="count(tokenize($file-list,', ')[matches(.,$file-match, 's')])"/>
                    </xsl:otherwise>
                </xsl:choose>
            </filecount>
            <xsl:for-each select="tokenize(translate($file-list,'[]',''),', ')[matches(.,$file-match,'s')]">
                <filenametoprocess>
                    <xsl:value-of select="."/>
                </filenametoprocess>
            </xsl:for-each>
            <xsl:for-each select="tokenize(translate($file-list,'[]',''),', ')[not(matches(.,$file-match,'s'))]">
                <filenametoskip>
                    <xsl:value-of select="."/>
                </filenametoskip>
            </xsl:for-each>
            <actualfilelist>
                <xsl:for-each select="tokenize(translate($file-list,'[]',''),', ')[matches(.,$file-match,'s')]">
                    <xsl:value-of select="."/>
                    <xsl:if test="position() != last()">
                        <xsl:value-of select="'; '"/>
                    </xsl:if>
                </xsl:for-each>
            </actualfilelist>
        </files-to-process>
    </xsl:template>
    
</xsl:stylesheet>