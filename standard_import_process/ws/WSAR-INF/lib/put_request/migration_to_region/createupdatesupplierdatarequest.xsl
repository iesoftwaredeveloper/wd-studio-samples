<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tns="http://yourcompany.com/textschema/Accounting_Technology_Common/supplierdatatoupdate.xsd" xmlns:wd="urn:com.workday/bsvc"
    xmlns:env="http://schemas.xmlsoap.org/soap/envelope/" xmlns:atc="http://yourcompany.com/textschema/Accounting_Technology_Common" xmlns:intsys="java:com.workday.esb.intsys.xpath.ParsedIntegrationSystemFunctions"
    exclude-result-prefixes="xs env tns xsl intsys atc" version="2.0">

    <xsl:output method="xml" version="1.0" indent="yes"/>

    <xsl:param name="webservice.version"/>
    <xsl:param name="add.only"/>
    <xsl:param name="auto.complete"/>
    <xsl:param name="webservice.recordcount"/>
    <xsl:param name="businessprocess.defaultcomment"/>
    <xsl:param name="supplier.inactivestatusid" select="'INACTIVE'"/>
    <xsl:param name="supplier.statuschangereasonid" select="'NO_ACTIVITY'"/>
    <xsl:variable name="supplier.dataupdate" select="document('mctx:vars/externalfile.data')"/>

    <xsl:template match="/">
        <xsl:apply-templates select="//wd:Supplier"/>
    </xsl:template>

    <xsl:template match="wd:Supplier">
        <env:Envelope xmlns:env="http://schemas.xmlsoap.org/soap/envelope/" xmlns:wd="urn:com.workday/bsvc">
            <env:Header/>
            <env:Body>
                <wd:Submit_Supplier_Request>
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
                    <wd:Supplier_Reference>
                        <wd:ID>
                            <xsl:attribute name="wd:type">
                                <xsl:value-of select="'Supplier_ID'"/>
                            </xsl:attribute>
                            <xsl:value-of select=".//wd:Supplier_ID"/>
                        </wd:ID>
                    </wd:Supplier_Reference>
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
                    <xsl:apply-templates select=".//wd:Supplier_Data"/>
                </wd:Submit_Supplier_Request>
            </env:Body>
        </env:Envelope>
    </xsl:template>

    <xsl:template match="wd:Supplier_Data">
        <xsl:variable name="supplier_currentid" select="wd:Supplier_ID"/>
        <xsl:variable name="supplier_updatedata">
            <supplier_updatedata>
                <xsl:apply-templates select="$supplier.dataupdate//tns:supplierupdatefile">
                    <xsl:with-param name="supplierid" select="$supplier_currentid"/>
                </xsl:apply-templates>
            </supplier_updatedata>
        </xsl:variable>
        <wd:Supplier_Data>
            <xsl:apply-templates select="node()">
                <xsl:with-param name="supplier_updatedata" select="$supplier_updatedata"/>
            </xsl:apply-templates>
            <xsl:if test=" count(.//wd:Tax_Authority_Form_Type_Reference) = 0
                    and count($supplier_updatedata//supplierdetaildata[lower-case(taxauthorityformtype) != 'donotchange']) != 0
                    and count($supplier_updatedata//supplierdetaildata[lower-case(taxauthorityformtype) = 'blank']) = 0">
                <xsl:call-template name="taxauthority">
                    <xsl:with-param name="inputvalue" select="$supplier_updatedata//supplierdetaildata[lower-case(taxauthorityformtype) != 'donotchange'][1]/taxauthorityformtype"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:for-each select="$supplier_updatedata//notes">
                <xsl:variable name="currentnotedata">
                    <xsl:value-of select="."/>
                </xsl:variable>
                <xsl:if test="count(//wd:Note_Data[lower-case(wd:Note_Content) = lower-case($currentnotedata)]) = 0">
                    <xsl:call-template name="newnotedata">
                        <xsl:with-param name="notedata" select="."/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:for-each>
            <xsl:for-each select="$supplier_updatedata//supplierdetaildata[lower-case(alternatenameusagecurrent) = 'new']">
                <xsl:call-template name="newalternatenames">
                    <xsl:with-param name="alternatename" select="alternatename"/>
                    <xsl:with-param name="alternatenameusage" select="alternatenameusagenew"/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:if test="count($supplier_updatedata//supplierdetaildata[lower-case(integrationsystem) != 'donotchange']) != 0
                    and count($supplier_updatedata//supplierdetaildata[lower-case(integrationsystem) != '']) != 0">
                <xsl:call-template name="integrationsystem">
                    <xsl:with-param name="inputvalue" select="$supplier_updatedata//supplierdetaildata[lower-case(integrationsystem) != 'donotchange'][1]/integrationsystem"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="string-length(wd:Currency_Reference) = 0">
                <xsl:if test="count($supplier_updatedata//supplierdetaildata[lower-case(defaultcurrency) != 'donotchange']) &gt;= 1
                    and count($supplier_updatedata//supplierdetaildata[lower-case(defaultcurrency) != '']) != 0">
                    <wd:Currency_Reference>
                        <wd:ID wd:type="Currency_ID">
                            <xsl:value-of select="$supplier_updatedata//supplierdetaildata[lower-case(defaultcurrency) != 'donotchange'][1]/defaultcurrency"/>
                        </wd:ID>
                    </wd:Currency_Reference>
                </xsl:if>
            </xsl:if>
            <xsl:if test="count($supplier_updatedata//supplierdetaildata[lower-case(acceptedcurrencies) = 'donotchange']) != count($supplier_updatedata//supplierdetaildata)">
                <xsl:for-each select="tokenize($supplier_updatedata//supplierdetaildata[lower-case(acceptedcurrencies) != 'donotchange'][1]/acceptedcurrencies,',')">
                    <wd:Accepted_Currencies_Reference>
                        <wd:ID wd:type="Currency_ID">
                            <xsl:value-of select="normalize-space(.)"/>
                        </wd:ID>
                    </wd:Accepted_Currencies_Reference>
                </xsl:for-each>
            </xsl:if>
            <xsl:if test="count($supplier_updatedata//supplierdetaildata[lower-case(acceptedpaymenttypes) = 'donotchange']) != count($supplier_updatedata//supplierdetaildata)">
                <xsl:for-each select="tokenize($supplier_updatedata//supplierdetaildata[lower-case(acceptedpaymenttypes) != 'donotchange'][1]/acceptedpaymenttypes,',')">
                    <wd:Payment_Types_Accepted_Reference>
                        <wd:ID wd:type="Payment_Type_ID">
                            <xsl:value-of select="normalize-space(.)"/>
                        </wd:ID>
                    </wd:Payment_Types_Accepted_Reference>
                </xsl:for-each>
            </xsl:if>
        </wd:Supplier_Data>
    </xsl:template>

    <xsl:template match="wd:Supplier_Data/wd:Currency_Reference">
        <xsl:param name="supplier_updatedata"/>
        <wd:Currency_Reference>
            <wd:ID wd:type="Currency_ID">
                <xsl:choose>
                    <xsl:when test="count($supplier_updatedata//supplierdetaildata[lower-case(defaultcurrency) = 'donotchange']) = count($supplier_updatedata//supplierdetaildata)">
                        <xsl:value-of select="wd:ID[@wd:type='Currency_ID']"/>
                    </xsl:when>
                    <xsl:when test="count($supplier_updatedata//supplierdetaildata[lower-case(defaultcurrency) != 'donotchange']) &gt;= 1">
                        <xsl:value-of select="$supplier_updatedata//supplierdetaildata[lower-case(defaultcurrency) != 'donotchange'][1]/defaultcurrency"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="wd:ID[@wd:type='Currency_ID']"/>
                    </xsl:otherwise>
                </xsl:choose>
            </wd:ID>
        </wd:Currency_Reference>
    </xsl:template>
    
    <xsl:template match="wd:Accepted_Currencies_Reference">
        <xsl:param name="supplier_updatedata"/>
        <xsl:if test="count($supplier_updatedata//supplierdetaildata[lower-case(acceptedcurrencies) = 'donotchange']) = count($supplier_updatedata//supplierdetaildata)">
            <wd:Accepted_Currencies_Reference>
                <wd:ID wd:type="Currency_ID">
                    <xsl:value-of select="wd:ID[@wd:type='Currency_ID']"/>
                </wd:ID>
            </wd:Accepted_Currencies_Reference>
        </xsl:if>
    </xsl:template>

    <xsl:template match="wd:Supplier_Status_Data">
        <xsl:param name="supplier_updatedata"/>
        <wd:Supplier_Status_Data>
            <xsl:variable name="currentstatus" select="wd:Status_Reference/wd:ID[@wd:type = 'Business_Entity_Status_Value_ID']"/>
            <xsl:choose>
                <xsl:when test="count($supplier_updatedata//supplierdetaildata[lower-case(supplierstatus) = 'inactive']) = 1">
                    <wd:Status_Reference>
                        <wd:ID>
                            <xsl:attribute name="wd:type" select="'Business_Entity_Status_Value_ID'"/>
                            <xsl:value-of select="$supplier.inactivestatusid"/>
                        </wd:ID>
                    </wd:Status_Reference>
                    <wd:Reason_Reference>
                        <wd:ID>
                            <xsl:attribute name="wd:type" select="'Reason_for_Supplier_Status_Change_ID'"/>
                            <xsl:value-of select="$supplier.statuschangereasonid"/>
                        </wd:ID>
                    </wd:Reason_Reference>
                </xsl:when>
                <xsl:when test="count($supplier_updatedata//supplierdetaildata[lower-case(supplierstatus) = 'inactive']) = count($supplier_updatedata//supplierdetaildata)
                        and count($supplier_updatedata//supplierdetaildata) != 0">
                    <wd:Status_Reference>
                        <wd:ID>
                            <xsl:attribute name="wd:type" select="'Business_Entity_Status_Value_ID'"/>
                            <xsl:value-of select="$supplier.inactivestatusid"/>
                        </wd:ID>
                    </wd:Status_Reference>
                    <wd:Reason_Reference>
                        <wd:ID>
                            <xsl:attribute name="wd:type" select="'Reason_for_Supplier_Status_Change_ID'"/>
                            <xsl:value-of select="$supplier.statuschangereasonid"/>
                        </wd:ID>
                    </wd:Reason_Reference>
                </xsl:when>
                <xsl:otherwise>
                    <wd:Status_Reference>
                        <wd:ID>
                            <xsl:attribute name="wd:type" select="'Business_Entity_Status_Value_ID'"/>
                            <xsl:value-of select="$currentstatus"/>
                        </wd:ID>
                    </wd:Status_Reference>
                </xsl:otherwise>
            </xsl:choose>
        </wd:Supplier_Status_Data>
    </xsl:template>

    <xsl:template match="wd:Business_Entity_Name">
        <xsl:param name="supplier_updatedata"/>
        <wd:Business_Entity_Name>
            <xsl:choose>
                <xsl:when test="count($supplier_updatedata//supplierdetaildata[lower-case(suppliername) = 'donotchange']) = count($supplier_updatedata//supplierdetaildata)">
                    <xsl:value-of select="."/>
                </xsl:when>
                <xsl:when test="count($supplier_updatedata//supplierdetaildata[lower-case(suppliername) != 'donotchange']) &gt;= 1">
                    <xsl:value-of select="$supplier_updatedata//supplierdetaildata[lower-case(suppliername) != 'donotchange'][1]/suppliername"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </wd:Business_Entity_Name>
    </xsl:template>

    <xsl:template match="wd:Supplier_Name">
        <xsl:param name="supplier_updatedata"/>
        <wd:Supplier_Name>
            <xsl:choose>
                <xsl:when test="count($supplier_updatedata//supplierdetaildata[lower-case(suppliername) = 'donotchange']) = count($supplier_updatedata//supplierdetaildata)">
                    <xsl:value-of select="."/>
                </xsl:when>
                <xsl:when test="count($supplier_updatedata//supplierdetaildata[lower-case(suppliername) != 'donotchange']) &gt;= 1">
                    <xsl:value-of select="$supplier_updatedata//supplierdetaildata[lower-case(suppliername) != 'donotchange'][1]/suppliername"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </wd:Supplier_Name>
    </xsl:template>
    
    <xsl:template match="wd:Payment_Types_Accepted_Reference">
        <xsl:param name="supplier_updatedata"/>
        <xsl:if test="count($supplier_updatedata//supplierdetaildata[lower-case(acceptedpaymenttypes) = 'donotchange']) = count($supplier_updatedata//acceptedpaymenttypes)">
            <wd:Payment_Types_Accepted_Reference>
                <wd:ID wd:type="Payment_Type_ID">
                    <xsl:value-of select="wd:ID[@wd:type='Payment_Type_ID']"/>
                </wd:ID>
            </wd:Payment_Types_Accepted_Reference>
        </xsl:if>
    </xsl:template>

    <xsl:template match="wd:Business_Entity_Data">
        <xsl:param name="supplier_updatedata"/>
        <wd:Business_Entity_Data>
            <xsl:apply-templates select="@* | node()">
                <xsl:with-param name="supplier_updatedata" select="$supplier_updatedata"/>
            </xsl:apply-templates>
            <xsl:if test="
                    count(.//wd:Business_Entity_Tax_ID) = 0
                    and count($supplier_updatedata//supplierdetaildata[lower-case(taxid) != 'donotchange']) != 0">
                <xsl:call-template name="writenewnode">
                    <xsl:with-param name="node_name" select="'wd:Business_Entity_Tax_ID'"/>
                    <xsl:with-param name="node_value" select="$supplier_updatedata//supplierdetaildata[lower-case(taxid) != 'donotchange'][1]/taxid"/>
                </xsl:call-template>
            </xsl:if>
        </wd:Business_Entity_Data>
    </xsl:template>

    <xsl:template match="wd:Business_Entity_Tax_ID">
        <xsl:param name="supplier_updatedata"/>
        <!--<wd:Business_Entity_Tax_ID>
            <xsl:choose>
                <xsl:when test="count($supplier_updatedata//supplierdetaildata[lower-case(taxid) = 'donotchange']) = count($supplier_updatedata//supplierdetaildata)">
                    <xsl:value-of select="."/>
                </xsl:when>
                <xsl:when test="count($supplier_updatedata//supplierdetaildata[lower-case(taxid) != 'donotchange']) = 1">
                    <xsl:value-of select="$supplier_updatedata//supplierdetaildata[lower-case(taxid) != 'donotchange'][1]/taxid"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </wd:Business_Entity_Tax_ID>-->
    </xsl:template>

    <xsl:template match="wd:Tax_Authority_Form_Type_Reference">
        <xsl:param name="supplier_updatedata"/>
        <xsl:if test="count($supplier_updatedata//supplierdetaildata[lower-case(taxauthorityformtype) = 'blank']) = 0">
            <wd:Tax_Authority_Form_Type_Reference>
                <wd:ID>
                    <xsl:attribute name="wd:type" select="'Tax_Authority_Form_Type'"/>
                    <xsl:choose>
                        <xsl:when test="count($supplier_updatedata//supplierdetaildata[lower-case(taxauthorityformtype) != 'donotchange']) = 1">
                            <xsl:value-of select="replace(upper-case($supplier_updatedata//supplierdetaildata[lower-case(taxauthorityformtype) != 'donotchange']/taxauthorityformtype), ' ', '_')"/>
                        </xsl:when>
                        <xsl:when test="count($supplier_updatedata//supplierdetaildata[lower-case(taxauthorityformtype) != 'donotchange']) = count($supplier_updatedata//supplierdetaildata)">
                            <xsl:value-of select="replace(upper-case($supplier_updatedata//supplierdetaildata[lower-case(taxauthorityformtype) != 'donotchange'][1]/taxauthorityformtype), ' ', '_')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="wd:ID[@wd:type = 'Tax_Authority_Form_Type']"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </wd:ID>
            </wd:Tax_Authority_Form_Type_Reference>
        </xsl:if>
    </xsl:template>

    <xsl:template match="wd:IRS_1099_Supplier">
        <xsl:param name="supplier_updatedata"/>
        <wd:IRS_1099_Supplier>
            <xsl:choose>
                <xsl:when test="count($supplier_updatedata//supplierdetaildata[lower-case(taxauthorityformtype) = 'blank']) = 0">
                    <xsl:value-of select="."/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="0"/>
                </xsl:otherwise>
            </xsl:choose>
        </wd:IRS_1099_Supplier>
    </xsl:template>

    <xsl:template match="wd:Included_Children_Reference">
        <xsl:if test="not(contains(@wd:Descriptor,'(Inactive)'))">
            <xsl:copy-of select="."/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="wd:Business_Entity_Alternate_Name_Data">
        <xsl:param name="supplier_updatedata"/>
        <xsl:variable name="currentusage">
            <xsl:for-each select="wd:Alternate_Name_Usage_Reference">
                <xsl:value-of select="@wd:Descriptor"/>
                <xsl:if test="position() != last()">
                    <xsl:value-of select="', '"/>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="newalternatenameusages">
            <newusages>
                <xsl:for-each select="$supplier_updatedata//supplierdetaildata[lower-case(alternatenameusagecurrent) = 'new']">
                    <xsl:for-each select="tokenize(alternatenameusagenew, ',')">
                        <usage>
                            <xsl:value-of select="normalize-space(.)"/>
                        </usage>
                    </xsl:for-each>
                </xsl:for-each>
            </newusages>
        </xsl:variable>
        <xsl:variable name="filteredalternatenameusage">
            <filteredusages>
                <xsl:for-each select="wd:Alternate_Name_Usage_Reference">
                    <xsl:variable name="currentusagedescriptor" select="@wd:Descriptor"/>
                    <xsl:if test="count($newalternatenameusages//usage[lower-case(.) = lower-case($currentusagedescriptor)]) = 0">
                        <usagedescription>
                            <xsl:value-of select="."/>
                        </usagedescription>
                    </xsl:if>
                </xsl:for-each>
            </filteredusages>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="count($supplier_updatedata//supplierdetaildata[lower-case(alternatenameusagecurrent) = 'donotchange']) = count($supplier_updatedata//supplierdetaildata)
                    and count($filteredalternatenameusage//usagedescription) != 0">
                <wd:Business_Entity_Alternate_Name_Data>
                    <wd:Alternate_Name>
                        <xsl:value-of select="wd:Alternate_Name"/>
                    </wd:Alternate_Name>
                    <xsl:for-each select="wd:Alternate_Name_Usage_Reference">
                        <xsl:variable name="currentusagedescriptor" select="@wd:Descriptor"/>
                        <xsl:apply-templates select=".[count($newalternatenameusages//usage[lower-case(.) = lower-case($currentusagedescriptor)]) = 0]">
                            <xsl:with-param name="supplier_updatedata" select="$supplier_updatedata"/>
                        </xsl:apply-templates>
                    </xsl:for-each>
                </wd:Business_Entity_Alternate_Name_Data>
            </xsl:when>
            <xsl:when test="count($supplier_updatedata//supplierdetaildata[lower-case(alternatenameusagecurrent) = lower-case($currentusage)]) = 1">
                <wd:Business_Entity_Alternate_Name_Data>
                    <wd:Alternate_Name>
                        <xsl:value-of select="$supplier_updatedata//supplierdetaildata[lower-case(alternatenameusagecurrent) = lower-case($currentusage)]/alternatename"/>
                    </wd:Alternate_Name>
                    <xsl:variable name="tempnewusage">
                        <xsl:value-of select="$supplier_updatedata//supplierdetaildata[lower-case(alternatenameusagecurrent) = lower-case($currentusage)]/alternatenameusagenew"/>
                    </xsl:variable>
                    <xsl:call-template name="alternatenameusage">
                        <xsl:with-param name="newusage" select="$tempnewusage"/>
                    </xsl:call-template>
                </wd:Business_Entity_Alternate_Name_Data>
            </xsl:when>
            <xsl:when test="count($filteredalternatenameusage//usagedescription) != 0">
                <wd:Business_Entity_Alternate_Name_Data>
                    <wd:Alternate_Name>
                        <xsl:value-of select="wd:Alternate_Name"/>
                    </wd:Alternate_Name>
                    <xsl:for-each select="wd:Alternate_Name_Usage_Reference">
                        <xsl:variable name="currentusagedescriptor" select="@wd:Descriptor"/>
                        <xsl:apply-templates select=".[count($newalternatenameusages//usage[lower-case(.) = lower-case($currentusagedescriptor)]) = 0]">
                            <xsl:with-param name="supplier_updatedata" select="$supplier_updatedata"/>
                        </xsl:apply-templates>
                    </xsl:for-each>
                </wd:Business_Entity_Alternate_Name_Data>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="wd:Address_Data">
        <xsl:param name="supplier_updatedata"/>
        <wd:Address_Data>
            <xsl:attribute name="wd:Effective_Date" select="current-date()"/>
            <xsl:apply-templates select="node()">
                <xsl:with-param name="supplier_updatedata" select="$supplier_updatedata"/>
            </xsl:apply-templates>
        </wd:Address_Data>
    </xsl:template>

    <xsl:template match="wd:Payment_Terms_Reference">
        <xsl:param name="supplier_updatedata"/>
        <wd:Payment_Terms_Reference>
            <wd:ID>
                <xsl:attribute name="wd:type" select="'Payment_Terms_ID'"/>
                <xsl:choose>
                    <xsl:when test="count($supplier_updatedata//supplierdetaildata[lower-case(defaultpaymenttermsid) = 'donotchange']) = count($supplier_updatedata//supplierdetaildata)">
                        <xsl:value-of select="wd:ID[@wd:type = 'Payment_Terms_ID']"/>
                    </xsl:when>
                    <xsl:when test="count($supplier_updatedata//supplierdetaildata[lower-case(defaultpaymenttermsid) != 'donotchange']) = 1">
                        <xsl:value-of select="$supplier_updatedata//supplierdetaildata[lower-case(defaultpaymenttermsid) != 'donotchange'][1]/defaultpaymenttermsid"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="wd:ID[@wd:type = 'Payment_Terms_ID']"/>
                    </xsl:otherwise>
                </xsl:choose>
            </wd:ID>
        </wd:Payment_Terms_Reference>
    </xsl:template>

    <xsl:template match="wd:Supplier_Category_Reference">
        <xsl:param name="supplier_updatedata"/>
        <wd:Supplier_Category_Reference>
            <wd:ID>
                <xsl:attribute name="wd:type" select="'Supplier_Category_ID'"/>
                <xsl:choose>
                    <xsl:when test="count($supplier_updatedata//supplierdetaildata[lower-case(suppliercategoryid) = 'donotchange']) = count($supplier_updatedata//supplierdetaildata)">
                        <xsl:value-of select="wd:ID[@wd:type = 'Supplier_Category_ID']"/>
                    </xsl:when>
                    <xsl:when test="count($supplier_updatedata//supplierdetaildata[lower-case(suppliercategoryid) != 'donotchange']) = 1">
                        <xsl:value-of select="$supplier_updatedata//supplierdetaildata[lower-case(suppliercategoryid) != 'donotchange'][1]/suppliercategoryid"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="wd:ID[@wd:type = 'Supplier_Category_ID']"/>
                    </xsl:otherwise>
                </xsl:choose>
            </wd:ID>
        </wd:Supplier_Category_Reference>
    </xsl:template>

    <xsl:template match="wd:Supplier_Group_Reference">
        <xsl:param name="supplier_updatedata"/>
        <xsl:choose>
            <xsl:when test="count($supplier_updatedata//supplierdetaildata[lower-case(suppliergroupid) = 'donotchange']) = count($supplier_updatedata//supplierdetaildata)">
                <xsl:value-of select="wd:ID[@wd:type = 'Supplier_Group_ID']"/>
            </xsl:when>
            <xsl:when test="count($supplier_updatedata//supplierdetaildata[lower-case(suppliergroupid) != 'donotchange']) = 1">
                <xsl:for-each select="tokenize($supplier_updatedata//supplierdetaildata[lower-case(suppliergroupid) != 'donotchange'][1]/suppliergroupid, ';')">
                    <wd:Supplier_Group_Reference>
                        <wd:ID>
                            <xsl:attribute name="wd:type" select="'Supplier_Group_ID'"/>
                            <xsl:value-of select="normalize-space(.)"/>
                        </wd:ID>
                    </wd:Supplier_Group_Reference>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <wd:Supplier_Group_Reference>
                    <wd:ID>
                        <xsl:attribute name="wd:type" select="'Supplier_Group_ID'"/>
                        <xsl:value-of select="wd:ID[@wd:type = 'Supplier_Group_ID']"/>
                    </wd:ID>
                </wd:Supplier_Group_Reference>
            </xsl:otherwise>
        </xsl:choose>
        
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
            <xsl:choose>
                <xsl:when test="count($supplier_updatedata//supplierdetaildata[lower-case(addressusagecurrent) = 'donotchange']) = count($supplier_updatedata//supplierdetaildata)">
                    <xsl:call-template name="useforreference">
                        <xsl:with-param name="newreference" select="$currentusage"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="
                        count($supplier_updatedata//supplierdetaildata[lower-case(addressusagecurrent) = lower-case($currentusage)
                        and lower-case(addressprimary) = lower-case($isprimaryaddress)]) = 1">
                    <xsl:variable name="tempnewaddressreference">
                        <xsl:value-of
                            select="
                                $supplier_updatedata//supplierdetaildata[lower-case(addressusagecurrent) = lower-case($currentusage)
                                and lower-case(addressprimary) = lower-case($isprimaryaddress)]/addressusagenew"/>
                    </xsl:variable>
                    <xsl:call-template name="useforreference">
                        <xsl:with-param name="newreference" select="$tempnewaddressreference"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="useforreference">
                        <xsl:with-param name="newreference" select="$currentusage"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </wd:Usage_Data>
    </xsl:template>

    <xsl:template match="tns:supplierupdatefile">
        <xsl:param name="supplierid"/>
        <xsl:for-each-group select=".//supplier_updatedata" group-by="supplierid">
            <xsl:if test="$supplierid = current-grouping-key()">
                <supplier_updatedata>
                    <xsl:attribute name="supplierid" select="current-grouping-key()"/>
                    <xsl:apply-templates select="current-group()">
                        <xsl:with-param name="supplier_updatedata" select="current-grouping-key()"/>
                    </xsl:apply-templates>
                </supplier_updatedata>
            </xsl:if>
        </xsl:for-each-group>
    </xsl:template>

    <xsl:template match="supplier_updatedata">
        <xsl:param name="supplier_updatedata"/>
        <supplierdetaildata>
            <xsl:apply-templates select="@* | node()">
                <xsl:with-param name="supplier_updatedata" select="$supplier_updatedata"/>
            </xsl:apply-templates>
        </supplierdetaildata>
    </xsl:template>

    <xsl:template match="@* | node()">
        <xsl:param name="supplier_updatedata"/>
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@* | node()">
                <xsl:with-param name="supplier_updatedata" select="$supplier_updatedata"/>
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>

    <xsl:template name="useforreference">
        <xsl:param name="newreference"/>
        <xsl:for-each select="tokenize($newreference, ',')">
            <xsl:variable name="tempnewreference" select="normalize-space(.)"/>
            <wd:Use_For_Reference>
                <wd:ID>
                    <xsl:attribute name="wd:type" select="'Communication_Usage_Behavior_ID'"/>
                    <xsl:value-of select="document('')/*/atc:map/use_for_reference[@input = $tempnewreference]"/>
                </wd:ID>
            </wd:Use_For_Reference>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="newalternatenames">
        <xsl:param name="alternatename"/>
        <xsl:param name="alternatenameusage"/>
        <wd:Business_Entity_Alternate_Name_Data>
            <wd:Alternate_Name>
                <xsl:value-of select="$alternatename"/>
            </wd:Alternate_Name>
            <xsl:call-template name="alternatenameusage">
                <xsl:with-param name="newusage" select="$alternatenameusage"/>
            </xsl:call-template>
        </wd:Business_Entity_Alternate_Name_Data>
    </xsl:template>

    <xsl:template name="alternatenameusage">
        <xsl:param name="newusage"/>
        <xsl:for-each select="tokenize($newusage, ',')">
            <xsl:variable name="tempnewusage" select="."/>
            <wd:Alternate_Name_Usage_Reference>
                <wd:ID>
                    <xsl:attribute name="wd:type" select="'Alternate_Name_Usage_ID'"/>
                    <xsl:value-of select="document('')/*/atc:map/name_usage_reference[@input = $tempnewusage]"/>
                </wd:ID>
            </wd:Alternate_Name_Usage_Reference>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="newnotedata">
        <xsl:param name="notedata"/>
        <wd:Note_Data>
            <wd:Created>
                <xsl:value-of select="current-date()"/>
            </wd:Created>
            <wd:Last_Updated>
                <xsl:value-of select="current-date()"/>
            </wd:Last_Updated>
            <wd:Note_Content>
                <xsl:value-of select="$notedata"/>
            </wd:Note_Content>
        </wd:Note_Data>
    </xsl:template>

    <xsl:template name="writenewnode">
        <xsl:param name="node_name"/>
        <xsl:param name="node_value"/>
        <xsl:element name="{$node_name}">
            <xsl:value-of select="$node_value"/>
        </xsl:element>
    </xsl:template>

    <xsl:template name="taxauthority">
        <xsl:param name="inputvalue"/>
        <wd:Tax_Authority_Form_Type_Reference>
            <wd:ID>
                <xsl:attribute name="wd:type" select="'Tax_Authority_Form_Type'"/>
                <xsl:value-of select="replace(upper-case($inputvalue), ' ', '_')"/>
            </wd:ID>
        </wd:Tax_Authority_Form_Type_Reference>
    </xsl:template>

    <xsl:template name="integrationsystem">
        <xsl:param name="inputvalue"/>
        <wd:Integration_System_Reference>
            <wd:ID>
                <xsl:attribute name="wd:type" select="'Integration_System_ID'"/>
                <xsl:value-of select="$inputvalue"/>
            </wd:ID>
        </wd:Integration_System_Reference>
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
