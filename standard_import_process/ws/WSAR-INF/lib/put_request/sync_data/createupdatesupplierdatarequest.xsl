<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:wd="urn:com.workday/bsvc"
    xmlns:env="http://schemas.xmlsoap.org/soap/envelope/" 
    xmlns:ecmc="https://ecmc.org/supplier_format"
    xmlns:intsys="java:com.workday.esb.intsys.xpath.ParsedIntegrationSystemFunctions"
    exclude-result-prefixes="xs env xsl intsys ecmc" version="2.0">

    <xsl:output method="xml" version="1.0" indent="yes"/>
    <xsl:strip-space elements="*"/>

    <xsl:param name="web.service.version"/>
    <xsl:param name="web.service.add.only"/>
    <xsl:param name="web.service.auto.complete"/>
    <xsl:param name="default.business.process.comment"/>
    <xsl:param name="single.instance.update.1.wids" select="'INACTIVE'"/>
    <xsl:param name="single.instance.update.2.wids" select="'INACTIVE'"/>
    <xsl:param name="single.instance.update.3.wids" select="'NO_ACTIVITY'"/>
    <xsl:variable name="supplier.dataupdate" select="document('mctx:vars/externalfile.data')"/>
    <xsl:variable name="supplier_updatedata">
        <xsl:variable name="supplier_currentid" select="//wd:Supplier_ID"/>
        <supplier_updatedata>
            <xsl:apply-templates select="$supplier.dataupdate//supplier_update_file">
                <xsl:with-param name="supplierid" select="$supplier_currentid"/>
            </xsl:apply-templates>
        </supplier_updatedata>
    </xsl:variable>

    <xsl:template match="/">
        <xsl:apply-templates select="//wd:Supplier_Data" mode="#default"/>
    </xsl:template>

    <xsl:template match="wd:Supplier_Data" mode="#default">
        <env:Envelope xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"
            xmlns:wd="urn:com.workday/bsvc">
            <env:Header/>
            <env:Body>
                <wd:Submit_Supplier_Request>
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
                                <xsl:value-of select="$default.business.process.comment"/>
                            </wd:Comment>
                        </wd:Comment_Data>
                    </wd:Business_Process_Parameters>
                    <xsl:apply-templates select="." mode="details"/>
                </wd:Submit_Supplier_Request>
            </env:Body>
        </env:Envelope>
    </xsl:template>

    <xsl:template match="wd:Supplier_Data" mode="details">
        <wd:Supplier_Data>
            <xsl:apply-templates select="node()[not(self::wd:Note_Data)
                and not(self::wd:Settlement_Account_Data)
                and not(self::wd:Areas_Changed)]"/>
            <xsl:apply-templates select="$supplier_updatedata//ecmc:child_supplier"/> 
            <xsl:apply-templates select="$supplier_updatedata//ecmc:notes"/>
            <!--<xsl:for-each select="$supplier_updatedata//supplierdetaildata[lower-case(alternatenameusagecurrent) = 'new']">
                <xsl:call-template name="newalternatenames">
                    <xsl:with-param name="alternatename" select="alternatename"/>
                    <xsl:with-param name="alternatenameusage" select="alternatenameusagenew"/>
                </xsl:call-template>
            </xsl:for-each>-->
            <xsl:if test="count($supplier_updatedata//supplierdetaildata[lower-case(ecmc:supplier_updateremittance) = 'y']) = 1
                and count(.//wd:Integration_System_Reference) = 0">
                <xsl:call-template name="integrationsystem">
                    <xsl:with-param name="inputvalue" select="$single.instance.update.1.wids"/>
                </xsl:call-template>
            </xsl:if>
            <wd:Areas_Changed>
                <wd:Supplier_and_Tax_Details>true</wd:Supplier_and_Tax_Details>
                <wd:Payment_Details>true</wd:Payment_Details>
                <wd:Supplier_Hierarchy>true</wd:Supplier_Hierarchy>
                <wd:Contact_Information>false</wd:Contact_Information>
                <wd:Settlement_Bank_Account>false</wd:Settlement_Bank_Account>
                <wd:Alternate_Names>false</wd:Alternate_Names>
                <wd:Procurement_Options>true</wd:Procurement_Options>
                <wd:Classifications>true</wd:Classifications>
                <wd:Contingent__Worker__Options>false</wd:Contingent__Worker__Options>
                <wd:Attachments>false</wd:Attachments>
            </wd:Areas_Changed>
        </wd:Supplier_Data>
    </xsl:template>

    <xsl:template match="wd:Supplier_Data/wd:Currency_Reference">
        <wd:Currency_Reference>
            <wd:ID wd:type="Currency_ID">
                <xsl:value-of select="wd:ID[@wd:type='Currency_ID']"/>
            </wd:ID>
        </wd:Currency_Reference>
    </xsl:template>

    <xsl:template match="wd:Accepted_Currencies_Reference">
        <wd:Accepted_Currencies_Reference>
            <wd:ID wd:type="Currency_ID">
                <xsl:value-of select="wd:ID[@wd:type='Currency_ID']"/>
            </wd:ID>
        </wd:Accepted_Currencies_Reference>
    </xsl:template>

    <xsl:template match="wd:Supplier_Status_Data">
        <wd:Supplier_Status_Data>
            <xsl:variable name="currentstatus" select="wd:Status_Reference/wd:ID[@wd:type = 'Business_Entity_Status_Value_ID']"/>
            <xsl:choose>
                <xsl:when test="count($supplier_updatedata//supplierdetaildata[lower-case(ecmc:supplier_status) = 'inactive']) = 1">
                    <wd:Status_Reference>
                        <wd:ID>
                            <xsl:attribute name="wd:type" select="'WID'"/>
                            <xsl:value-of select="$single.instance.update.2.wids"/>
                        </wd:ID>
                    </wd:Status_Reference>
                    <wd:Reason_Reference>
                        <wd:ID>
                            <xsl:attribute name="wd:type" select="'WID'"/>
                            <xsl:value-of select="$single.instance.update.3.wids"/>
                        </wd:ID>
                    </wd:Reason_Reference>
                </xsl:when>
                <xsl:when test="count($supplier_updatedata//supplierdetaildata[lower-case(ecmc:supplier_status) = 'inactive']) = count($supplier_updatedata//supplierdetaildata)
                        and count($supplier_updatedata//supplierdetaildata) != 0">
                    <wd:Status_Reference>
                        <wd:ID>
                            <xsl:attribute name="wd:type" select="'WID'"/>
                            <xsl:value-of select="$single.instance.update.2.wids"/>
                        </wd:ID>
                    </wd:Status_Reference>
                    <wd:Reason_Reference>
                        <wd:ID>
                            <xsl:attribute name="wd:type" select="'WID'"/>
                            <xsl:value-of select="$single.instance.update.3.wids"/>
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
            <xsl:choose>
                <xsl:when test="$supplier_updatedata//supplierdetaildata[string-length(ecmc:supplier_change_reason) != 0]">
                    <wd:Reason_Description>
                        <xsl:value-of select="$supplier_updatedata//supplierdetaildata[1]/ecmc:supplier_change_reason"/>
                    </wd:Reason_Description>
                </xsl:when>
                <xsl:otherwise>
                    <wd:Reason_Description>
                        <xsl:value-of select="$default.business.process.comment"/>
                    </wd:Reason_Description>
                </xsl:otherwise>
            </xsl:choose>
        </wd:Supplier_Status_Data>
    </xsl:template>

    <xsl:template match="wd:Business_Entity_Name">
        <wd:Business_Entity_Name>
            <xsl:value-of select="."/>
        </wd:Business_Entity_Name>
    </xsl:template>

    <xsl:template match="wd:Supplier_Name">
        <wd:Supplier_Name>
            <xsl:value-of select="."/>
        </wd:Supplier_Name>
    </xsl:template>

    <xsl:template match="wd:Payment_Types_Accepted_Reference">
        <wd:Payment_Types_Accepted_Reference>
            <wd:ID wd:type="Payment_Type_ID">
                <xsl:value-of select="wd:ID[@wd:type='Payment_Type_ID']"/>
            </wd:ID>
        </wd:Payment_Types_Accepted_Reference>
    </xsl:template>

    <xsl:template match="wd:Business_Entity_Data">
        <wd:Business_Entity_Data>
            <xsl:apply-templates select="node()[not(self::wd:Contact_Data)
                and not(self::wd:Business_Entity_Tax_ID)]"/>
        </wd:Business_Entity_Data>
    </xsl:template>

    <xsl:template match="wd:Business_Entity_Tax_ID">
        <wd:Business_Entity_Tax_ID>
            <xsl:value-of select="."/>
        </wd:Business_Entity_Tax_ID>
    </xsl:template>

    <xsl:template match="wd:Tax_Authority_Form_Type_Reference">
        <wd:Tax_Authority_Form_Type_Reference>
            <wd:ID>
                <xsl:attribute name="wd:type" select="'Tax_Authority_Form_Type'"/>
                <xsl:value-of select="wd:ID[@wd:type = 'Tax_Authority_Form_Type']"/>
            </wd:ID>
        </wd:Tax_Authority_Form_Type_Reference>
    </xsl:template>

    <xsl:template match="wd:IRS_1099_Supplier">
        <wd:IRS_1099_Supplier>
            <xsl:value-of select="."/>
        </wd:IRS_1099_Supplier>
    </xsl:template>

    <xsl:template match="wd:Included_Children_Reference">
        <xsl:if test="not(contains(@wd:Descriptor,'(Inactive)'))">
            <xsl:copy-of select="."/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="wd:Business_Entity_Alternate_Name_Data">
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
        <wd:Address_Data>
            <xsl:attribute name="wd:Effective_Date" select="current-date()"/>
            <xsl:apply-templates select="node()"/>
        </wd:Address_Data>
    </xsl:template>

    <xsl:template match="wd:Payment_Terms_Reference">
        <wd:Payment_Terms_Reference>
            <wd:ID>
                <xsl:attribute name="wd:type" select="'Payment_Terms_ID'"/>
                <xsl:value-of select="wd:ID[@wd:type = 'Payment_Terms_ID']"/>
            </wd:ID>
        </wd:Payment_Terms_Reference>
    </xsl:template>

    <xsl:template match="wd:Supplier_Category_Reference">
        <wd:Supplier_Category_Reference>
            <wd:ID>
                <xsl:attribute name="wd:type" select="'Supplier_Category_ID'"/>
                <xsl:choose>
                    <xsl:when test="count($supplier_updatedata//supplierdetaildata[string-length(ecmc:supplier_category_id) != 0 and ecmc:supplier_category_id != 'null']) = 1">
                        <xsl:value-of select="$supplier_updatedata//supplierdetaildata[1]/ecmc:supplier_category_id"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="wd:ID[@wd:type = 'Supplier_Category_ID']"/>
                    </xsl:otherwise>
                </xsl:choose>
            </wd:ID>
        </wd:Supplier_Category_Reference>
    </xsl:template>

    <xsl:template match="wd:Supplier_Group_Reference">
        <wd:Supplier_Group_Reference>
            <wd:ID>
                <xsl:attribute name="wd:type" select="'Supplier_Group_ID'"/>
                <xsl:value-of select="wd:ID[@wd:type = 'Supplier_Group_ID']"/>
            </wd:ID>
        </wd:Supplier_Group_Reference>
    </xsl:template>

    <xsl:template match="wd:Usage_Data">
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
            <xsl:apply-templates select="wd:Type_Data"/>
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

    <xsl:template match="ecmc:child_supplier">
        <wd:Proposed_Children_Reference>
            <wd:ID>
                <xsl:attribute name="wd:type" select="'Supplier_ID'"/>
                <xsl:value-of select="."/>
            </wd:ID>
        </wd:Proposed_Children_Reference>
    </xsl:template>
    <xsl:template match="supplier_update_file">
        <xsl:param name="supplierid"/>
        <xsl:for-each-group select=".//ecmc:supplier_update_record" group-by="ecmc:supplier_id">
            <xsl:if test="$supplierid = current-grouping-key()">
                <ecmc:supplier_update_record>
                    <xsl:attribute name="supplierid" select="current-grouping-key()"/>
                    <!-- <xsl:apply-templates select="current-group()">
                        <xsl:with-param name="supplier_updatedata" select="current-grouping-key()"/>
                    </xsl:apply-templates> -->
                    <xsl:copy-of select="current-group()"/>
                </ecmc:supplier_update_record>
            </xsl:if>
        </xsl:for-each-group>
    </xsl:template>

    <xsl:template match="ecmc:supplier_update_record">
        <supplierdetaildata>
            <xsl:apply-templates select="@* | node()"/>
        </supplierdetaildata>
    </xsl:template>

    <xsl:template match="@* |node()">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@* |node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template name="useforreference">
        <xsl:param name="newreference"/>
        <xsl:for-each select="tokenize($newreference, ',')">
            <xsl:variable name="tempnewreference" select="normalize-space(.)"/>
            <wd:Use_For_Reference>
                <wd:ID>
                    <xsl:attribute name="wd:type" select="'Communication_Usage_Behavior_ID'"/>
                    <xsl:value-of select="document('')/*/ecmc:map/use_for_reference[@input = $tempnewreference]"/>
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
                    <xsl:value-of select="document('')/*/ecmc:map/name_usage_reference[@input = $tempnewusage]"/>
                </wd:ID>
            </wd:Alternate_Name_Usage_Reference>
        </xsl:for-each>
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
                <xsl:attribute name="wd:type" select="'WID'"/>
                <xsl:value-of select="$inputvalue"/>
            </wd:ID>
        </wd:Integration_System_Reference>
    </xsl:template>

    <ecmc:map>
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
    </ecmc:map>

</xsl:stylesheet>
