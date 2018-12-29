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
        <fhc:process fhc:process_name="Move Plan Data">
            <fhc:web_service_information>
                <fhc:get_ws_attributes>
                    <fhc:application>RAAS</fhc:application>
                    <fhc:request_filename></fhc:request_filename>
                    <fhc:report_alias>Financial_Plan_Data</fhc:report_alias>
                    <fhc:request_type>default</fhc:request_type>
                    <fhc:filter_attributes>
                        <fhc:report_filters>
                            <fhc:report_filter fhc:filtername="lp_source_wid">Plan_Name!WID=</fhc:report_filter>
                        </fhc:report_filters>
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
                    <fhc:request_endpoint>standard_import_process/get_raas_web_service_call</fhc:request_endpoint>
                    <fhc:response_endpoint fhc:group_rsp_data="true">migration_to_region/split_and_process_response</fhc:response_endpoint>
                    <fhc:response_consolidate_filename>lib/get_request/move_budget/consolidate_plandata.xsl</fhc:response_consolidate_filename>
                    <fhc:split_namespace>ecmc https://ecmc.org/budget_format</fhc:split_namespace>
                    <fhc:split_tag>ecmc:budget_load</fhc:split_tag>
                </fhc:get_ws_attributes>
                <fhc:put_ws_attributes>
                    <fhc:application>Financial_Management</fhc:application>
                    <fhc:request_filename>lib/put_request/move_budget/importbudgettransform.xsl</fhc:request_filename>
                    <fhc:request_endpoint>standard_import_process/put_workday_web_serivce_call</fhc:request_endpoint>
                    <fhc:update_attributes>
                        <fhc:update_data_attribute>Transfer Plan Data</fhc:update_data_attribute>
                        <fhc:multi_instance_updates>
                            <fhc:update_attribute></fhc:update_attribute>
                            <fhc:update_attribute></fhc:update_attribute>
                            <fhc:update_attribute></fhc:update_attribute>
                        </fhc:multi_instance_updates>
                        <fhc:single_instance_updates>
                            <fhc:update_attribute></fhc:update_attribute>
                            <fhc:update_attribute></fhc:update_attribute>
                        </fhc:single_instance_updates>
                    </fhc:update_attributes>
                </fhc:put_ws_attributes>
            </fhc:web_service_information>
        </fhc:process>
        <fhc:process fhc:process_name="Move Plan Data Headcount">
            <fhc:web_service_information>
                <fhc:get_ws_attributes>
                    <fhc:application>RAAS</fhc:application>
                    <fhc:request_filename></fhc:request_filename>
                    <fhc:report_alias>Headcount_Plan_Data</fhc:report_alias>
                    <fhc:request_type>default</fhc:request_type>
                    <fhc:filter_attributes>
                        <fhc:report_filters>
                            <fhc:report_filter fhc:filtername="lp_source_wid">Plan!WID=</fhc:report_filter>
                        </fhc:report_filters>
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
                    <fhc:request_endpoint>standard_import_process/get_raas_web_service_call</fhc:request_endpoint>
                    <fhc:response_endpoint fhc:group_rsp_data="true">migration_to_region/split_and_process_response</fhc:response_endpoint>
                    <fhc:response_consolidate_filename>lib/get_request/move_budget/consolidate_plandata_headcount.xsl</fhc:response_consolidate_filename>
                    <fhc:split_namespace>ecmc https://ecmc.org/budget_format</fhc:split_namespace>
                    <fhc:split_tag>ecmc:budget_load</fhc:split_tag>
                </fhc:get_ws_attributes>
                <fhc:put_ws_attributes>
                    <fhc:application>Financial_Management</fhc:application>
                    <fhc:request_filename>lib/put_request/move_budget/importbudgettransform.xsl</fhc:request_filename>
                    <fhc:request_endpoint>standard_import_process/put_workday_web_serivce_call</fhc:request_endpoint>
                    <fhc:update_attributes>
                        <fhc:update_data_attribute>Transfer Plan Data</fhc:update_data_attribute>
                        <fhc:multi_instance_updates>
                            <fhc:update_attribute></fhc:update_attribute>
                            <fhc:update_attribute></fhc:update_attribute>
                            <fhc:update_attribute></fhc:update_attribute>
                        </fhc:multi_instance_updates>
                        <fhc:single_instance_updates>
                            <fhc:update_attribute></fhc:update_attribute>
                            <fhc:update_attribute></fhc:update_attribute>
                        </fhc:single_instance_updates>
                    </fhc:update_attributes>
                </fhc:put_ws_attributes>
            </fhc:web_service_information>
        </fhc:process>
        <fhc:process fhc:process_name="Get Headcount Amount Statistics">
            <fhc:web_service_information>
                <fhc:get_ws_attributes>
                    <fhc:application>RAAS</fhc:application>
                    <fhc:request_filename></fhc:request_filename>
                    <fhc:report_alias>Statistics_For_Headcount_Data</fhc:report_alias>
                    <fhc:request_type>default</fhc:request_type>
                    <fhc:filter_attributes>
                        <fhc:report_filters>
                        </fhc:report_filters>
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
                    <fhc:request_endpoint>standard_import_process/get_raas_web_service_call</fhc:request_endpoint>
                    <fhc:response_endpoint fhc:group_rsp_data="true">migration_to_region/store_hc_amt_as_lkp</fhc:response_endpoint>
                    <fhc:response_consolidate_filename>lib/get_request/move_budget/conform_statisticdata.xsl</fhc:response_consolidate_filename>
                    <fhc:split_namespace>wd urn:com.workday.report/Statistic_Data_for_Headcount_Cost_of_Workforce</fhc:split_namespace>
                    <fhc:split_tag>wd:Report_Data</fhc:split_tag>
                </fhc:get_ws_attributes>
                <fhc:put_ws_attributes>
                    <fhc:application>Financial_Management</fhc:application>
                    <fhc:request_filename></fhc:request_filename>
                    <fhc:request_endpoint></fhc:request_endpoint>
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
                        </fhc:single_instance_updates>
                    </fhc:update_attributes>
                </fhc:put_ws_attributes>
            </fhc:web_service_information>
        </fhc:process>
        <fhc:process fhc:process_name="Move Plan Data Historical">
            <fhc:web_service_information>
                <fhc:get_ws_attributes>
                    <fhc:application>RAAS</fhc:application>
                    <fhc:request_filename></fhc:request_filename>
                    <fhc:report_alias>Financial_Plan_Data</fhc:report_alias>
                    <fhc:request_type>default</fhc:request_type>
                    <fhc:filter_attributes>
                        <fhc:report_filters>
                            <fhc:report_filter fhc:filtername="lp_source_wid">Plan_Name!WID=</fhc:report_filter>
                        </fhc:report_filters>
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
                    <fhc:request_endpoint>standard_import_process/get_raas_web_service_call</fhc:request_endpoint>
                    <fhc:response_endpoint fhc:group_rsp_data="true">migration_to_region/split_and_process_response</fhc:response_endpoint>
                    <fhc:response_consolidate_filename>lib/get_request/move_budget/consolidate_plandata_historical.xsl</fhc:response_consolidate_filename>
                    <fhc:split_namespace>ecmc https://ecmc.org/budget_format</fhc:split_namespace>
                    <fhc:split_tag>ecmc:budget_load</fhc:split_tag>
                </fhc:get_ws_attributes>
                <fhc:put_ws_attributes>
                    <fhc:application>Financial_Management</fhc:application>
                    <fhc:request_filename>lib/put_request/move_budget/importbudgettransform.xsl</fhc:request_filename>
                    <fhc:request_endpoint>standard_import_process/put_workday_web_serivce_call</fhc:request_endpoint>
                    <fhc:update_attributes>
                        <fhc:update_data_attribute>Transfer Plan Data</fhc:update_data_attribute>
                        <fhc:multi_instance_updates>
                            <fhc:update_attribute></fhc:update_attribute>
                            <fhc:update_attribute></fhc:update_attribute>
                            <fhc:update_attribute></fhc:update_attribute>
                        </fhc:multi_instance_updates>
                        <fhc:single_instance_updates>
                            <fhc:update_attribute></fhc:update_attribute>
                            <fhc:update_attribute></fhc:update_attribute>
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
