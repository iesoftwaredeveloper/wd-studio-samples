<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:atc="http://ltfinc.net/Accounting_Technology_Common"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tl="https://github.com/firehawk-consulting/firehawk/schemas/transaction_log.xsd"
    exclude-result-prefixes="xsl atc xs tl">
    <!--xsl:output method="text"/-->
    <xsl:variable name="linefeed"><xsl:text>&#xA;</xsl:text></xsl:variable>
    <xsl:variable name="carriagereturn"><xsl:text>&#13;</xsl:text></xsl:variable>
    <xsl:variable name="space" select="' '"/>
    <xsl:variable name="delimiter"><xsl:text>&#x09;</xsl:text></xsl:variable>
    <xsl:param name="summarylog.filename"/>
    <xsl:param name="summarylog.file.extension"/>

    <xsl:function name="atc:forceValue" as="xs:decimal">
        <xsl:param name="inputdata"/>
        <xsl:choose>
            <xsl:when test="string-length(xs:string($inputdata))">
                <xsl:value-of select="$inputdata"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="0"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <xsl:template match="/">
        <tl:summary_log>
            <xsl:for-each-group select="//tl:transaction_record" group-by="@tl:transaction_grouping">
                <xsl:variable name="currentsummarysplit">
                    <xsl:value-of select="current-grouping-key()"/>
                </xsl:variable>
                <summaryloginfo>
                    <filename>
                        <xsl:value-of select="'summarylevel_'"/>
                        <xsl:value-of select="$summarylog.filename"/>
                        <xsl:value-of select="$currentsummarysplit"/>
                        <xsl:value-of select="'.'"/>
                        <xsl:value-of select="$summarylog.file.extension"/>
                    </filename>
                    <summarylogdetails>
                        <xsl:call-template name="summary-record">
                            <xsl:with-param name="files-processed" select="//filenumber[count(//transactionrecord)-1]"/>
                            <xsl:with-param name="records-imported" select="count(//transactionrecord[transaction_status='imported' and summarysplit=$currentsummarysplit])"/>
                            <xsl:with-param name="records-skipped" select="count(//transactionrecord[transaction_status='skipped' and summarysplit=$currentsummarysplit])"/>
                            <xsl:with-param name="records-failed" select="count(//transactionrecord[transaction_status='failed' and summarysplit=$currentsummarysplit])"/>
                            <xsl:with-param name="records-processed" select="count(//transactionrecord[summarysplit=$currentsummarysplit])"/>
                            <xsl:with-param name="amount-processed" select="sum(//transactionrecord[summarysplit=$currentsummarysplit]/atc:forceValue(transaction_amount))"/>
                        </xsl:call-template>
                    </summarylogdetails>
                </summaryloginfo>
                <summaryloginfo>
                    <filename>
                        <xsl:value-of select="'transactionlevel_'"/>
                        <xsl:value-of select="$summarylog.filename"/>
                        <xsl:value-of select="$currentsummarysplit"/>
                        <xsl:value-of select="'.'"/>
                        <xsl:value-of select="$summarylog.file.extension"/>
                    </filename>
                    <summarylogdetails>
                        <xsl:call-template name="header-record"/>
                        <xsl:apply-templates select="//transactionrecord[summarysplit=$currentsummarysplit]"/>
                    </summarylogdetails>
                </summaryloginfo>
            </xsl:for-each-group>
        </tl:summary_log>
    </xsl:template>
    
    <xsl:template match="transactionrecord">
        <xsl:value-of select="process_recordnumber"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="filenumber"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="filename"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="file_recordnumber"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="source_transactionid"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:choose>
            <xsl:when test="transaction_status = 'failed'"/>
            <xsl:otherwise>
                <xsl:value-of select="workday_transactionid"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="transaction_status"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="normalize-space(transaction_error_reason)"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="normalize-space(transaction_error_details)"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="format-number(atc:forceValue(transaction_amount),'#,###.00')"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="additional_information"/>
        <xsl:value-of select="$carriagereturn"/>
        <xsl:value-of select="$linefeed"/>
    </xsl:template>
    
    <xsl:template name="summary-record">
        <xsl:param name="files-processed"/>
        <xsl:param name="records-imported"/>
        <xsl:param name="records-skipped"/>
        <xsl:param name="records-failed"/>
        <xsl:param name="records-processed"/>
        <xsl:param name="amount-processed"/>
        <xsl:value-of select="'Summary'"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="'Files Processed: '"/>
        <xsl:value-of select="$files-processed"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="'Records Imported: '"/>
        <xsl:value-of select="$records-imported"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="'Records Skipped: '"/>
        <xsl:value-of select="$records-skipped"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="'Records Failed: '"/>
        <xsl:value-of select="$records-failed"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="'Total Records Processed: '"/>
        <xsl:value-of select="$records-processed"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="'Total Amount Processed: '"/>
        <xsl:value-of select="format-number(atc:forceValue($amount-processed),'#,###.00')"/>
        <xsl:value-of select="$carriagereturn"/>
        <xsl:value-of select="$linefeed"/>
    </xsl:template>
    
    <xsl:template name="header-record">
        <xsl:value-of select="'Process_Record_Number'"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="'File_Number'"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="'File_Name'"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="'File_Record_Number'"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="'Transaction_Id'"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="'Workday_Transaction_Id'"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="'Transaction_Status'"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="'Transaction_Error_Reason'"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="'Transaction_Error_Details'"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="'Transaction Amount'"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="'Additional_Information'"/>
        <xsl:value-of select="$carriagereturn"/>
        <xsl:value-of select="$linefeed"/>
    </xsl:template>
</xsl:stylesheet>