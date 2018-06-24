<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tns="http://yourcompany.com/textschema/Accounting_Technology_Common/supplierdatatoupdate.xsd"
    xmlns:wd="urn:com.workday/bsvc" xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"
    xmlns:atc="http://yourcompany.com/textschema/Accounting_Technology_Common"
    xmlns:intsys="java:com.workday.esb.intsys.xpath.ParsedIntegrationSystemFunctions"
    exclude-result-prefixes="xs env tns xsl intsys atc" version="2.0">
    
    <!-- xmlns:tns="http://yourcompany.com/textschema/Accounting_Technology_Common/supplierdatatoupdate.xsd" -->

    <xsl:output method="xml" version="1.0" indent="yes"/>

    <xsl:param name="webservice.version" select="'v26.0'"/>
    <xsl:param name="add.only"/>
    <xsl:param name="auto.complete"/>
    <xsl:param name="lock.transaction"/>
    <!-- <xsl:param name="suppliercontract.specialist.id"/> -->
    <xsl:param name="suppliercontract.specialist.id" select="'Kristina Budde'"/>
    <xsl:param name="Company_for_Invoices_Reference" select="'LTFRECO'"/>
    <xsl:param name="Spend_Category_Reference" select="'SC00010'"/>
    <xsl:param name="Company_Hierarchy_Reference" select="'LTFRECUR'"/>
    <xsl:param name="Contract_Type_Reference" select="'AP_Manual_Invoice_Contract'"/>
    <xsl:param name="Currency_Reference" select="'USD'"/>
    <xsl:param name="webservice.recordcount"/>
    <xsl:param name="businessprocess.defaultcomment"/>
    <xsl:param name="supplier.inactivestatusid" select="'INACTIVE'"/>
    <xsl:param name="supplier.statuschangereasonid" select="'NO_ACTIVITY'"/>
    
    <!-- <xsl:variable name="suppliercontract.data" select="document('mctx:vars/externalfile.data')"/> -->
    <xsl:variable name="suppliercontract.data" select="document('mctx:vars/prolog.lookup.data')"/>

    <xsl:template match="/">
        <!-- <xsl:for-each-group select="//Table" group-by="Contracts.GUID"> -->
        <xsl:for-each-group select="$suppliercontract.data//Table" group-by="$suppliercontract.data//Table[1]/Contracts.ContractID">
            <env:Envelope xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"
                xmlns:wd="urn:com.workday/bsvc">
                <env:Header/>
                <env:Body>
                    <wd:Submit_Supplier_Contract_Request>
                        <xsl:attribute name="wd:version" select="$webservice.version"/>
                        <xsl:attribute name="wd:Add_Only">
                            <!-- <xsl:choose>
                                <xsl:when test="string-length($add.only) = 0">
                                    <xsl:value-of select="'1'"/>
                                </xsl:when>
                                <xsl:otherwise> -->
                                    <xsl:value-of select="$add.only"/>
                                <!-- </xsl:otherwise>
                            </xsl:choose> -->
                        </xsl:attribute>
                        <wd:Supplier_Contract_Reference>
                            <wd:ID>
                                <xsl:attribute name="wd:type" select="'Supplier_Contract_ID'"/>
                                <!-- <xsl:value-of select="current-grouping-key()"/> -->
                                <!-- <xsl:value-of select="'SUPPLIER_CONTRACT-3-8103'"/> -->
                            </wd:ID>
                        </wd:Supplier_Contract_Reference>
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
                        <wd:Supplier_Contract_Data>
                            <xsl:apply-templates select="current-group()[1]" mode="header"/>
                            <xsl:apply-templates select="current-group()" mode="#default"/>
                        </wd:Supplier_Contract_Data>
                    </wd:Submit_Supplier_Contract_Request>
                </env:Body>
            </env:Envelope>
        </xsl:for-each-group>
    </xsl:template>

    <xsl:template match="Table" mode="#default">
        <wd:Service_Lines_Replacement_Data>
            <wd:Line_Number>
                <xsl:value-of select="position()"/>
            </wd:Line_Number>
            <wd:Company_for_Invoices_Reference>
                <!-- <wd:ID wd:type="Organization_Reference_ID">LTFRECO</wd:ID> -->
                <wd:ID wd:type="Organization_Reference_ID">
        			<xsl:value-of select="$Company_for_Invoices_Reference"/>
    			</wd:ID>
            </wd:Company_for_Invoices_Reference>
            <wd:Line_On_Hold>false</wd:Line_On_Hold>
            <wd:Description>
                <xsl:value-of select="ContractSchedOfValues.Description"/>
            </wd:Description>
            <wd:Spend_Category_Reference>
                <!-- <wd:ID wd:type="Spend_Category_ID">SC00010</wd:ID> -->
                <wd:ID wd:type="Spend_Category_ID">
        			<xsl:value-of select="$Spend_Category_Reference"/>
    			</wd:ID>
            </wd:Spend_Category_Reference>
            <!--<wd:Tax_Applicability_Reference wd:Descriptor="string">
                <!-\- Zero or more repetitions: -\->
                <wd:ID wd:type="string">string</wd:ID>
            </wd:Tax_Applicability_Reference>
            <!-\- Optional: -\->
            <wd:Tax_Code_Reference wd:Descriptor="string">
                <!-\- Zero or more repetitions: -\->
                <wd:ID wd:type="string">string</wd:ID>
            </wd:Tax_Code_Reference>-->
            <wd:Extended_Amount>
                <xsl:value-of select="ContractSchedOfValues.ScheduledValue"/>
            </wd:Extended_Amount>
            <xsl:if test="string-length(ContractSchedOfValues.ForecastStartDate) != 0">
                <wd:Start_Date>
                    <xsl:value-of select="ContractSchedOfValues.ForecastStartDate"/>
                </wd:Start_Date>
            </xsl:if>
            <xsl:if test="string-length(ContractSchedOfValues.ForecastEndDate) != 0">
                <wd:End_Date>
                    <xsl:value-of select="ContractSchedOfValues.ForecastEndDate"/>
                </wd:End_Date>
            </xsl:if>
            <wd:Memo>
                <xsl:value-of select="ContractSchedOfValues.Description"/>
            </wd:Memo>
            <wd:Worktag_Reference>
                <wd:ID wd:type="Project_Plan_ID">
                    <xsl:value-of
                        select="concat(Projects.Number, '-', ContractSchedOfValues.BdgtCode)"/>
                </wd:ID>
            </wd:Worktag_Reference>
        </wd:Service_Lines_Replacement_Data>
    </xsl:template>

    <xsl:template match="Table" mode="header">
        <wd:Supplier_Contract_ID>
            <!-- <xsl:value-of select="Contracts.GUID"/> -->
            <!-- <xsl:value-of select="Contracts.ContractID"/> -->
            <!-- <xsl:value-of select="'SUPPLIER_CONTRACT-3-8103'"/> -->
        </wd:Supplier_Contract_ID>
        <wd:Company_Hierarchy_Reference>
            <!-- <wd:ID wd:type="Organization_Reference_ID">LTFRECUR</wd:ID> -->
            <wd:ID wd:type="Organization_Reference_ID">
        		<xsl:value-of select="$Company_Hierarchy_Reference"/>
    		</wd:ID>
        </wd:Company_Hierarchy_Reference>
        <wd:Supplier_Reference>
            <wd:ID wd:type="Supplier_ID">
                <xsl:value-of select="ToCompany.CompanyID"/>
            </wd:ID>
        </wd:Supplier_Reference>
        <wd:Contract_Specialist_Reference>
            <wd:ID wd:type="Employee_ID">
                <xsl:value-of select="$suppliercontract.specialist.id"/>
            </wd:ID>
        </wd:Contract_Specialist_Reference>
        <!--<wd:Buyer_Reference wd:Descriptor="string">
                <!-\- Zero or more repetitions: -\->
                <wd:ID wd:type="string">string</wd:ID>
            </wd:Buyer_Reference>-->
        <wd:Contract_Type_Reference>
            <!-- <wd:ID wd:type="Supplier_Contract_Type_ID">AP_Manual_Invoice_Contract</wd:ID> -->
            <wd:ID wd:type="Supplier_Contract_Type_ID">
        		<xsl:value-of select="$Contract_Type_Reference"/>
    		</wd:ID>
        </wd:Contract_Type_Reference>
        <wd:Contract_Name>
            <!-- <xsl:value-of select="Contracts.Description"/> -->
            <xsl:value-of select="concat(ToCompany.Name, Projects.Name, Contracts.Type)"/>
        </wd:Contract_Name>
        <!--<wd:Supplier_Reference_Number></wd:Supplier_Reference_Number>-->
        <wd:Contract_Start_Date>
            <xsl:value-of select="Contracts.ContractDate"/>
        </wd:Contract_Start_Date>
        <wd:Contract_Signed_Date>
            <xsl:value-of select="Contracts.ContractDate"/>
        </wd:Contract_Signed_Date>
        <wd:Contract_End_Date>
            <xsl:value-of select="Contracts.ForecastFinishDate"/>
            <!-- <xsl:value-of select="xs:date(Contracts.ContractDate) + xs:yearMonthDuration('P2Y')"/> -->
        </wd:Contract_End_Date>
        <wd:Total_Contract_Amount>
            <xsl:value-of select="Contracts.RevisedValue"/>
        </wd:Total_Contract_Amount>
        <wd:Original_Contract_Amount>
            <xsl:value-of select="Contracts.OrigValue"/>
        </wd:Original_Contract_Amount>
        <wd:Currency_Reference>
            <!-- <wd:ID wd:type="Currency_ID">USD</wd:ID> -->
            <wd:ID wd:type="Currency_ID">
        		<xsl:value-of select="$Currency_Reference"/>
    		</wd:ID>
        </wd:Currency_Reference>
        <!--<wd:Default_Tax_Code_Reference wd:Descriptor="string">
                <wd:ID wd:type="string">string</wd:ID>
            </wd:Default_Tax_Code_Reference>
            <wd:Override_Payment_Type_Reference wd:Descriptor="string">
                <wd:ID wd:type="string">string</wd:ID>
            </wd:Override_Payment_Type_Reference>-->
        <!--<wd:Credit_Card_Reference wd:Descriptor="string">
                <!-\- Zero or more repetitions: -\->
                <wd:ID wd:type="string">string</wd:ID>
            </wd:Credit_Card_Reference>-->
        <!-- Optional: -->
        <!--<wd:Renewal_Terms_Data>
                <!-\- Optional: -\->
                <wd:Automatically_Renew>true</wd:Automatically_Renew>
                <!-\- Optional: -\->
                <wd:Send_Expiration_Notification>false</wd:Send_Expiration_Notification>
                <!-\- Optional: -\->
                <wd:Notice_Period>1000.00</wd:Notice_Period>
                <!-\- Optional: -\->
                <wd:Notice_Period_Frequency_Reference wd:Descriptor="string">
                    <!-\- Zero or more repetitions: -\->
                    <wd:ID wd:type="string">string</wd:ID>
                </wd:Notice_Period_Frequency_Reference>
                <!-\- Optional: -\->
                <wd:Renewal_Term>1000.00</wd:Renewal_Term>
                <!-\- Optional: -\->
                <wd:Renewal_Term_Frequency_Reference wd:Descriptor="string">
                    <!-\- Zero or more repetitions: -\->
                    <wd:ID wd:type="string">string</wd:ID>
                </wd:Renewal_Term_Frequency_Reference>
            </wd:Renewal_Terms_Data>-->
        <wd:Contract_Overview> </wd:Contract_Overview>

        <wd:Locked_in_Workday>
            <xsl:value-of select="$lock.transaction"/>
        </wd:Locked_in_Workday>
        <wd:Submit>true</wd:Submit>
    </xsl:template>

</xsl:stylesheet>
