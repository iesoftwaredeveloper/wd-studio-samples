<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:bsvc="urn:com.workday/bsvc"
    xmlns:ecmc="https://ecmc.org/budget_format"
    xmlns:fhc="https://firehawk-consulting.com/data_lookups"
    xmlns:wd="urn:com.workday/bsvc"
    exclude-result-prefixes="xs" version="2.0">
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>

    <xsl:param name="web.service.add.only"/>
    <xsl:param name="web.service.auto.complete"/>
    <xsl:param name="web.service.version"/>
    <xsl:param name="web.service.submit"/>
    <xsl:param name="plan.import.mode"/>
    <xsl:param name="plan.structure.wid"/>

    <xsl:template match="/">
        <xsl:apply-templates select="//ecmc:budget_load" mode="budget"/>
    </xsl:template>

    <xsl:template match="ecmc:budget_load" mode="budget">
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
            xmlns:bsvc="urn:com.workday/bsvc">
            <soapenv:Header/>
            <soapenv:Body>
                <bsvc:Import_Budget_High_Volume_Request>
                    <xsl:attribute name="bsvc:version">
                        <xsl:value-of select="$web.service.version"/>
                    </xsl:attribute>
                    <bsvc:Import_Mode_Reference>
                        <bsvc:ID bsvc:type="Budget_Import_Mode_ID">
                            <xsl:value-of select="$plan.import.mode"/>
                        </bsvc:ID>
                    </bsvc:Import_Mode_Reference>
                    <bsvc:Business_Process_Parameters>
                        <bsvc:Auto_Complete>
                            <xsl:value-of select="$web.service.auto.complete"/>
                        </bsvc:Auto_Complete>
                    </bsvc:Business_Process_Parameters>
                    <bsvc:Budget_Data>
                        <bsvc:Submit>
                            <xsl:value-of select="$web.service.submit"/>
                        </bsvc:Submit>
                        <bsvc:Budget_Structure_Reference>
                            <bsvc:ID bsvc:type="WID">
                                <xsl:value-of select="$plan.structure.wid"/>
                            </bsvc:ID>
                        </bsvc:Budget_Structure_Reference>
                        <bsvc:Budget_Name_Reference>
                            <bsvc:ID bsvc:type="Custom_Budget_ID">
                                <xsl:value-of select="@ecmc:budget_name"/>
                            </bsvc:ID>
                        </bsvc:Budget_Name_Reference>
                        <bsvc:Budget_Memo></bsvc:Budget_Memo>
                        <xsl:for-each-group select=".//ecmc:budget_record" group-by="@ecmc:record-group">
                            <xsl:apply-templates select="current-group()[1]">
                                <xsl:with-param name="line.order" select="position()"/>
                                <xsl:with-param name="credit.amount" select="sum(current-group()//ecmc:credit_amount)"/>
                                <xsl:with-param name="debit.amount" select="sum(current-group()//ecmc:debit_amount)"/>
                            </xsl:apply-templates>
                        </xsl:for-each-group>
                    </bsvc:Budget_Data>
                </bsvc:Import_Budget_High_Volume_Request>
            </soapenv:Body>
        </soapenv:Envelope>
    </xsl:template>

    <xsl:template match="ecmc:budget_record">
        <xsl:param name="line.order"/>
        <xsl:param name="credit.amount"/>
        <xsl:param name="debit.amount"/>
        <xsl:variable name="debit_balance">
            <xsl:value-of select="xs:decimal(format-number($debit.amount,'####.00')) - xs:decimal(format-number($credit.amount,'####.00'))"/>
        </xsl:variable>
        <xsl:variable name="credit_balance">
            <xsl:value-of select="xs:decimal(format-number($credit.amount,'####.00')) - xs:decimal(format-number($debit.amount,'####.00'))"/>
        </xsl:variable>
        <bsvc:Budget_Lines_Data>
            <bsvc:Line_Order>
                <xsl:value-of select="$line.order"/>
            </bsvc:Line_Order>
            <bsvc:Company_Reference>
                <bsvc:ID>
                    <xsl:attribute name="bsvc:type" select="'Company_Reference_ID'"/>
                    <xsl:value-of select="normalize-space(ecmc:company)"/>
                </bsvc:ID>
            </bsvc:Company_Reference>
            <bsvc:Year>
                <xsl:value-of select="ecmc:year"/>
            </bsvc:Year>
            <bsvc:Fiscal_Time_Interval_Reference>
                <bsvc:ID bsvc:type="Fiscal_Posting_Interval_ID">
                    <xsl:value-of select="ecmc:posting_interval"/>
                </bsvc:ID>
            </bsvc:Fiscal_Time_Interval_Reference>
            <bsvc:Ledger_Account_or_Ledger_Account_Summary_Reference>
                <bsvc:ID>
                    <xsl:attribute name="bsvc:type" select="'Ledger_Account_ID'"/>
                    <xsl:attribute name="bsvc:parent_id" select="'Standard'"/>
                    <xsl:attribute name="bsvc:parent_type" select="'Account_Set_ID'"/>
                    <xsl:value-of select="normalize-space(ecmc:account)"/>
                </bsvc:ID>
            </bsvc:Ledger_Account_or_Ledger_Account_Summary_Reference>
            <bsvc:Budget_Currency_Reference>
                <bsvc:ID bsvc:type="Currency_ID">
                    <xsl:value-of select="'USD'"/>
                </bsvc:ID>
            </bsvc:Budget_Currency_Reference>
            <xsl:choose>
                <xsl:when test="xs:decimal($credit.amount) != 0 
                    and xs:decimal($debit.amount) != 0
                    and $debit_balance &gt; 0">
                    <bsvc:Budget_Debit_Amount>
                        <xsl:value-of select="format-number(xs:decimal($debit_balance),'####.00')"/>
                    </bsvc:Budget_Debit_Amount>
                    <bsvc:Budget_Credit_Amount>
                        <xsl:value-of select="0"/>
                    </bsvc:Budget_Credit_Amount>
                </xsl:when>
                <xsl:when test="xs:decimal($credit.amount) != 0 
                    and xs:decimal($debit.amount) != 0
                    and $credit_balance &gt; 0">
                    <bsvc:Budget_Debit_Amount>
                        <xsl:value-of select="0"/>
                    </bsvc:Budget_Debit_Amount>
                    <bsvc:Budget_Credit_Amount>
                        <xsl:value-of select="format-number(xs:decimal($credit_balance),'####.00')"/>
                    </bsvc:Budget_Credit_Amount>
                </xsl:when>
                <xsl:when test="$debit_balance = 0">
                    <bsvc:Budget_Debit_Amount>
                        <xsl:value-of select="0"/>
                    </bsvc:Budget_Debit_Amount>
                    <bsvc:Budget_Credit_Amount>
                        <xsl:value-of select="0"/>
                    </bsvc:Budget_Credit_Amount>
                </xsl:when>
                <xsl:otherwise>
                    <bsvc:Budget_Debit_Amount>
                        <xsl:value-of select="format-number(xs:decimal($debit.amount),'####.00')"/>
                    </bsvc:Budget_Debit_Amount>
                    <bsvc:Budget_Credit_Amount>
                        <xsl:value-of select="format-number(xs:decimal($credit.amount),'####.00')"/>
                    </bsvc:Budget_Credit_Amount>
                </xsl:otherwise>
            </xsl:choose>
            <!--<bsvc:Memo></bsvc:Memo>-->
            <xsl:if test="string-length(ecmc:cost_center) != 0">
                <bsvc:Accounting_Worktag_Reference>
                    <bsvc:ID>
                        <xsl:attribute name="bsvc:type" select="'Organization_Reference_ID'"/>
                        <xsl:value-of select="normalize-space(ecmc:cost_center)"/>
                    </bsvc:ID>
                </bsvc:Accounting_Worktag_Reference>
            </xsl:if>
            <xsl:if test="string-length(ecmc:region) != 0">
                <bsvc:Accounting_Worktag_Reference>
                    <bsvc:ID>
                        <xsl:attribute name="bsvc:type" select="'Organization_Reference_ID'"/>
                        <xsl:value-of select="normalize-space(ecmc:region)"/>
                    </bsvc:ID>
                </bsvc:Accounting_Worktag_Reference>
            </xsl:if>
            <xsl:if test="string-length(ecmc:project_hierarchy) != 0 and ecmc:project_hierarchy != 'NO_ORG'">
                <bsvc:Accounting_Worktag_Reference>
                    <bsvc:ID>
                        <xsl:attribute name="bsvc:type" select="'Project_Hierarchy_ID'"/>
                        <xsl:value-of select="normalize-space(ecmc:project_hierarchy)"/>
                    </bsvc:ID>
                </bsvc:Accounting_Worktag_Reference>
            </xsl:if>
            <xsl:if test="string-length(ecmc:revenue_category) != 0">
                <bsvc:Accounting_Worktag_Reference>
                    <bsvc:ID>
                        <xsl:attribute name="bsvc:type" select="'Revenue_Category_ID'"/>
                        <xsl:value-of select="normalize-space(ecmc:revenue_category)"/>
                    </bsvc:ID>
                </bsvc:Accounting_Worktag_Reference>
            </xsl:if>
            <xsl:if test="string-length(ecmc:spend_category) != 0">
                <bsvc:Accounting_Worktag_Reference>
                    <bsvc:ID>
                        <xsl:attribute name="bsvc:type" select="'Spend_Category_ID'"/>
                        <xsl:value-of select="normalize-space(ecmc:spend_category)"/>
                    </bsvc:ID>
                </bsvc:Accounting_Worktag_Reference>
            </xsl:if>
        </bsvc:Budget_Lines_Data>
    </xsl:template>

    <xsl:template name="line_amount">
        <xsl:param name="clean_amount"/>
        <xsl:param name="account_type"/>
        <xsl:choose>
            <xsl:when test="($account_type = 'asset' or $account_type = 'expense')
                and xs:decimal($clean_amount) &gt; 0">
                <bsvc:Budget_Debit_Amount>
                    <xsl:value-of select="format-number(abs(xs:decimal($clean_amount)),'####.00')"/>
                </bsvc:Budget_Debit_Amount>
                <bsvc:Budget_Credit_Amount>
                    <xsl:value-of select="0"/>
                </bsvc:Budget_Credit_Amount>
            </xsl:when>
            <xsl:when test="($account_type = 'asset' or $account_type = 'expense') 
                and xs:decimal($clean_amount) &lt;= 0">
                <bsvc:Budget_Credit_Amount>
                    <xsl:value-of select="format-number(abs(xs:decimal($clean_amount)),'####.00')"/>
                </bsvc:Budget_Credit_Amount>
                <bsvc:Budget_Debit_Amount>
                    <xsl:value-of select="0"/>
                </bsvc:Budget_Debit_Amount>
            </xsl:when>
            <xsl:when test="xs:decimal($clean_amount) &lt;= 0">
                <bsvc:Budget_Debit_Amount>
                    <xsl:value-of select="format-number(abs(xs:decimal($clean_amount)),'####.00')"/>
                </bsvc:Budget_Debit_Amount>
                <bsvc:Budget_Credit_Amount>
                    <xsl:value-of select="0"/>
                </bsvc:Budget_Credit_Amount>
            </xsl:when>
            <xsl:when test="xs:decimal($clean_amount) &gt; 0">
                <bsvc:Budget_Credit_Amount>
                    <xsl:value-of select="format-number(abs(xs:decimal($clean_amount)),'####.00')"/>
                </bsvc:Budget_Credit_Amount>
                <bsvc:Budget_Debit_Amount>
                    <xsl:value-of select="0"/>
                </bsvc:Budget_Debit_Amount>
            </xsl:when>
            <xsl:otherwise>
                <bsvc:Budget_Credit_Amount>
                    <xsl:value-of select="0"/>
                </bsvc:Budget_Credit_Amount>
                <bsvc:Budget_Debit_Amount>
                    <xsl:value-of select="0"/>
                </bsvc:Budget_Debit_Amount>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
