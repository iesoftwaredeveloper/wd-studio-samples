<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:fhc="https://github.com/firehawk-consulting/firehawk/schemas/configuration_file_sync_data.xsd"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:param name="running.process" select="'Organizations'"/>
    <xsl:param name="web.service.start.date"/>
    <xsl:param name="web.service.end.date"/>
    <xsl:param name="lp.source.filter.wid"/>

    <xsl:template match="/">
        <!-- <fhc:running_process> -->
            <xsl:apply-templates select="document('')//fhc:process[@fhc:process_name = $running.process]"/>
        <!-- </fhc:running_process> -->
    </xsl:template>

    <fhc:processes>
        <fhc:process fhc:process_name="Borrower Refund Data Import">
            <fhc:web_service_information>
                <fhc:get_ws_attributes>
                    <fhc:application>Resource_Management</fhc:application>
                    <fhc:request_filename>lib/get_request/sync_data/creategetadhocpayeesrequest.xsl</fhc:request_filename>
                    <fhc:request_type fhc:convert_to_xml="false">payee_list</fhc:request_type>
                    <fhc:filter_attributes>
                        <fhc:multi_instance_filters>
                            <fhc:filter_attribute></fhc:filter_attribute>
                            <fhc:filter_attribute></fhc:filter_attribute>
                            <fhc:filter_attribute></fhc:filter_attribute>
                        </fhc:multi_instance_filters>
                        <fhc:single_instance_filters>
                            <fhc:filter_attribute></fhc:filter_attribute>
                            <fhc:filter_attribute></fhc:filter_attribute>
                            <fhc:filter_attribute></fhc:filter_attribute>
                        </fhc:single_instance_filters>
                    </fhc:filter_attributes>
                    <fhc:request_endpoint>common_sftp_file_processing/process_retrieved_file</fhc:request_endpoint>
                    <fhc:response_endpoint fhc:group_rsp_data="false">standard_configuration_properties/split_and_process_response</fhc:response_endpoint>
                    <fhc:split_namespace>ecmc https://ecmc.org/ad_hoc_payment_format</fhc:split_namespace>
                    <fhc:split_tag>ecmc:ad_hoc_payment</fhc:split_tag>
                </fhc:get_ws_attributes>
                <fhc:put_ws_attributes>
                    <fhc:application>Resource_Management</fhc:application>
                    <fhc:request_filename>lib/put_request/supplier_invoice_imports/convert_ad_hoc_payment.xsl</fhc:request_filename>
                    <fhc:request_endpoint>standard_import_process/put_workday_web_serivce_call</fhc:request_endpoint>
                    <fhc:workday_transaction_id_tag fhc:transaction_id_namespace="wd urn:com.workday/bsvc">//wd:Supplier_ID</fhc:workday_transaction_id_tag>
                    <fhc:update_attributes>
                        <fhc:update_data_attribute>Update Supplier Data</fhc:update_data_attribute>
                        <fhc:multi_instance_updates>
                            <fhc:update_attribute></fhc:update_attribute>
                            <fhc:update_attribute></fhc:update_attribute>
                            <fhc:update_attribute></fhc:update_attribute>
                        </fhc:multi_instance_updates>
                        <fhc:single_instance_updates>
                            <fhc:update_attribute>Remittance Integration System</fhc:update_attribute>
                            <fhc:update_attribute>Supplier Inactive Status</fhc:update_attribute>
                            <fhc:update_attribute>Supplier Status Change Reason</fhc:update_attribute>
                        </fhc:single_instance_updates>
                    </fhc:update_attributes>
                </fhc:put_ws_attributes>
            </fhc:web_service_information>
        </fhc:process>
        <fhc:process fhc:process_name="EPIC Claims Suppliers">
            <fhc:web_service_information>
                <fhc:get_ws_attributes>
                    <fhc:application>Retrieval Service</fhc:application>
                    <fhc:request_filename>lib/convert_file/transform_file_to_xml_csv.xsd</fhc:request_filename>
                    <fhc:request_type fhc:convert_to_xml="true">retrieval</fhc:request_type>
                    <fhc:filter_attributes>
                        <fhc:multi_instance_filters>
                            <fhc:filter_attribute></fhc:filter_attribute>
                            <fhc:filter_attribute></fhc:filter_attribute>
                            <fhc:filter_attribute></fhc:filter_attribute>
                        </fhc:multi_instance_filters>
                        <fhc:single_instance_filters>
                            <fhc:filter_attribute></fhc:filter_attribute>
                            <fhc:filter_attribute></fhc:filter_attribute>
                            <fhc:filter_attribute></fhc:filter_attribute>
                        </fhc:single_instance_filters>
                        <fhc:file_label>Supplier Files [EPIC Claims]</fhc:file_label>
                    </fhc:filter_attributes>
                    <fhc:request_endpoint>common_sftp_file_processing/process_retrieved_file</fhc:request_endpoint>
                    <fhc:response_endpoint fhc:group_rsp_data="false">standard_configuration_properties/copy_message_to_file_var</fhc:response_endpoint>
                    <fhc:split_namespace></fhc:split_namespace>
                    <fhc:split_tag></fhc:split_tag>
                </fhc:get_ws_attributes>
                <fhc:put_ws_attributes>
                    <fhc:application>Variable</fhc:application>
                    <fhc:request_filename>lib/convert_epic_claims_supplier.xsl</fhc:request_filename>
                    <fhc:request_endpoint>supplier_invoice_imports/store-retrieved_as_lkp</fhc:request_endpoint>
                    <fhc:workday_transaction_id_tag fhc:transaction_id_namespace=""></fhc:workday_transaction_id_tag>
                    <fhc:update_attributes>
                        <fhc:update_data_attribute></fhc:update_data_attribute>
                        <fhc:multi_instance_updates>
                            <fhc:update_attribute></fhc:update_attribute>
                            <fhc:update_attribute></fhc:update_attribute>
                            <fhc:update_attribute></fhc:update_attribute>
                        </fhc:multi_instance_updates>
                        <fhc:single_instance_updates>
                            <fhc:update_attribute></fhc:update_attribute>
                            <fhc:update_attribute></fhc:update_attribute>
                            <fhc:update_attribute></fhc:update_attribute>
                        </fhc:single_instance_updates>
                    </fhc:update_attributes>
                </fhc:put_ws_attributes>
            </fhc:web_service_information>
        </fhc:process>
        <fhc:process fhc:process_name="EPIC Claims Supplier Invoice Data Import">
            <fhc:web_service_information>
                <fhc:get_ws_attributes>
                    <fhc:application>Resource_Management</fhc:application>
                    <fhc:request_filename fhc:convert_to_xml="true">lib/get_request/sync_data/creategetadhocpayeesrequest.xsl</fhc:request_filename>
                    <fhc:request_type fhc:convert_to_xml="true">payee_list</fhc:request_type>
                    <fhc:filter_attributes>
                        <fhc:multi_instance_filters>
                            <fhc:filter_attribute></fhc:filter_attribute>
                            <fhc:filter_attribute></fhc:filter_attribute>
                            <fhc:filter_attribute></fhc:filter_attribute>
                        </fhc:multi_instance_filters>
                        <fhc:single_instance_filters>
                            <fhc:filter_attribute></fhc:filter_attribute>
                            <fhc:filter_attribute></fhc:filter_attribute>
                            <fhc:filter_attribute></fhc:filter_attribute>
                        </fhc:single_instance_filters>
                    </fhc:filter_attributes>
                    <fhc:request_endpoint>common_sftp_file_processing/process_retrieved_file</fhc:request_endpoint>
                    <fhc:response_endpoint fhc:group_rsp_data="false">standard_configuration_properties/split_and_process_response</fhc:response_endpoint>
                    <fhc:split_namespace>ecmc https://ecmc.org/ad_hoc_payment_format</fhc:split_namespace>
                    <fhc:split_tag>ecmc:ad_hoc_payment</fhc:split_tag>
                </fhc:get_ws_attributes>
                <fhc:put_ws_attributes>
                    <fhc:application>Resource_Management</fhc:application>
                    <fhc:request_filename>lib/put_request/supplier_invoice_imports/convert_ad_hoc_payment.xsl</fhc:request_filename>
                    <fhc:request_endpoint>standard_import_process/put_workday_web_serivce_call</fhc:request_endpoint>
                    <fhc:workday_transaction_id_tag fhc:transaction_id_namespace="wd urn:com.workday/bsvc">//wd:Supplier_ID</fhc:workday_transaction_id_tag>
                    <fhc:update_attributes>
                        <fhc:update_data_attribute>Update Supplier Data</fhc:update_data_attribute>
                        <fhc:multi_instance_updates>
                            <fhc:update_attribute></fhc:update_attribute>
                            <fhc:update_attribute></fhc:update_attribute>
                            <fhc:update_attribute></fhc:update_attribute>
                        </fhc:multi_instance_updates>
                        <fhc:single_instance_updates>
                            <fhc:update_attribute>Remittance Integration System</fhc:update_attribute>
                            <fhc:update_attribute>Supplier Inactive Status</fhc:update_attribute>
                            <fhc:update_attribute>Supplier Status Change Reason</fhc:update_attribute>
                        </fhc:single_instance_updates>
                    </fhc:update_attributes>
                </fhc:put_ws_attributes>
            </fhc:web_service_information>
        </fhc:process>
    </fhc:processes>

    <xsl:template match="fhc:report_filters">
        <fhc:report_filter>
            <xsl:for-each select="fhc:report_filter">
                <xsl:if test="position() = 1">
                    <xsl:value-of select="'?'"/>
                </xsl:if>
                <xsl:choose>
                    <xsl:when test="@fhc:filtername='start_date'">
                        <xsl:value-of select="."/>
                        <xsl:value-of select="format-dateTime($web.service.start.date,'[Y0001]-[M01]-[D01]')"/>
                    </xsl:when>
                    <xsl:when test="@fhc:filtername='end_date'">
                        <xsl:value-of select="."/>
                        <xsl:value-of select="format-dateTime($web.service.end.date,'[Y0001]-[M01]-[D01]')"/>
                    </xsl:when>
                    <xsl:when test="@fhc:filtername='additional_options'">
                        <xsl:value-of select="."/>
                        <xsl:value-of select="'f6949d8151bb100018a5d49a49fc2463'"/>
                    </xsl:when>
                    <xsl:when test="@fhc:filtername='lp_source_wid'">
                        <xsl:value-of select="."/>
                        <xsl:value-of select="$lp.source.filter.wid"/>
                    </xsl:when>
                 </xsl:choose>
                 <xsl:if test="position() != last()">
                    <xsl:value-of select="'&amp;'"/>
                 </xsl:if>
            </xsl:for-each>
        </fhc:report_filter>
    </xsl:template>

    <xsl:template match="@*|node()">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
