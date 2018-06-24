<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:bsvc="urn:com.workday/bsvc"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:je="urn:com.workday.report/Journal_Entry_Extract_for_Conversion"
    xmlns:fhc="http://firehawk.github.com"
    exclude-result-prefixes="xs je xsl"
    version="2.0">

    <xsl:output indent="yes" method="xml"/>

    <xsl:param name="running.process"/>
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
    <xsl:variable name="key-delim"><xsl:text>-</xsl:text></xsl:variable>
    <xsl:variable name="journal.data" select="document('mctx:vars/lookup.data')"/>

    <xsl:function name="fhc:forceValue">
        <xsl:param name="inputValue"/>
        <xsl:param name="defaultValue"/>
        <xsl:choose>
            <xsl:when test="string-length(xs:string($inputValue)) = 0">
                <xsl:value-of select="$defaultValue"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$inputValue"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <xsl:function name="je:getRegionValue">
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

    <xsl:template match="/">
        <consolidate_data>
            <xsl:apply-templates select="//je:Report_Data"/>
        </consolidate_data>
    </xsl:template>

    <xsl:template match="je:Report_Data">
        <xsl:for-each-group select="je:Report_Entry" group-by="je:Company">
            <xsl:for-each-group select="current-group()" group-by="fhc:forceValue(je:Period,'')">
                <xsl:for-each-group select="current-group()" group-by="fhc:forceValue(je:Book_Code/je:ID[@je:type='Book_Code_ID'],'')">
                    <xsl:variable name="book_code" select="je:Book_Code/je:ID[@je:type='Book_Code_ID']"/>
                    <bsvc:Import_Accounting_Journal_Request>
                        <xsl:attribute name="bsvc:Add_Only" select="$web.service.add.only"/>
                        <xsl:attribute name="bsvc:Create_Journal_with_Errors" select="1"/>
                        <xsl:attribute name="bsvc:version" select="$web.service.version"/>
                        <xsl:variable name="period_end_date">
                            <xsl:value-of select="concat(substring(je:Period,7,4),'-',substring(je:Period,1,2),'-',substring(je:Period,4,2))"/>
                        </xsl:variable>
                        <xsl:variable name="journal_id">
                            <xsl:value-of select="je:Company/je:ID[@je:type = 'Organization_Reference_ID']"/>
                            <xsl:value-of select="'-'"/>
                            <xsl:value-of select="format-date(xs:date($period_end_date),'[Y0001][M01][D01]')"/>
                            <xsl:value-of select="'-'"/>
                            <xsl:value-of select="$book_code"/>
                            <xsl:if test="$running.process = 'Journal Entry Beginning Balances (2017)'">
                                <xsl:value-of select="'-begbal'"/>
                            </xsl:if>
                        </xsl:variable>
                        <xsl:variable name="existing.journal.data">
                            <xsl:copy-of select="$journal.data//journal_request[@journal_id=$journal_id]"/>
                        </xsl:variable>
                        <bsvc:Business_Process_Parameters>
                            <bsvc:Auto_Complete>
                                <xsl:value-of select="$web.service.auto.complete"/>
                            </bsvc:Auto_Complete>
                        </bsvc:Business_Process_Parameters>
                        <bsvc:Accounting_Journal_Data>
                            <bsvc:Accounting_Journal_ID>
                                <xsl:value-of select="$journal_id"/>
                                <xsl:value-of select="'-'"/>
                                <xsl:value-of select="'payaudit'"/>
                            </bsvc:Accounting_Journal_ID>
                            <bsvc:Submit>
                                <xsl:value-of select="$web.service.submit"/>
                            </bsvc:Submit>
                            <bsvc:Disable_Optional_Worktag_Balancing>
                                <xsl:value-of select="$disable.optional.worktag.balancing"/>
                            </bsvc:Disable_Optional_Worktag_Balancing>
                            <bsvc:Locked_in_Workday>
                                <xsl:value-of select="$web.service.lock.transaction"/>
                            </bsvc:Locked_in_Workday>
                            <bsvc:Round_Ledger_Amounts>false</bsvc:Round_Ledger_Amounts>
                            <!--<bsvc:Journal_Number>
                            </bsvc:Journal_Number>-->
                            <bsvc:Company_Reference>
                                <bsvc:ID bsvc:type="Organization_Reference_ID">
                                    <xsl:value-of select="je:Company/je:ID[@je:type = 'Organization_Reference_ID']"/>
                                </bsvc:ID>
                            </bsvc:Company_Reference>
                            <bsvc:Currency_Reference>
                                <bsvc:ID bsvc:type="Currency_ID">USD</bsvc:ID>
                            </bsvc:Currency_Reference>
                            <bsvc:Ledger_Type_Reference>
                                <bsvc:ID bsvc:type="Ledger_Type_ID">Actuals</bsvc:ID>
                            </bsvc:Ledger_Type_Reference>
                            <xsl:if test="$book_code != ''">
                                <bsvc:Book_Code_Reference>
                                    <bsvc:ID bsvc:type="Book_Code_ID">
                                        <xsl:value-of select="$book_code"/>
                                    </bsvc:ID>
                                </bsvc:Book_Code_Reference>
                            </xsl:if>
                            <bsvc:Accounting_Date>
                                <xsl:value-of select="format-date(xs:date($period_end_date),'[Y0001]-[M01]-[D01]')"/>
                            </bsvc:Accounting_Date>
                            <bsvc:Journal_Source_Reference>
                                <bsvc:ID bsvc:type="WID">
                                    <xsl:value-of select="$single.instance.update.1.wids"/>
                                </bsvc:ID>
                            </bsvc:Journal_Source_Reference>
                            <!--<bsvc:Balancing_Worktag_Reference>
                                <bsvc:ID bsvc:type="string">string</bsvc:ID>
                            </bsvc:Balancing_Worktag_Reference>
                            <bsvc:Optional_Balancing_Worktags_Reference>
                                <bsvc:ID bsvc:type="string">string</bsvc:ID>
                            </bsvc:Optional_Balancing_Worktags_Reference>-->
                            <bsvc:Record_Quantity>false</bsvc:Record_Quantity>
                            <bsvc:Journal_Entry_Memo>
                                <xsl:value-of select="$default.memo"/>
                            </bsvc:Journal_Entry_Memo>
                            <bsvc:External_Reference_ID>
                            </bsvc:External_Reference_ID>
                            <bsvc:Adjustment_Journal>true</bsvc:Adjustment_Journal>
                            <bsvc:Include_Tax_Lines>false</bsvc:Include_Tax_Lines>
                            <bsvc:Create_Reversal>false</bsvc:Create_Reversal>
                            <!--<bsvc:Reversal_Date>2013-12-21+00:00</bsvc:Reversal_Date>-->
                            <!-- <bsvc:Control_Total_Amount>
                                <xsl:value-of select="sum(current-group//je:Ledger_Debit_Amount)"/>
                            </bsvc:Control_Total_Amount> -->
                            <xsl:apply-templates select="current-group()" mode="new_line">
                                <xsl:with-param name="journal_id" select="$journal_id"/>
                            </xsl:apply-templates>
                            <xsl:apply-templates select="current-group()" mode="offset">
                                <xsl:with-param name="journal_id" select="$journal_id"/>
                            </xsl:apply-templates>
                        </bsvc:Accounting_Journal_Data>
                    </bsvc:Import_Accounting_Journal_Request>
                </xsl:for-each-group>
            </xsl:for-each-group>
        </xsl:for-each-group>
    </xsl:template>

    <xsl:template match="je:Report_Entry" mode="new_line">
        <xsl:param name="journal_id"/>
        <xsl:variable name="existing.journal.data">
            <xsl:copy-of select="$journal.data//journal_request[@journal_id=$journal_id]"/>
        </xsl:variable>
        <xsl:variable name="line_key">
            <xsl:value-of select="je:Account/je:ID[@je:type = 'Ledger_Account_ID']"/>
            <xsl:value-of select="$key-delim"/>
            <xsl:value-of select="je:Bank_Account/je:ID[@je:type = 'WID']"/>
            <xsl:value-of select="$key-delim"/>
            <xsl:value-of select="je:Cost_Center/je:ID[@je:type = 'Organization_Reference_ID']"/>
            <xsl:value-of select="$key-delim"/>
            <xsl:value-of select="je:Functional_Class/je:ID[@je:type = 'WID']"/>
            <xsl:value-of select="$key-delim"/>
            <xsl:value-of select="je:Intercompany_Affiliate/je:ID[@je:type = 'Organization_Reference_ID']"/>
            <xsl:value-of select="$key-delim"/>
            <xsl:value-of select="je:Project/je:ID[@je:type = 'Project_ID']"/>
            <xsl:value-of select="$key-delim"/>
            <xsl:value-of select="je:Region/je:ID[@je:type = 'Organization_Reference_ID']"/>
            <xsl:value-of select="$key-delim"/>
            <xsl:value-of select="je:Revenue_Category/je:ID[@je:type = 'Revenue_Category_ID']"/>
            <xsl:value-of select="$key-delim"/>
            <xsl:value-of select="je:Spend_Category/je:ID[@je:type = 'Spend_Category_ID']"/>
            <xsl:value-of select="$key-delim"/>
            <xsl:value-of select="je:Supplier/je:ID[@je:type = 'Supplier_ID']"/>
            <xsl:value-of select="$key-delim"/>
            <xsl:value-of select="je:Customer/je:ID[@je:type = 'Customer_ID']"/>
        </xsl:variable>
        <xsl:variable name="debit_amount_change" as="xs:decimal">
            <xsl:value-of select="format-number(fhc:forceValue($existing.journal.data//journal_line[@line_key=$line_key]/xs:decimal(debit_amount),0) - xs:decimal(je:Debit_Amount),'####.00')"/>
        </xsl:variable>
        <xsl:variable name="credit_amount_change" as="xs:decimal">
            <xsl:value-of select="format-number(fhc:forceValue($existing.journal.data//journal_line[@line_key=$line_key]/xs:decimal(credit_amount),0) - xs:decimal(je:Credit_Amount),'####.00')"/>
        </xsl:variable>
        <xsl:variable name="debit_balance" as="xs:decimal">
            <xsl:value-of select="xs:decimal($debit_amount_change) - xs:decimal($credit_amount_change)"/>
        </xsl:variable>
        <xsl:variable name="credit_balance" as="xs:decimal">
            <xsl:value-of select="xs:decimal($credit_amount_change) - xs:decimal($debit_amount_change)"/>
        </xsl:variable>
        <xsl:if test="($debit_balance != 0 or $credit_balance != 0)">
            <bsvc:Journal_Entry_Line_Replacement_Data>
                <bsvc:Line_Order>
                    <xsl:value-of select="position()"/>
                </bsvc:Line_Order>
                <bsvc:Line_Company_Reference>
                    <bsvc:ID bsvc:type="Organization_Reference_ID">
                        <xsl:value-of select="je:Company/je:ID[@je:type = 'Organization_Reference_ID']"/>
                    </bsvc:ID>
                </bsvc:Line_Company_Reference>
                <bsvc:Ledger_Account_Reference>
                    <bsvc:ID>
                        <xsl:attribute name="bsvc:type" select="'Ledger_Account_ID'"/>
                        <xsl:attribute name="bsvc:parent_id" select="'Standard'"/>
                        <xsl:attribute name="bsvc:parent_type" select="'Account_Set_ID'"/>
                        <xsl:value-of select="je:Account/je:ID[@je:type = 'Ledger_Account_ID']"/>
                    </bsvc:ID>
                </bsvc:Ledger_Account_Reference>
                <xsl:choose>
                    <xsl:when test="$debit_balance &gt; 0">
                        <bsvc:Ledger_Debit_Amount>
                            <xsl:value-of select="0"/>
                        </bsvc:Ledger_Debit_Amount>
                        <bsvc:Ledger_Credit_Amount>
                            <xsl:value-of select="$debit_balance"/>
                        </bsvc:Ledger_Credit_Amount>
                    </xsl:when>
                    <xsl:otherwise>
                        <bsvc:Ledger_Debit_Amount>
                            <xsl:value-of select="$credit_balance"/>
                        </bsvc:Ledger_Debit_Amount>
                        <bsvc:Ledger_Credit_Amount>
                            <xsl:value-of select="0"/>
                        </bsvc:Ledger_Credit_Amount>
                    </xsl:otherwise>
                </xsl:choose>
                <!-- <bsvc:Quantity>1000.00</bsvc:Quantity>
                <bsvc:Unit_of_Measure_Reference>
                    <bsvc:ID bsvc:type="string">string</bsvc:ID>
                </bsvc:Unit_of_Measure_Reference>
                <bsvc:Quantity_2>1000.00</bsvc:Quantity_2>
                <bsvc:Unit_of_Measure_2_Reference>
                    <bsvc:ID bsvc:type="string">string</bsvc:ID>
                </bsvc:Unit_of_Measure_2_Reference> -->
                <bsvc:Memo>
                    <xsl:value-of select="'Region Data Clean-up'"/>
                </bsvc:Memo>
                <bsvc:External_Reference_ID>

                </bsvc:External_Reference_ID>
                <!--<bsvc:Budget_Date>2016-01-01</bsvc:Budget_Date>-->
                <xsl:if test="string-length(je:Cost_Center) != 0">
                    <bsvc:Worktags_Reference>
                        <bsvc:ID bsvc:type="Organization_Reference_ID">
                            <xsl:value-of select="je:Cost_Center/je:ID[@je:type = 'Organization_Reference_ID']"/>
                        </bsvc:ID>
                    </bsvc:Worktags_Reference>
                </xsl:if>
                <xsl:if test="string-length(je:Intercompany_Affiliate) != 0">
                    <bsvc:Worktags_Reference>
                        <bsvc:ID bsvc:type="Organization_Reference_ID">
                            <xsl:value-of select="je:Intercompany_Affiliate/je:ID[@je:type = 'Organization_Reference_ID']"/>
                        </bsvc:ID>
                    </bsvc:Worktags_Reference>
                </xsl:if>
                <xsl:if test="string-length(je:Business_Unit) != 0">
                    <bsvc:Worktags_Reference>
                        <bsvc:ID bsvc:type="Organization_Reference_ID">
                            <xsl:value-of select="je:getRegionValue(je:Business_Unit/@je:Descriptor,je:Business_Unit/je:ID[@je:type = 'Organization_Reference_ID'])"/>
                        </bsvc:ID>
                    </bsvc:Worktags_Reference>
                </xsl:if>
                <xsl:if test="string-length(je:Region) != 0">
                    <bsvc:Worktags_Reference>
                        <bsvc:ID bsvc:type="Organization_Reference_ID">
                            <xsl:value-of select="je:Region/je:ID[@je:type = 'Organization_Reference_ID']"/>
                        </bsvc:ID>
                    </bsvc:Worktags_Reference>
                </xsl:if>
                <xsl:if test="string-length(je:Supplier) != 0">
                    <bsvc:Worktags_Reference>
                        <bsvc:ID bsvc:type="Supplier_ID">
                            <xsl:value-of select="je:Supplier/je:ID[@je:type = 'Supplier_ID']"/>
                        </bsvc:ID>
                    </bsvc:Worktags_Reference>
                </xsl:if>
                <xsl:if test="string-length(je:Project) != 0">
                    <bsvc:Worktags_Reference>
                        <bsvc:ID bsvc:type="Project_ID">
                            <xsl:value-of select="je:Project/je:ID[@je:type = 'Project_ID']"/>
                        </bsvc:ID>
                    </bsvc:Worktags_Reference>
                </xsl:if>
                <xsl:if test="string-length(je:Revenue_Category) != 0">
                    <bsvc:Worktags_Reference>
                        <bsvc:ID bsvc:type="Revenue_Category_ID">
                            <xsl:value-of select="je:Revenue_Category/je:ID[@je:type = 'Revenue_Category_ID']"/>
                        </bsvc:ID>
                    </bsvc:Worktags_Reference>
                </xsl:if>
                <xsl:if test="string-length(je:Spend_Category) != 0">
                    <bsvc:Worktags_Reference>
                        <bsvc:ID bsvc:type="Spend_Category_ID">
                            <xsl:value-of select="je:Spend_Category/je:ID[@je:type = 'Spend_Category_ID']"/>
                        </bsvc:ID>
                    </bsvc:Worktags_Reference>
                </xsl:if>
                <xsl:if test="string-length(je:Functional_Class) != 0 and substring(je:Period,7,4) = '2018'">
                    <bsvc:Worktags_Reference>
                        <bsvc:ID bsvc:type="WID">
                            <xsl:value-of select="je:Functional_Class/je:ID[@je:type = 'WID']"/>
                        </bsvc:ID>
                    </bsvc:Worktags_Reference>
                </xsl:if>
                <xsl:if test="string-length(je:Bank_Account) != 0 and substring(je:Account/je:ID[@je:type = 'Ledger_Account_ID'],1,1) = '1'">
                    <bsvc:Worktags_Reference>
                        <bsvc:ID bsvc:type="WID">
                            <xsl:value-of select="je:Bank_Account/je:ID[@je:type = 'WID']"/>
                        </bsvc:ID>
                    </bsvc:Worktags_Reference>
                </xsl:if>
                <!--<bsvc:Balancing_Worktag_Affiliate_Reference>
                    <bsvc:ID bsvc:type="string">string</bsvc:ID>
                </bsvc:Balancing_Worktag_Affiliate_Reference>-->
            </bsvc:Journal_Entry_Line_Replacement_Data>
        </xsl:if>
    </xsl:template>

    <xsl:template match="je:Report_Entry" mode="offset">
        <xsl:param name="journal_id"/>
        <xsl:variable name="existing.journal.data">
            <xsl:copy-of select="$journal.data//journal_request[@journal_id=$journal_id]"/>
        </xsl:variable>
        <xsl:variable name="line_key">
            <xsl:value-of select="je:Account/je:ID[@je:type = 'Ledger_Account_ID']"/>
            <xsl:value-of select="$key-delim"/>
            <xsl:value-of select="je:Bank_Account/je:ID[@je:type = 'WID']"/>
            <xsl:value-of select="$key-delim"/>
            <xsl:value-of select="je:Cost_Center/je:ID[@je:type = 'Organization_Reference_ID']"/>
            <xsl:value-of select="$key-delim"/>
            <xsl:value-of select="je:Functional_Class/je:ID[@je:type = 'WID']"/>
            <xsl:value-of select="$key-delim"/>
            <xsl:value-of select="je:Intercompany_Affiliate/je:ID[@je:type = 'Organization_Reference_ID']"/>
            <xsl:value-of select="$key-delim"/>
            <xsl:value-of select="je:Project/je:ID[@je:type = 'Project_ID']"/>
            <xsl:value-of select="$key-delim"/>
            <xsl:value-of select="je:Region/je:ID[@je:type = 'Organization_Reference_ID']"/>
            <xsl:value-of select="$key-delim"/>
            <xsl:value-of select="je:Revenue_Category/je:ID[@je:type = 'Revenue_Category_ID']"/>
            <xsl:value-of select="$key-delim"/>
            <xsl:value-of select="je:Spend_Category/je:ID[@je:type = 'Spend_Category_ID']"/>
            <xsl:value-of select="$key-delim"/>
            <xsl:value-of select="je:Supplier/je:ID[@je:type = 'Supplier_ID']"/>
            <xsl:value-of select="$key-delim"/>
            <xsl:value-of select="je:Customer/je:ID[@je:type = 'Customer_ID']"/>
        </xsl:variable>
        <xsl:variable name="debit_amount_change" as="xs:decimal">
            <xsl:value-of select="format-number(fhc:forceValue($existing.journal.data//journal_line[@line_key=$line_key]/xs:decimal(debit_amount),0) - xs:decimal(je:Debit_Amount),'####.00')"/>
        </xsl:variable>
        <xsl:variable name="credit_amount_change" as="xs:decimal">
            <xsl:value-of select="format-number(fhc:forceValue($existing.journal.data//journal_line[@line_key=$line_key]/xs:decimal(credit_amount),0) - xs:decimal(je:Credit_Amount),'####.00')"/>
        </xsl:variable>
        <xsl:variable name="debit_balance" as="xs:decimal">
            <xsl:value-of select="xs:decimal($debit_amount_change) - xs:decimal($credit_amount_change)"/>
        </xsl:variable>
        <xsl:variable name="credit_balance" as="xs:decimal">
            <xsl:value-of select="xs:decimal($credit_amount_change) - xs:decimal($debit_amount_change)"/>
        </xsl:variable>
        <xsl:if test="($debit_balance != 0 or $credit_balance != 0)">
            <bsvc:Journal_Entry_Line_Replacement_Data>
                <bsvc:Line_Order>
                    <xsl:value-of select="position()"/>
                </bsvc:Line_Order>
                <bsvc:Line_Company_Reference>
                    <bsvc:ID bsvc:type="Organization_Reference_ID">
                        <xsl:value-of select="je:Company/je:ID[@je:type = 'Organization_Reference_ID']"/>
                    </bsvc:ID>
                </bsvc:Line_Company_Reference>
                <bsvc:Ledger_Account_Reference>
                    <bsvc:ID>
                        <xsl:attribute name="bsvc:type" select="'Ledger_Account_ID'"/>
                        <xsl:attribute name="bsvc:parent_id" select="'Standard'"/>
                        <xsl:attribute name="bsvc:parent_type" select="'Account_Set_ID'"/>
                        <xsl:value-of select="je:Account/je:ID[@je:type = 'Ledger_Account_ID']"/>
                    </bsvc:ID>
                </bsvc:Ledger_Account_Reference>
                <xsl:choose>
                    <xsl:when test="$debit_balance &gt; 0">
                        <bsvc:Ledger_Debit_Amount>
                            <xsl:value-of select="$debit_balance"/>
                        </bsvc:Ledger_Debit_Amount>
                        <bsvc:Ledger_Credit_Amount>
                            <xsl:value-of select="0"/>
                        </bsvc:Ledger_Credit_Amount>
                    </xsl:when>
                    <xsl:otherwise>
                        <bsvc:Ledger_Debit_Amount>
                            <xsl:value-of select="0"/>
                        </bsvc:Ledger_Debit_Amount>
                        <bsvc:Ledger_Credit_Amount>
                            <xsl:value-of select="$credit_balance"/>
                        </bsvc:Ledger_Credit_Amount>
                    </xsl:otherwise>
                </xsl:choose>
                <!-- <bsvc:Quantity>1000.00</bsvc:Quantity>
                <bsvc:Unit_of_Measure_Reference>
                    <bsvc:ID bsvc:type="string">string</bsvc:ID>
                </bsvc:Unit_of_Measure_Reference>
                <bsvc:Quantity_2>1000.00</bsvc:Quantity_2>
                <bsvc:Unit_of_Measure_2_Reference>
                    <bsvc:ID bsvc:type="string">string</bsvc:ID>
                </bsvc:Unit_of_Measure_2_Reference> -->
                <bsvc:Memo>
                    <xsl:value-of select="'Region Data Clean-up Offset'"/>
                </bsvc:Memo>
                <bsvc:External_Reference_ID>

                </bsvc:External_Reference_ID>
                <!--<bsvc:Budget_Date>2016-01-01</bsvc:Budget_Date>-->
                <xsl:if test="string-length(je:Cost_Center) != 0">
                    <bsvc:Worktags_Reference>
                        <bsvc:ID bsvc:type="Organization_Reference_ID">
                            <xsl:value-of select="je:Cost_Center/je:ID[@je:type = 'Organization_Reference_ID']"/>
                        </bsvc:ID>
                    </bsvc:Worktags_Reference>
                </xsl:if>
                <xsl:if test="string-length(je:Intercompany_Affiliate) != 0">
                    <bsvc:Worktags_Reference>
                        <bsvc:ID bsvc:type="Organization_Reference_ID">
                            <xsl:value-of select="je:Intercompany_Affiliate/je:ID[@je:type = 'Organization_Reference_ID']"/>
                        </bsvc:ID>
                    </bsvc:Worktags_Reference>
                </xsl:if>
                <xsl:if test="string-length(je:Business_Unit) != 0">
                    <bsvc:Worktags_Reference>
                        <bsvc:ID bsvc:type="Organization_Reference_ID">
                            <xsl:value-of select="je:getRegionValue(je:Business_Unit/@je:Descriptor,je:Business_Unit/je:ID[@je:type = 'Organization_Reference_ID'])"/>
                        </bsvc:ID>
                    </bsvc:Worktags_Reference>
                </xsl:if>
                <!-- <xsl:if test="string-length(je:Region) != 0">
                    <bsvc:Worktags_Reference>
                        <bsvc:ID bsvc:type="Organization_Reference_ID">
                            <xsl:value-of select="je:Region/je:ID[@je:type = 'Organization_Reference_ID']"/>
                        </bsvc:ID>
                    </bsvc:Worktags_Reference>
                </xsl:if> -->
                <xsl:if test="string-length(je:Supplier) != 0">
                    <bsvc:Worktags_Reference>
                        <bsvc:ID bsvc:type="Supplier_ID">
                            <xsl:value-of select="je:Supplier/je:ID[@je:type = 'Supplier_ID']"/>
                        </bsvc:ID>
                    </bsvc:Worktags_Reference>
                </xsl:if>
                <xsl:if test="string-length(je:Project) != 0">
                    <bsvc:Worktags_Reference>
                        <bsvc:ID bsvc:type="Project_ID">
                            <xsl:value-of select="je:Project/je:ID[@je:type = 'Project_ID']"/>
                        </bsvc:ID>
                    </bsvc:Worktags_Reference>
                </xsl:if>
                <xsl:if test="string-length(je:Revenue_Category) != 0">
                    <bsvc:Worktags_Reference>
                        <bsvc:ID bsvc:type="Revenue_Category_ID">
                            <xsl:value-of select="je:Revenue_Category/je:ID[@je:type = 'Revenue_Category_ID']"/>
                        </bsvc:ID>
                    </bsvc:Worktags_Reference>
                </xsl:if>
                <xsl:if test="string-length(je:Spend_Category) != 0">
                    <bsvc:Worktags_Reference>
                        <bsvc:ID bsvc:type="Spend_Category_ID">
                            <xsl:value-of select="je:Spend_Category/je:ID[@je:type = 'Spend_Category_ID']"/>
                        </bsvc:ID>
                    </bsvc:Worktags_Reference>
                </xsl:if>
                <xsl:if test="string-length(je:Functional_Class) != 0 and substring(je:Period,7,4) = '2018'">
                    <bsvc:Worktags_Reference>
                        <bsvc:ID bsvc:type="WID">
                            <xsl:value-of select="je:Functional_Class/je:ID[@je:type = 'WID']"/>
                        </bsvc:ID>
                    </bsvc:Worktags_Reference>
                </xsl:if>
                <xsl:if test="string-length(je:Bank_Account) != 0 and substring(je:Account/je:ID[@je:type = 'Ledger_Account_ID'],1,1) = '1'">
                    <bsvc:Worktags_Reference>
                        <bsvc:ID bsvc:type="WID">
                            <xsl:value-of select="je:Bank_Account/je:ID[@je:type = 'WID']"/>
                        </bsvc:ID>
                    </bsvc:Worktags_Reference>
                </xsl:if>
                <!--<bsvc:Balancing_Worktag_Affiliate_Reference>
                    <bsvc:ID bsvc:type="string">string</bsvc:ID>
                </bsvc:Balancing_Worktag_Affiliate_Reference>-->
            </bsvc:Journal_Entry_Line_Replacement_Data>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
