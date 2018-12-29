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
        <fhc:process fhc:process_name="Sync Supplier Data">
            <fhc:web_service_information>
                <fhc:get_ws_attributes>
                    <fhc:application>Resource_Management</fhc:application>
                    <fhc:request_filename>lib/get_request/sync_data/creategetsuppliersrequest.xsl</fhc:request_filename>
                    <fhc:request_type>supplier_list</fhc:request_type>
                    <fhc:filter_attributes>
                        <fhc:multi_instance_filters>
                            <fhc:filter_attribute>Supplier Status Filter</fhc:filter_attribute>
                            <fhc:filter_attribute>Supplier Categories Filter</fhc:filter_attribute>
                            <fhc:filter_attribute></fhc:filter_attribute>
                        </fhc:multi_instance_filters>
                        <fhc:single_instance_filters>
                            <fhc:filter_attribute></fhc:filter_attribute>
                            <fhc:filter_attribute></fhc:filter_attribute>
                            <fhc:filter_attribute></fhc:filter_attribute>
                        </fhc:single_instance_filters>
                    </fhc:filter_attributes>
                    <fhc:request_endpoint>standard_import_process/get_workday_paged_web_service_call</fhc:request_endpoint>
                    <fhc:response_endpoint fhc:group_rsp_data="false">standard_configuration_properties/split_and_process_response</fhc:response_endpoint>
                    <fhc:split_namespace>wd urn:com.workday/bsvc</fhc:split_namespace>
                    <fhc:split_tag>wd:Supplier_Data</fhc:split_tag>
                </fhc:get_ws_attributes>
                <fhc:put_ws_attributes>
                    <fhc:application>Resource_Management</fhc:application>
                    <fhc:request_filename>lib/put_request/sync_data/createupdatesupplierdatarequest.xsl</fhc:request_filename>
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
