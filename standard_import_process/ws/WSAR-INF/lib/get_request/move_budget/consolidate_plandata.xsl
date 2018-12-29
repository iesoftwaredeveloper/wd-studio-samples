<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:bsvc="urn:com.workday/bsvc"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ecmc="https://ecmc.org/budget_format"
    xmlns:fhc="https://firehawk-consulting.com/data_lookups"
    xmlns:je="urn:com.workday.report/PLAN_Extract_for_Allocation_Conversion"
    xmlns:is="java:com.workday.esb.intsys.xpath.ParsedIntegrationSystemFunctions" 
    xmlns:tv="java:com.workday.esb.intsys.TypedValue"
    exclude-result-prefixes="xs je xsl tv is"
    version="2.0">

    <xsl:output indent="yes" method="xml"/>

    <xsl:param name="running.process"/>
    <xsl:param name="process.type"/>
    <xsl:param name="multi.instance.update.1.wids"/>
    <xsl:param name="multi.instance.update.2.wids"/>
    <xsl:param name="multi.instance.update.3.wids"/>
    <xsl:param name="single.instance.update.1.wids"/>
    <xsl:param name="single.instance.update.2.wids"/>
    <xsl:param name="single.instance.update.3.wids"/>
    <xsl:param name="single.instance.update.1.name"/>
    <xsl:param name="single.instance.update.2.name"/>
    <xsl:param name="single.instance.update.3.name"/>
    <xsl:param name="web.service.version"/>
    <xsl:param name="web.service.count"/>
    <xsl:param name="web.service.add.only"/>
    <xsl:param name="web.service.submit"/>
    <xsl:param name="web.service.auto.complete"/>
    <xsl:param name="disable.optional.worktag.balancing" select="true()"/>
    <xsl:param name="web.service.lock.transaction"/>
    <xsl:param name="web.service.request.type" select="'default'"/>
    <xsl:param name="default.memo"/>

    <xsl:variable name="period-delim"><xsl:text>/</xsl:text></xsl:variable>

    <xsl:function name="fhc:forceValue">
        <xsl:param name="inputValue"/>
        <xsl:choose>
            <xsl:when test="$inputValue = ''">
                <xsl:value-of select="' '"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$inputValue"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="fhc:getCompanyValue">
        <xsl:param name="CompanyID"/>
        <xsl:param name="AllocationID"/>
        <xsl:choose>
            <xsl:when test="string-length(normalize-space(fhc:forceValue($AllocationID))) != 0">
                <xsl:value-of select="$AllocationID"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$CompanyID"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <xsl:function name="ecmc:ApplyReverseMap">
        <xsl:param name="mapName"/>
        <xsl:param name="externalValue"/>
        <xsl:param name="overrideExternalValue"/>
        <xsl:param name="referenceId"/>
        <xsl:variable name="lookup" select="is:integrationMapReverseLookup(string($mapName), string($externalValue))"/>
        <xsl:variable name="overrideLookup" select="is:integrationMapReverseLookup(string($mapName), string($overrideExternalValue))"/>
        <xsl:choose>
            <xsl:when test="count($overrideLookup) != 0">
                <xsl:value-of select="tv:getReferenceData($overrideLookup[1], string($referenceId))"/>
            </xsl:when>
            <xsl:when test="count($lookup) != 0">
                <xsl:value-of select="tv:getReferenceData($lookup[1], string($referenceId))"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$externalValue"/>
            </xsl:otherwise>
        </xsl:choose>
        <!--<xsl:value-of select="concat(string($mapName),'-',string($externalValue),'-', string($referenceId))"/>-->
    </xsl:function>

    <xsl:template match="/">
        <consolidate_data>
            <xsl:apply-templates select="//je:Report_Data"/>
        </consolidate_data>
    </xsl:template>

    <xsl:template match="je:Report_Data">
        <xsl:for-each-group select="je:Report_Entry" group-by="fhc:getCompanyValue(je:Company/je:ID[@je:type = 'Organization_Reference_ID'],fhc:forceValue(je:allocation_only/@je:Descriptor))">
            <ecmc:budget_load>
                <xsl:attribute name="ecmc:budget_name">
                    <xsl:value-of select="ecmc:ApplyReverseMap('Target Plan From [Company-Process Type] Lookup',concat(current-grouping-key(),'-',$process.type),$process.type,'Custom_Budget_ID')"/>
                </xsl:attribute>
                <xsl:apply-templates select="current-group()" mode="new_line">
                    <xsl:with-param name="company-id" select="current-grouping-key()"/>
                </xsl:apply-templates>
            </ecmc:budget_load>
        </xsl:for-each-group>
    </xsl:template>

    <xsl:template match="je:Report_Entry" mode="new_line">
        <xsl:param name="company-id"/>
        <xsl:variable name="debit_balance">
            <xsl:value-of select="xs:decimal(je:Ledger_Budget_Debit_Amount) - xs:decimal(je:Ledger_Budget_Credit_Amount)"/>
        </xsl:variable>
        <xsl:variable name="credit_balance">
            <xsl:value-of select="xs:decimal(je:Ledger_Budget_Credit_Amount) - xs:decimal(je:Ledger_Budget_Debit_Amount)"/>
        </xsl:variable>
        <xsl:if test="$debit_balance != 0">
            <ecmc:budget_record>
                <xsl:attribute name="ecmc:budget_name">
                    <xsl:value-of select="ecmc:ApplyReverseMap('Target Plan From [Company-Process Type] Lookup',concat($company-id,'-',$process.type),$process.type,'Custom_Budget_ID')"/>
                </xsl:attribute>
                <xsl:attribute name="row-number" select="position()"/>
                <xsl:attribute name="ecmc:record-group">
                    <xsl:value-of select="je:Year/je:ID[@je:type != 'WID']"/>
                    <xsl:value-of select="'-'"/>
                    <xsl:value-of select="je:Period/je:ID[@je:type='Fiscal_Posting_Interval_ID']"/>
                    <xsl:value-of select="'-'"/>
                    <xsl:value-of select="$company-id"/>
                    <xsl:value-of select="'-'"/>
                    <xsl:value-of select="je:Ledger_Account/je:ID[@je:type = 'Ledger_Account_ID']"/>
                    <xsl:value-of select="'-'"/>
                    <xsl:value-of select="je:Cost_Center/je:ID[@je:type = 'Organization_Reference_ID']"/>
                    <xsl:value-of select="'-'"/>
                    <xsl:value-of select="je:Region/je:ID[@je:type = 'Organization_Reference_ID']"/>
                    <xsl:value-of select="'-'"/>
                    <xsl:value-of select="je:Project/je:ID[@je:type = 'Project_ID']"/>
                    <xsl:value-of select="'-'"/>
                    <!-- <xsl:value-of select="je:Entry_Type/je:ID[@je:type = 'Project_ID']"/>
                    <xsl:value-of select="'-'"/> -->
                    <xsl:value-of select="je:Revenue_Category/je:ID[@je:type = 'Revenue_Category_ID']"/>
                    <xsl:value-of select="'-'"/>
                    <xsl:value-of select="je:Spend_Category/je:ID[@je:type = 'Spend_Category_ID']"/>
                    <xsl:value-of select="'-'"/>
                    <xsl:value-of select="je:Initiatives/je:ID[@je:type = 'Organization_Reference_ID']"/>
                </xsl:attribute>
                <ecmc:company>
                    <xsl:attribute name="original_company" select="je:Company/je:ID[@je:type = 'Organization_Reference_ID']"/>
                    <xsl:attribute name="allocation_only" select="je:allocation_only/@je:Descriptor"/>
                    <xsl:value-of select="$company-id"/>
                </ecmc:company>
                <ecmc:year>
                    <xsl:value-of select="je:Year/je:ID[@je:type != 'WID']"/>
                </ecmc:year>
                <ecmc:posting_interval>
                    <xsl:value-of select="je:Period/je:ID[@je:type='Fiscal_Posting_Interval_ID']"/>
                </ecmc:posting_interval>
                <ecmc:account>
                    <xsl:attribute name="bsvc:type" select="'Ledger_Account_ID'"/>
                    <xsl:attribute name="bsvc:parent_id" select="'Standard'"/>
                    <xsl:attribute name="bsvc:parent_type" select="'Account_Set_ID'"/>
                    <xsl:value-of select="je:Ledger_Account/je:ID[@je:type = 'Ledger_Account_ID']"/>
                </ecmc:account>
                <xsl:choose>
                    <xsl:when test="xs:decimal(je:Ledger_Budget_Credit_Amount) != 0 
                        and xs:decimal(je:Ledger_Budget_Debit_Amount) != 0
                        and $debit_balance &gt; 0">
                        <ecmc:debit_amount>
                            <xsl:value-of select="$debit_balance"/>
                        </ecmc:debit_amount>
                        <ecmc:credit_amount>
                            <xsl:value-of select="0"/>
                        </ecmc:credit_amount>
                    </xsl:when>
                    <xsl:when test="xs:decimal(je:Ledger_Budget_Credit_Amount) != 0 
                        and xs:decimal(je:Ledger_Budget_Debit_Amount) != 0
                        and $credit_balance &gt; 0">
                        <ecmc:debit_amount>
                            <xsl:value-of select="0"/>
                        </ecmc:debit_amount>
                        <ecmc:credit_amount>
                            <xsl:value-of select="$credit_balance"/>
                        </ecmc:credit_amount>
                    </xsl:when>
                    <xsl:otherwise>
                        <ecmc:debit_amount>
                            <xsl:value-of select="je:Ledger_Budget_Debit_Amount"/>
                        </ecmc:debit_amount>
                        <ecmc:credit_amount>
                            <xsl:value-of select="je:Ledger_Budget_Credit_Amount"/>
                        </ecmc:credit_amount>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:if test="string-length(je:Cost_Center) != 0">
                    <ecmc:cost_center>
                        <xsl:value-of select="je:Cost_Center/je:ID[@je:type = 'Organization_Reference_ID']"/>
                    </ecmc:cost_center>
                </xsl:if>
                <xsl:if test="string-length(je:Region) != 0">
                    <ecmc:region>
                        <xsl:value-of select="je:Region/je:ID[@je:type = 'Organization_Reference_ID']"/>
                    </ecmc:region>
                </xsl:if>
                <xsl:if test="string-length(je:Project) != 0">
                    <bsvc:Accounting_Worktag_Reference>
                        <bsvc:ID bsvc:type="Project_ID">
                            <xsl:value-of select="je:Project/je:ID[@je:type = 'Project_ID']"/>
                        </bsvc:ID>
                    </bsvc:Accounting_Worktag_Reference>
                </xsl:if>
                <xsl:if test="string-length(je:Initiatives) != 0">
                    <bsvc:Accounting_Worktag_Reference>
                        <bsvc:ID bsvc:type="Organization_Reference_ID">
                            <xsl:value-of select="je:Initiatives/je:ID[@je:type = 'Organization_Reference_ID']"/>
                        </bsvc:ID>
                    </bsvc:Accounting_Worktag_Reference>
                </xsl:if>
                <xsl:if test="string-length(je:Revenue_Category) != 0">
                    <ecmc:revenue_category>
                        <xsl:value-of select="je:Revenue_Category/je:ID[@je:type = 'Revenue_Category_ID']"/>
                    </ecmc:revenue_category>
                </xsl:if>
                <xsl:if test="string-length(je:Spend_Category) != 0">
                    <ecmc:spend_category>
                        <xsl:value-of select="je:Spend_Category/je:ID[@je:type = 'Spend_Category_ID']"/>
                    </ecmc:spend_category>
                </xsl:if>
            </ecmc:budget_record>
        </xsl:if>
    </xsl:template>

    <xsl:template match="@* | node()">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
