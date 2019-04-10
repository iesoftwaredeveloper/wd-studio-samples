<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ecmc="https://ecmc.org/supplier_invoice_format"
    xmlns:wd="urn:com.workday/bsvc"
    xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"
    xmlns:intsys="java:com.workday.esb.intsys.xpath.ParsedIntegrationSystemFunctions"
    exclude-result-prefixes="xs env ecmc xsl intsys"
    version="2.0">

    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" version="1.0" indent="yes"/>

    <xsl:param name="web.service.add.only"/>
    <xsl:param name="web.service.auto.complete"/>
    <xsl:param name="web.service.version"/>
    <xsl:param name="web.service.submit"/>
    <xsl:param name="single.instance.update.1.wids" select="'INACTIVE'"/>
    <xsl:param name="single.instance.update.2.wids" select="'INACTIVE'"/>
    <xsl:param name="single.instance.update.3.wids" select="'INACTIVE'"/>
    <xsl:param name="business.process.defaultcomment"/>

    <xsl:template match="/">
        <xsl:apply-templates select="//ecmc:supplier_invoice" mode="#default"/>
    </xsl:template>

    <xsl:template match="ecmc:supplier_invoice" mode="#default">
        <env:Envelope xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"
            xmlns:wd="urn:com.workday/bsvc">
            <env:Header/>
            <env:Body>
                <wd:Import_Supplier_Invoice_Request>
                    <xsl:attribute name="wd:version">
                        <xsl:value-of select="$web.service.version"/>
                    </xsl:attribute>
                    <xsl:attribute name="wd:Add_Only">
                        <xsl:choose>
                            <xsl:when test="string-length($web.service.add.only) = 0">
                                <xsl:value-of select="'1'"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$web.service.add.only"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:apply-templates select="ancestor-or-self::wd:Purchase_Order_Reference"/>
                    <wd:Business_Process_Parameters>
                        <wd:Auto_Complete>
                            <xsl:choose>
                                <xsl:when test="string-length($web.service.auto.complete) = 0">
                                    <xsl:value-of select="'0'"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$web.service.auto.complete"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </wd:Auto_Complete>
                        <wd:Comment_Data>
                            <wd:Comment>
                                <xsl:value-of select="$business.process.defaultcomment"/>
                            </wd:Comment>
                        </wd:Comment_Data>
                    </wd:Business_Process_Parameters>
                    <xsl:apply-templates select="." mode="header"/>
                </wd:Import_Supplier_Invoice_Request>
            </env:Body>
        </env:Envelope>
    </xsl:template>

    <xsl:template match="ecmc:supplier_invoice" mode="header">
        <wd:Supplier_Invoice_Data>
            <wd:Supplier_Invoice_ID>
                <xsl:value-of select="ecmc:supplier_invoice_id"/>
            </wd:Supplier_Invoice_ID>
            <wd:Submit>
                <xsl:value-of select="$web.service.submit"/>
            </wd:Submit>
            <wd:Company_Reference>
                <wd:ID wd:type="Company_Reference_ID">
                    <xsl:value-of select="ecmc:company_id"/>
                </wd:ID>
            </wd:Company_Reference>
            <wd:Currency_Reference>
                <wd:ID wd:type="Currency_ID">
                    <xsl:value-of select="'USD'"/>
                </wd:ID>
            </wd:Currency_Reference>
            <wd:Supplier_Reference>
                <wd:ID wd:type="Supplier_ID">
                    <xsl:value-of select="ecmc:supplier_reference_id"/>
                </wd:ID>
            </wd:Supplier_Reference>
            <wd:Invoice_Date>
                <xsl:value-of select="ecmc:invoice_date"/>
            </wd:Invoice_Date>
            <wd:Invoice_Received_Date>
                <xsl:value-of select="current-date()"/>
            </wd:Invoice_Received_Date>
            <wd:Control_Amount_Total>
                <xsl:value-of select="ecmc:control_total_amount"/>
            </wd:Control_Amount_Total>
            <xsl:if test="ecmc:invoice_taxtotal != 0">
                <wd:Tax_Amount>
                    <xsl:value-of select="ecmc:invoice_taxtotal"/>
                </wd:Tax_Amount>
            </xsl:if>
            <xsl:if test="ecmc:invoice_freighttotal != 0">
                <wd:Freight_Amount>
                    <xsl:value-of select="ecmc:invoice_freighttotal"/>
                </wd:Freight_Amount>
            </xsl:if>
            <xsl:if test="ecmc:invoice_othertotal != 0">
                <wd:Other_Charges>
                    <xsl:value-of select="ecmc:invoice_othertotal"/>
                </wd:Other_Charges>
            </xsl:if>
            <wd:Suppliers_Invoice_Number>
                <xsl:value-of select="ecmc:supplier_invoice_id"/>
            </wd:Suppliers_Invoice_Number>
            <wd:Memo>
                <xsl:value-of select="ecmc:memo"/>
            </wd:Memo>
            <xsl:variable name="other_line_amounts">
                <xsl:call-template name="othertotallinebreakout">
                    <xsl:with-param name="subtotal" select="ecmc:invoice_subtotal"/>
                    <xsl:with-param name="othertotal" select="ecmc:invoice_discounttotal"/>
                    <xsl:with-param name="totallineamounts" select="string-join(.//ecmc:invoice_line_data/ecmc:extended_amount,',')"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="offset_amount">
                <xsl:value-of select="ecmc:invoice_discounttotal - sum($other_line_amounts//lineamount)"/>
            </xsl:variable>

            <xsl:apply-templates select=".//ecmc:invoice_line_data">
                <xsl:with-param name="discount.total" select="ecmc:invoice_discounttotal"/>
                <xsl:with-param name="subtotal" select="ecmc:invoice_subtotal"/>
                <xsl:with-param name="offset.amount" select="$offset_amount"/>
                <xsl:with-param name="line.instance" select="position()"/>
            </xsl:apply-templates>
        </wd:Supplier_Invoice_Data>
    </xsl:template>

    <xsl:template match="ecmc:invoice_line_data">
        <xsl:param name="discount.total"/>
        <xsl:param name="subtotal"/>
        <xsl:param name="offset.amount"/>
        <xsl:param name="line.instance"/>
        <xsl:variable name="line.percent" select="if ($subtotal = 0) then 0 else (ecmc:extended_amount div $subtotal)"/>
        <xsl:variable name="discount.line.total">
            <xsl:choose>
                <xsl:when test="$discount.total != 0 and $line.instance = 1 and position() = 1">
                    <xsl:value-of select="($discount.total * $line.percent) + $offset.amount"/>
                </xsl:when>
                <xsl:when test="$discount.total != 0">
                    <xsl:value-of select="$discount.total * $line.percent"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="0"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <wd:Invoice_Line_Replacement_Data>
            <wd:Line_Order>
                <xsl:value-of select="ecmc:line_order"/>
            </wd:Line_Order>
            <xsl:if test="string-length(ecmc:company_id) != 0">
                <wd:Intercompany_Affiliate_Reference>
                    <wd:ID wd:type="Company_Reference_ID">
                        <xsl:value-of select="ecmc:company_id"/>
                    </wd:ID>
                </wd:Intercompany_Affiliate_Reference>
            </xsl:if>
            <xsl:if test="string-length(ecmc:workday_line_po_number) != 0">
                <wd:Purchase_Order_Line_Reference>
                    <wd:ID wd:type="Line_Number">
                        <xsl:attribute name="wd:parent_id" select="ecmc:workday_line_po_number"/>
                        <xsl:attribute name="wd:parent_type" select="'Document_Number'"/>
                        <xsl:value-of select="ecmc:workday_line_po_number/@ecmc:line_number"/>
                    </wd:ID>
                </wd:Purchase_Order_Line_Reference>
            </xsl:if>
            <wd:Item_Description>
                <xsl:value-of select="ecmc:item_description"/>
            </wd:Item_Description>
            <wd:Spend_Category_Reference>
                <wd:ID wd:type="Spend_Category_ID">
                    <xsl:value-of select="ecmc:spend_category_id"/>
                </wd:ID>
            </wd:Spend_Category_Reference>
            <wd:Quantity>
                <xsl:value-of select="ecmc:quantity"/>
            </wd:Quantity>
            <wd:Unit_Cost>
                <xsl:value-of select="ecmc:unit_cost"/>
            </wd:Unit_Cost>
            <wd:Extended_Amount>
                <xsl:value-of select="ecmc:extended_amount"/>
            </wd:Extended_Amount>
            <xsl:apply-templates select=".//ecmc:worktags/ecmc:worktag"/>
        </wd:Invoice_Line_Replacement_Data>
        <xsl:if test="$discount.line.total != 0">
            <wd:Invoice_Line_Replacement_Data>
                <wd:Line_Order>
                    <xsl:value-of select="concat(ecmc:line_order,'.discount')"/>
                </wd:Line_Order>
                <xsl:if test="string-length(ecmc:company_id) != 0">
                    <wd:Intercompany_Affiliate_Reference>
                        <wd:ID wd:type="Company_Reference_ID">
                            <xsl:value-of select="ecmc:company_id"/>
                        </wd:ID>
                    </wd:Intercompany_Affiliate_Reference>
                </xsl:if>
                <wd:Item_Description>
                    <xsl:value-of select="concat('Discount - ',ecmc:item_description)"/>
                </wd:Item_Description>
                <wd:Spend_Category_Reference>
                    <wd:ID wd:type="Spend_Category_ID">
                        <xsl:value-of select="ecmc:spend_category_id"/>
                    </wd:ID>
                </wd:Spend_Category_Reference>
               <wd:Quantity>
                    <xsl:value-of select="1"/>
                </wd:Quantity>
                <wd:Unit_Cost>
                    <xsl:value-of select="format-number(xs:decimal($discount.line.total),'####.00')"/>
                </wd:Unit_Cost>
                <wd:Extended_Amount>
                    <xsl:value-of select="format-number(xs:decimal($discount.line.total),'####.00')"/>
                </wd:Extended_Amount>
                <xsl:apply-templates select=".//ecmc:po_line_worktags/ecmc:worktag"/>
            </wd:Invoice_Line_Replacement_Data>
        </xsl:if>
    </xsl:template>

    <xsl:template match="ecmc:worktag">
        <wd:Worktags_Reference>
            <wd:ID>
                <xsl:attribute name="wd:type" select="@ecmc:type"/>
                <xsl:value-of select="."/>
            </wd:ID>
        </wd:Worktags_Reference>
    </xsl:template>

    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template name="othertotallinebreakout">
        <xsl:param name="othertotal"/>
        <xsl:param name="subtotal"/>
        <xsl:param name="totallineamounts"/>
        <lineamounts>
            <xsl:for-each select="tokenize($totallineamounts,',')">
                <xsl:if test="normalize-space(.) != ''">
                    <xsl:variable name="linepercent">
                            <xsl:choose>
                                <xsl:when test="$subtotal = 0">
                                    <xsl:value-of select="0"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="xs:decimal(normalize-space(.)) div $subtotal"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                    <xsl:variable name="otherlinetotal">
                        <xsl:choose>
                            <xsl:when test="$othertotal &lt;= 0">
                                <xsl:value-of select="$othertotal * $linepercent"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="0"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <lineamount>
                        <xsl:attribute name="lineposition" select="position()"/>
                        <xsl:value-of select="format-number($otherlinetotal,'####.00')"/>
                    </lineamount>
                </xsl:if>
            </xsl:for-each>
        </lineamounts>
    </xsl:template>
    

</xsl:stylesheet>
