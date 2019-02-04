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
        <fhc:process fhc:process_name="Get Supplier Data File">
            <fhc:web_service_information>
                <fhc:get_ws_attributes>
                    <fhc:application>Retrieval Service</fhc:application>
                    <fhc:sub_process fhc:execute_subprocess="true"  fhc:subprocess_name="get_request">
                        <fhc:filename/>
                        <fhc:sub_type>retrieval</fhc:sub_type>
                        <fhc:endpoint>common_sftp_file_processing/process_retrieved_file</fhc:endpoint>
                        <fhc:sub_process fhc:execute_subprocess="true" fhc:subprocess_name="convert_to_xml">
                            <fhc:filename>lib/convert_file/transform_file_to_xml_csv.xsd</fhc:filename>
                        </fhc:sub_process>
                        <fhc:sub_process fhc:execute_subprocess="true" fhc:subprocess_name="conform_xml">
                            <fhc:filename>lib/convert_supplier_xml_to_standard.xsl</fhc:filename>
                            <fhc:endpoint>mass_sync_data/conform_xml</fhc:endpoint>
                        </fhc:sub_process>
                        <fhc:sub_process fhc:execute_subprocess="false" fhc:subprocess_name="start_put"/>
                    </fhc:sub_process>
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
                        <fhc:file_label>Retrieved</fhc:file_label>
                    </fhc:filter_attributes>
                    <fhc:split_data fhc:namespace="none">
                        <fhc:tag/>
                    </fhc:split_data>
                </fhc:get_ws_attributes>
                <fhc:put_ws_attributes>
                    <fhc:application>Variable</fhc:application>
                    <fhc:sub_process fhc:execute_subprocess="false" fhc:subprocess_name="put_request"/>
                    <fhc:workday_transaction_id_data fhc:namespace="none">
                        <fhc:tag/>
                    </fhc:workday_transaction_id_data>
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
        <fhc:process fhc:process_name="Sync Supplier Data">
            <fhc:web_service_information>
                <fhc:get_ws_attributes>
                    <fhc:application>Resource_Management</fhc:application>
                    <fhc:sub_process fhc:execute_subprocess="true" fhc:subprocess_name="get_request">
                        <fhc:filename>lib/get_request/sync_data/creategetsuppliersrequest.xsl</fhc:filename>
                        <fhc:sub_type>supplier_list</fhc:sub_type>
                        <fhc:endpoint>standard_import_process/get_workday_paged_web_service_call</fhc:endpoint>
                        <fhc:sub_process fhc:execute_subprocess="false" fhc:subprocess_name="convert_to_xml">
                        </fhc:sub_process>
                        <fhc:response fhc:execute_subprocess="true" fhc:subprocess_name="start_put">
                            <fhc:endpoint>standard_configuration_properties/split_and_process_response</fhc:endpoint>
                        </fhc:response>
                    </fhc:sub_process>
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
                    <fhc:split_data fhc:namespace="wd:Supplier_Data">
                        <fhc:tag>wd urn:com.workday/bsvc</fhc:tag>
                    </fhc:split_data>
                </fhc:get_ws_attributes>
                <fhc:put_ws_attributes>
                    <fhc:application>Resource_Management</fhc:application>
                    <fhc:sub_process fhc:execute_subprocess="true" fhc:subprocess_name="put_request">
                        <fhc:filename>lib/put_request/sync_data/createupdatesupplierdatarequest.xsl</fhc:filename>
                        <fhc:sub_type>import</fhc:sub_type>
                        <fhc:endpoint>standard_import_process/put_workday_web_serivce_call</fhc:endpoint>
                    </fhc:sub_process>
                    <fhc:workday_transaction_id_data fhc:namespace="wd urn:com.workday/bsvc">
                        <fhc:tag>//wd:Supplier_ID</fhc:tag>
                    </fhc:workday_transaction_id_data>
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
