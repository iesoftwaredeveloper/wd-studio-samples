<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tns="http://yourcompany.com/textschema/Accounting_Technology_Common/customerdatatoupdate.xsd"
    xmlns:wd="urn:com.workday/bsvc"
    xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"
    xmlns:atc="http://yourcompany.com/textschema/Accounting_Technology_Common"
    xmlns:intsys="java:com.workday.esb.intsys.xpath.ParsedIntegrationSystemFunctions"
    exclude-result-prefixes="xs env tns xsl intsys atc" version="2.0">

    <xsl:output method="xml" version="1.0" indent="yes"/>

    <xsl:param name="webservice.version"/>
    <xsl:param name="add.only"/>
    <xsl:param name="auto.complete"/>
    <xsl:param name="webservice.recordcount"/>
    <xsl:param name="businessprocess.defaultcomment"/>
    <xsl:param name="customer.inactivestatusid" select="'INACTIVE'"/>
    <xsl:param name="customer.statuschangereasonid" select="'INACTIVE'"/>
    <xsl:variable name="customer.dataupdate" select="document('mctx:vars/externalfile.data')"/>

    <xsl:template match="/">
        <xsl:apply-templates select="//wd:Customer"/>
    </xsl:template>

    <xsl:template match="wd:Customer">
        <env:Envelope xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"
            xmlns:wd="urn:com.workday/bsvc">
            <env:Header/>
            <env:Body>
                <wd:Put_Customer_Request>
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
                    <wd:Customer_Reference>
                        <wd:ID>
                            <xsl:attribute name="wd:type">
                                <xsl:value-of select="'Customer_ID'"/>
                            </xsl:attribute>
                            <xsl:value-of select=".//wd:Customer_ID"/>
                        </wd:ID>
                    </wd:Customer_Reference>
                    <xsl:apply-templates select=".//wd:Customer_Data"/>
                </wd:Put_Customer_Request>
            </env:Body>
        </env:Envelope>
    </xsl:template>

    <xsl:template match="wd:Customer_Data">
        <xsl:variable name="customer_currentid" select="wd:Customer_ID"/>
        <xsl:variable name="customer_updatedata">
            <customer_updatedata>
                <xsl:apply-templates select="$customer.dataupdate//tns:customerupdatefile">
                    <xsl:with-param name="customerid" select="$customer_currentid"/>
                </xsl:apply-templates>
            </customer_updatedata>
        </xsl:variable>
        <wd:Customer_Data>
            <xsl:apply-templates select="node()">
                <xsl:with-param name="customer_updatedata" select="$customer_updatedata"/>
            </xsl:apply-templates>
        </wd:Customer_Data>
    </xsl:template>

    <xsl:template match="wd:Customer_Status_Data">
        <xsl:param name="customer_updatedata"/>
        <wd:Customer_Status_Data>
            <xsl:variable name="currentstatus" select="wd:Status_Reference/wd:ID[@wd:type='Business_Entity_Status_Value_ID']"/>
            <wd:Customer_Status_Value_Reference>
                <wd:ID>
                    <xsl:attribute name="wd:type" select="'Business_Entity_Status_Value_ID'"/>
                    <xsl:value-of select="$customer.inactivestatusid"/>
                </wd:ID>
            </wd:Customer_Status_Value_Reference>
            <wd:Reason_for_Customer_Status_Change_Reference>
                <wd:ID>
                    <xsl:attribute name="wd:type" select="'Reason_for_Customer_Status_Change_ID'"/>
                    <xsl:value-of select="$customer.statuschangereasonid"/>
                </wd:ID>
            </wd:Reason_for_Customer_Status_Change_Reference>
            <wd:Customer_Status_Change_Reason_Description>
                <xsl:value-of select="'Migrate to NetSuite'"/>
            </wd:Customer_Status_Change_Reason_Description>
        </wd:Customer_Status_Data>
    </xsl:template>

    <xsl:template match="customerupdatefile">
        <xsl:param name="customer_updatedata"/>
        <customerdetaildata>
            <xsl:apply-templates select="@*|node()">
                <xsl:with-param name="customer_updatedata" select="$customer_updatedata"/>
            </xsl:apply-templates>
        </customerdetaildata>
    </xsl:template>
    
    <xsl:template match="tns:customerupdatefile">
        <xsl:param name="customerid"/>
        <xsl:for-each-group select=".//customer_updatedata" group-by="customerid">
            <xsl:if test="$customerid = current-grouping-key()">
                <customer_updatedata>
                    <xsl:attribute name="customerid" select="current-grouping-key()"/>
                    <xsl:apply-templates select="current-group()">
                        <xsl:with-param name="customer_updatedata" select="current-grouping-key()"/>
                    </xsl:apply-templates>
                </customer_updatedata>
            </xsl:if>
        </xsl:for-each-group>
    </xsl:template>
    
    <xsl:template match="wd:Usage_Data">
        <xsl:param name="supplier_updatedata"/>
        <wd:Usage_Data>
            <xsl:variable name="isprimaryaddress">
                <xsl:choose>
                    <xsl:when test="wd:Type_Data/@wd:Primary = 1">
                        <xsl:value-of select="'y'"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="'n'"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:apply-templates select="wd:Type_Data">
                <xsl:with-param name="supplier_updatedata" select="$supplier_updatedata"/>
            </xsl:apply-templates>
            <xsl:variable name="currentusage">
                <xsl:for-each select="wd:Use_For_Reference">
                    <xsl:value-of select="@wd:Descriptor"/>
                    <xsl:if test="position() != last()">
                        <xsl:value-of select="', '"/>
                    </xsl:if>
                </xsl:for-each>
            </xsl:variable>
            <xsl:call-template name="useforreference">
                <xsl:with-param name="newreference" select="$currentusage"/>
            </xsl:call-template>
        </wd:Usage_Data>
    </xsl:template>
    
    <xsl:template name="useforreference">
        <xsl:param name="newreference"/>
        <xsl:for-each select="tokenize($newreference,',')">
            <xsl:variable name="tempnewreference" select="normalize-space(.)"/>
            <wd:Use_For_Reference>
                <wd:ID>
                    <xsl:attribute name="wd:type" select="'Communication_Usage_Behavior_ID'"/>
                    <xsl:value-of select="document('')/*/atc:map/use_for_reference[@input = $tempnewreference]"/>
                </wd:ID>
            </wd:Use_For_Reference>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="@*|node()">
        <xsl:param name="customer_updatedata"/>
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*|node()">
                <xsl:with-param name="customer_updatedata" select="$customer_updatedata"/>
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>
    
    <atc:map>
        <use_for_reference input="Billing">BILLING</use_for_reference>
        <use_for_reference input="Mailing">MAILING</use_for_reference>
        <use_for_reference input="Remit To">REMIT</use_for_reference>
        <use_for_reference input="Shipping">SHIPPING</use_for_reference>
        <use_for_reference input="Street Address">STREET</use_for_reference>
        <use_for_reference input="Tax Reporting">TAX_REPORTING</use_for_reference>
        <name_usage_reference input="1099 MISC Recipient">IRS_1099_RECIPIENT</name_usage_reference>
        <name_usage_reference input="Bill To Addressee 1">BILL_TO_ADDRESSEE_1</name_usage_reference>
        <name_usage_reference input="Bill To Addressee 2">BILL_TO_ADDRESSEE_2</name_usage_reference>
        <name_usage_reference input="Integration Name Matching">INT_NAME_MATCH</name_usage_reference>
        <name_usage_reference input="Purchase Order Name">PURCHASE_ORDER_NAME</name_usage_reference>
        <name_usage_reference input="Reference">REFERENCE</name_usage_reference>
        <name_usage_reference input="Remit To Addressee 1">REMIT_TO_ADDRESSEE_1</name_usage_reference>
        <name_usage_reference input="Remit To Addressee 2">REMIT_TO_ADDRESSEE_2</name_usage_reference>
        <name_usage_reference input="Remit To Advice Name">REMIT_TO_ADVICE_NAME</name_usage_reference>
        <name_usage_reference input="Remit To Payee">REMIT_TO_PAYEE</name_usage_reference>
    </atc:map>


</xsl:stylesheet>
