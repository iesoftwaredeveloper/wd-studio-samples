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
    xmlns:sd="urn:com.workday.report/Statistic_Data_for_Headcount_Cost_of_Workforce"
    exclude-result-prefixes="xs je xsl sd"
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

    <xsl:variable name="hc.allocation.data" select="document('mctx:vars/hc.amt.lookup.data')"/>
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

    <xsl:function name="fhc:getRegionValue">
        <xsl:param name="BUName"/>
        <xsl:param name="BUID"/>
        <xsl:choose>
            <xsl:when test="$BUID = '50160'">
                <xsl:value-of select="'38015'"/>
            </xsl:when>
            <xsl:when test="contains(lower-case($BUName),'zzz')">
                <xsl:value-of select="'00'"/>
                <xsl:value-of select="substring($BUID,3,3)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="substring-before($BUID,'_INACTIVE')"/>
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
        <xsl:for-each-group select="je:Report_Entry" group-by="ecmc:ApplyReverseMap('Target Plan From [Company-Process Type] Lookup',concat(fhc:getCompanyValue(je:Company/je:ID[@je:type = 'Organization_Reference_ID'],fhc:forceValue(je:allocation_only/@je:Descriptor)),'-',$process.type),$process.type,'Custom_Budget_ID')">
            <ecmc:budget_load>
                <xsl:attribute name="ecmc:budget_name">
                    <xsl:value-of select="current-grouping-key()"/>
                </xsl:attribute>
                <xsl:apply-templates select="current-group()" mode="new_line"/>
            </ecmc:budget_load>
        </xsl:for-each-group>
    </xsl:template>

    <xsl:template match="je:Report_Entry" mode="new_line">
        <xsl:variable name="current-report-entry">
            <xsl:copy-of select="."/>
        </xsl:variable>
        <xsl:variable name="month_value" select="je:Period/je:ID[@je:type='Fiscal_Posting_Interval_ID']"/>
        <xsl:variable name="planned_hc" select="je:Planned_Headcount"/>
        <xsl:variable name="cost_of_workforce" select="je:Cost_of_Workforce_Amount"/>
        <xsl:variable name="mapped_company">
            <xsl:value-of select="fhc:getCompanyValue(je:Company/je:ID[@je:type = 'Organization_Reference_ID'],fhc:forceValue(je:allocation_only/@je:Descriptor))"/>
        </xsl:variable>
        <xsl:apply-templates select="." mode="details">
            <xsl:with-param name="spend_category_id" select="'SC_161'"/>
            <xsl:with-param name="workforce_cost" select="je:Cost_of_Workforce_Amount"/>
            <xsl:with-param name="posting_month" select="$month_value"/>
        </xsl:apply-templates>
        <xsl:for-each select="$hc.allocation.data//sd:company_statistics[@company_id = $mapped_company]/sd:monthly_detail[@month = $month_value]">
            <xsl:apply-templates select="$current-report-entry" mode="details">
                <xsl:with-param name="spend_category_id" select="./sd:spend_category"/>
                <xsl:with-param name="workforce_cost">
                    <xsl:choose>
                        <xsl:when test="./sd:type = 'amount_per_hc'">
                            <xsl:value-of select="$planned_hc * ./sd:value"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$cost_of_workforce * ./sd:value"/>
                         </xsl:otherwise>
                    </xsl:choose>
                </xsl:with-param>
                <xsl:with-param name="posting_month" select="$month_value"/>
            </xsl:apply-templates>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="je:Report_Entry" mode="details">
        <xsl:param name="spend_category_id"/>
        <xsl:param name="workforce_cost"/>
        <xsl:param name="posting_month"/>
        <xsl:variable name="debit_balance">
            <xsl:value-of select="xs:decimal($workforce_cost)"/>
        </xsl:variable>
        <xsl:variable name="credit_balance">
            <xsl:value-of select="0 - xs:decimal($workforce_cost)"/>
        </xsl:variable>
        <xsl:if test="$debit_balance != 0">
            <ecmc:budget_record>
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
                    <xsl:value-of select="je:Revenue_Category/je:ID[@je:type = 'Revenue_Category_ID']"/>
                    <xsl:value-of select="'-'"/>
                    <xsl:value-of select="je:Spend_Category/je:ID[@je:type = 'Spend_Category_ID']"/>
                </xsl:attribute>
                <ecmc:company>
                    <xsl:attribute name="original_company" select="je:Company/je:ID[@je:type = 'Organization_Reference_ID']"/>
                    <xsl:attribute name="allocation_only" select="je:allocation_only/@je:Descriptor"/>
                    <xsl:value-of select="fhc:getCompanyValue(je:Company/je:ID[@je:type = 'Organization_Reference_ID'],fhc:forceValue(je:allocation_only/@je:Descriptor))"/>
                </ecmc:company>
                <ecmc:year>
                    <xsl:value-of select="je:Year/je:ID[@je:type != 'WID']"/>
                </ecmc:year>
                <ecmc:posting_interval>
                    <xsl:value-of select="$posting_month"/>
                </ecmc:posting_interval>
                <ecmc:account>
                    <xsl:attribute name="bsvc:type" select="'Ledger_Account_ID'"/>
                    <xsl:attribute name="bsvc:parent_id" select="'Standard'"/>
                    <xsl:attribute name="bsvc:parent_type" select="'Account_Set_ID'"/>
                    <xsl:value-of select="document('')/*/ecmc:data_map_lookups/ecmc:ledger_account_lkp[@spend_category = $spend_category_id]"/>
                </ecmc:account>
                <xsl:choose>
                    <xsl:when test="$debit_balance &gt; 0">
                        <ecmc:debit_amount>
                            <xsl:value-of select="$debit_balance"/>
                        </ecmc:debit_amount>
                        <ecmc:credit_amount>
                            <xsl:value-of select="0"/>
                        </ecmc:credit_amount>
                    </xsl:when>
                    <xsl:when test="$credit_balance &gt; 0">
                        <ecmc:debit_amount>
                            <xsl:value-of select="0"/>
                        </ecmc:debit_amount>
                        <ecmc:credit_amount>
                            <xsl:value-of select="$credit_balance"/>
                        </ecmc:credit_amount>
                    </xsl:when>
                    <xsl:otherwise>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:if test="string-length(je:Cost_Center) != 0">
                    <ecmc:cost_center>
                        <xsl:value-of select="je:Cost_Center/je:ID[@je:type = 'Organization_Reference_ID']"/>
                    </ecmc:cost_center>
                </xsl:if>
                <xsl:if test="string-length(je:Region) != 0">
                    <xsl:choose>
                        <xsl:when test="exists(je:Region/je:ID[@je:type='Custom_Organization_Reference_ID'])">
                            <ecmc:region>
                                <xsl:value-of select="fhc:getRegionValue(je:Region/@je:Descriptor,je:Region/je:ID[@je:type = 'Organization_Reference_ID'])"/>
                            </ecmc:region>
                        </xsl:when>
                        <xsl:otherwise>
                            <ecmc:region>
                                <xsl:value-of select="je:Region/je:ID[@je:type = 'Organization_Reference_ID']"/>
                            </ecmc:region>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
                <xsl:if test="string-length(je:Project) != 0">
                    <bsvc:Worktags_Reference>
                        <bsvc:ID bsvc:type="Project_ID">
                            <xsl:value-of select="je:Project/je:ID[@je:type = 'Project_ID']"/>
                        </bsvc:ID>
                    </bsvc:Worktags_Reference>
                </xsl:if>
                <xsl:if test="string-length(je:Revenue_Category) != 0">
                    <ecmc:revenue_category>
                        <xsl:value-of select="je:Revenue_Category/je:ID[@je:type = 'Revenue_Category_ID']"/>
                    </ecmc:revenue_category>
                </xsl:if>
                <ecmc:spend_category>
                    <xsl:value-of select="$spend_category_id"/>
                </ecmc:spend_category>
            </ecmc:budget_record>
        </xsl:if>
    </xsl:template>

    <ecmc:data_map_lookups>
        <ecmc:ledger_account_lkp spend_category="SC_121">50260</ecmc:ledger_account_lkp>
        <ecmc:ledger_account_lkp spend_category="SC_191">50260</ecmc:ledger_account_lkp>
        <ecmc:ledger_account_lkp spend_category="SC_189">50260</ecmc:ledger_account_lkp>
        <ecmc:ledger_account_lkp spend_category="SC_202">50260</ecmc:ledger_account_lkp>
        <ecmc:ledger_account_lkp spend_category="SC_201">50260</ecmc:ledger_account_lkp>
        <ecmc:ledger_account_lkp spend_category="SC_197">50270</ecmc:ledger_account_lkp>
        <ecmc:ledger_account_lkp spend_category="SC_193">50270</ecmc:ledger_account_lkp>
        <ecmc:ledger_account_lkp spend_category="SC_198">50270</ecmc:ledger_account_lkp>
        <ecmc:ledger_account_lkp spend_category="SC_199">50270</ecmc:ledger_account_lkp>
        <ecmc:ledger_account_lkp spend_category="SC_240">50390</ecmc:ledger_account_lkp>
        <ecmc:ledger_account_lkp spend_category="SC_172">50260</ecmc:ledger_account_lkp>
        <ecmc:ledger_account_lkp spend_category="SC_192">50270</ecmc:ledger_account_lkp>
        <ecmc:ledger_account_lkp spend_category="SC_204">50390</ecmc:ledger_account_lkp>
        <ecmc:ledger_account_lkp spend_category="SC_206">50390</ecmc:ledger_account_lkp>
        <ecmc:ledger_account_lkp spend_category="SC_207">50420</ecmc:ledger_account_lkp>
        <ecmc:ledger_account_lkp spend_category="SC_226">50270</ecmc:ledger_account_lkp>
        <ecmc:ledger_account_lkp spend_category="SC_208">50420</ecmc:ledger_account_lkp>
        <ecmc:ledger_account_lkp spend_category="SC_210">50420</ecmc:ledger_account_lkp>
        <ecmc:ledger_account_lkp spend_category="SC_161">50000</ecmc:ledger_account_lkp>
        <ecmc:ledger_account_lkp spend_category="SC_187">50170</ecmc:ledger_account_lkp>
    </ecmc:data_map_lookups>

</xsl:stylesheet>
