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
        <fhc:process fhc:process_name="Organizations">
            <fhc:web_service_information>
                <fhc:get_ws_attributes>
                    <fhc:application>Staffing</fhc:application>
                    <fhc:request_filename>lib/get_request/migration_to_region/creategetorganization.xsl</fhc:request_filename>
                    <fhc:request_type>default</fhc:request_type>
                    <fhc:filter_attributes>
                        <fhc:multi_instance_filters>
                            <fhc:filter_attribute>Existing Organization Type</fhc:filter_attribute>
                            <fhc:filter_attribute></fhc:filter_attribute>
                            <fhc:filter_attribute></fhc:filter_attribute>
                        </fhc:multi_instance_filters>
                        <fhc:single_instance_filters>
                            <fhc:filter_attribute></fhc:filter_attribute>
                            <fhc:filter_attribute></fhc:filter_attribute>
                            <fhc:filter_attribute></fhc:filter_attribute>
                        </fhc:single_instance_filters>
                    </fhc:filter_attributes>
                    <fhc:request_endpoint>standard_import_process/get_workday_paged_web_service_call</fhc:request_endpoint>
                    <fhc:response_endpoint fhc:group_rsp_data="false">migration_to_region/split_and_process_response</fhc:response_endpoint>
                    <fhc:split_namespace>wd urn:com.workday/bsvc</fhc:split_namespace>
                    <fhc:split_tag>wd:Organization_Data</fhc:split_tag>
                </fhc:get_ws_attributes>
                <fhc:put_ws_attributes>
                    <fhc:application>Human_Resources</fhc:application>
                    <fhc:request_filename>lib/put_request/migration_to_region/createputorganization.xsl</fhc:request_filename>
                    <fhc:request_endpoint>standard_import_process/put_workday_web_serivce_call</fhc:request_endpoint>
                    <fhc:update_attributes>
                        <fhc:update_data_attribute>Create New Organizations</fhc:update_data_attribute>
                        <fhc:multi_instance_updates>
                            <fhc:update_attribute></fhc:update_attribute>
                            <fhc:update_attribute></fhc:update_attribute>
                            <fhc:update_attribute></fhc:update_attribute>
                        </fhc:multi_instance_updates>
                        <fhc:single_instance_updates>
                            <fhc:update_attribute>New Organization Type</fhc:update_attribute>
                            <fhc:update_attribute></fhc:update_attribute>
                        </fhc:single_instance_updates>
                    </fhc:update_attributes>
                </fhc:put_ws_attributes>
            </fhc:web_service_information>
        </fhc:process>
        <fhc:process fhc:process_name="Organization Replace Ref Ids">
            <fhc:web_service_information>
                <fhc:get_ws_attributes>
                    <fhc:application>Staffing</fhc:application>
                    <fhc:request_filename>lib/get_request/migration_to_region/creategetorganization.xsl</fhc:request_filename>
                    <fhc:request_type>default</fhc:request_type>
                    <fhc:filter_attributes>
                        <fhc:multi_instance_filters>
                            <fhc:filter_attribute>Existing Organization Type</fhc:filter_attribute>
                            <fhc:filter_attribute></fhc:filter_attribute>
                            <fhc:filter_attribute></fhc:filter_attribute>
                        </fhc:multi_instance_filters>
                        <fhc:single_instance_filters>
                            <fhc:filter_attribute></fhc:filter_attribute>
                            <fhc:filter_attribute></fhc:filter_attribute>
                            <fhc:filter_attribute></fhc:filter_attribute>
                        </fhc:single_instance_filters>
                    </fhc:filter_attributes>
                    <fhc:request_endpoint>standard_import_process/get_workday_paged_web_service_call</fhc:request_endpoint>
                    <fhc:response_endpoint fhc:group_rsp_data="false">migration_to_region/split_and_process_response</fhc:response_endpoint>
                    <fhc:split_namespace>wd urn:com.workday/bsvc</fhc:split_namespace>
                    <fhc:split_tag>wd:Organization_Data</fhc:split_tag>
                </fhc:get_ws_attributes>
                <fhc:put_ws_attributes>
                    <fhc:application>Integrations</fhc:application>
                    <fhc:request_filename>lib/put_request/migration_to_region/createupdatereferenceids.xsl</fhc:request_filename>
                    <fhc:request_endpoint>standard_import_process/put_workday_web_serivce_call</fhc:request_endpoint>
                    <fhc:update_attributes>
                        <fhc:update_data_attribute>Create New Organizations</fhc:update_data_attribute>
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
        <fhc:process fhc:process_name="Organization Hierarchies">
            <fhc:web_service_information>
                <fhc:get_ws_attributes>
                    <fhc:application>Staffing</fhc:application>
                    <fhc:request_filename>lib/get_request/migration_to_region/creategetorganization.xsl</fhc:request_filename>
                    <fhc:request_type>default</fhc:request_type>
                    <fhc:filter_attributes>
                        <fhc:multi_instance_filters>
                            <fhc:filter_attribute>Existing Organization Hierarchy Type</fhc:filter_attribute>
                            <fhc:filter_attribute></fhc:filter_attribute>
                            <fhc:filter_attribute></fhc:filter_attribute>
                        </fhc:multi_instance_filters>
                        <fhc:single_instance_filters>
                            <fhc:filter_attribute></fhc:filter_attribute>
                            <fhc:filter_attribute></fhc:filter_attribute>
                            <fhc:filter_attribute></fhc:filter_attribute>
                        </fhc:single_instance_filters>
                    </fhc:filter_attributes>
                    <fhc:request_endpoint>standard_import_process/get_workday_paged_web_service_call</fhc:request_endpoint>
                    <fhc:response_endpoint fhc:group_rsp_data="false">migration_to_region/split_and_process_response</fhc:response_endpoint>
                    <fhc:split_namespace>wd urn:com.workday/bsvc</fhc:split_namespace>
                    <fhc:split_tag>wd:Organization_Data</fhc:split_tag>
                </fhc:get_ws_attributes>
                <fhc:put_ws_attributes>
                    <fhc:application>Human_Resources</fhc:application>
                    <fhc:request_filename>lib/put_request/migration_to_region/createputorganizationhierarchy.xsl</fhc:request_filename>
                    <fhc:request_endpoint>standard_import_process/put_workday_web_serivce_call</fhc:request_endpoint>
                    <fhc:update_attributes>
                        <fhc:update_data_attribute>Create New Organizations</fhc:update_data_attribute>
                        <fhc:multi_instance_updates>
                            <fhc:update_attribute></fhc:update_attribute>
                            <fhc:update_attribute></fhc:update_attribute>
                            <fhc:update_attribute></fhc:update_attribute>
                        </fhc:multi_instance_updates>
                        <fhc:single_instance_updates>
                            <fhc:update_attribute>New Organization Hierarchy Type</fhc:update_attribute>
                            <fhc:update_attribute></fhc:update_attribute>
                        </fhc:single_instance_updates>
                    </fhc:update_attributes>
                </fhc:put_ws_attributes>
            </fhc:web_service_information>
        </fhc:process>
        <fhc:process fhc:process_name="Organization Hierarchies Replace Ref Ids">
            <fhc:web_service_information>
                <fhc:get_ws_attributes>
                    <fhc:application>Staffing</fhc:application>
                    <fhc:request_filename>lib/get_request/migration_to_region/creategetorganization.xsl</fhc:request_filename>
                    <fhc:request_type>default</fhc:request_type>
                    <fhc:filter_attributes>
                        <fhc:multi_instance_filters>
                            <fhc:filter_attribute>Existing Organization Hierarchy Type</fhc:filter_attribute>
                            <fhc:filter_attribute></fhc:filter_attribute>
                            <fhc:filter_attribute></fhc:filter_attribute>
                        </fhc:multi_instance_filters>
                        <fhc:single_instance_filters>
                            <fhc:filter_attribute></fhc:filter_attribute>
                            <fhc:filter_attribute></fhc:filter_attribute>
                            <fhc:filter_attribute></fhc:filter_attribute>
                        </fhc:single_instance_filters>
                    </fhc:filter_attributes>
                    <fhc:request_endpoint>standard_import_process/get_workday_paged_web_service_call</fhc:request_endpoint>
                    <fhc:response_endpoint fhc:group_rsp_data="false">migration_to_region/split_and_process_response</fhc:response_endpoint>
                    <fhc:split_namespace>wd urn:com.workday/bsvc</fhc:split_namespace>
                    <fhc:split_tag>wd:Organization_Data</fhc:split_tag>
                </fhc:get_ws_attributes>
                <fhc:put_ws_attributes>
                    <fhc:application>Integrations</fhc:application>
                    <fhc:request_filename>lib/put_request/migration_to_region/createupdatereferenceids.xsl</fhc:request_filename>
                    <fhc:request_endpoint>standard_import_process/put_workday_web_serivce_call</fhc:request_endpoint>
                    <fhc:update_attributes>
                        <fhc:update_data_attribute>Create New Organizations</fhc:update_data_attribute>
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
        <fhc:process fhc:process_name="Journal Entry Beginning Balances (2017)">
            <fhc:web_service_information>
                <fhc:get_ws_attributes>
                    <fhc:application>RAAS</fhc:application>
                    <fhc:request_filename></fhc:request_filename>
                    <fhc:report_alias>Journal_Migration_Data_BegBal</fhc:report_alias>
                    <fhc:request_type>default</fhc:request_type>
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
                    <fhc:request_endpoint>standard_import_process/get_raas_web_service_call</fhc:request_endpoint>
                    <fhc:response_endpoint fhc:group_rsp_data="true">migration_to_region/split_and_process_response</fhc:response_endpoint>
                    <fhc:response_consolidate_filename>lib/get_request/consolidate_journaldata.xsl</fhc:response_consolidate_filename>
                    <fhc:split_namespace>bsvc urn:com.workday/bsvc</fhc:split_namespace>
                    <fhc:split_tag>bsvc:Import_Accounting_Journal_Request</fhc:split_tag>
                </fhc:get_ws_attributes>
                <fhc:put_ws_attributes>
                    <fhc:application>Financial_Management</fhc:application>
                    <fhc:request_filename>lib/put_request/migration_to_region/createsubmitjournalentry.xsl</fhc:request_filename>
                    <fhc:request_endpoint>standard_import_process/put_workday_web_serivce_call</fhc:request_endpoint>
                    <fhc:update_attributes>
                        <fhc:update_data_attribute>Create New Transactions</fhc:update_data_attribute>
                        <fhc:multi_instance_updates>
                            <fhc:update_attribute></fhc:update_attribute>
                            <fhc:update_attribute></fhc:update_attribute>
                            <fhc:update_attribute></fhc:update_attribute>
                        </fhc:multi_instance_updates>
                        <fhc:single_instance_updates>
                            <fhc:update_attribute>Journal Source for Migration</fhc:update_attribute>
                            <fhc:update_attribute></fhc:update_attribute>
                        </fhc:single_instance_updates>
                    </fhc:update_attributes>
                </fhc:put_ws_attributes>
            </fhc:web_service_information>
        </fhc:process>
        <fhc:process fhc:process_name="Journal Entry Monthly Balances">
            <fhc:web_service_information>
                <fhc:get_ws_attributes>
                    <fhc:application>RAAS</fhc:application>
                    <fhc:request_filename></fhc:request_filename>
                    <fhc:report_alias>Journal_Migration_Data</fhc:report_alias>
                    <fhc:request_type>default</fhc:request_type>
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
                    <fhc:request_endpoint>standard_import_process/get_raas_web_service_call</fhc:request_endpoint>
                    <fhc:response_endpoint fhc:group_rsp_data="true">migration_to_region/split_and_process_response</fhc:response_endpoint>
                    <fhc:response_consolidate_filename>lib/get_request/consolidate_journaldata.xsl</fhc:response_consolidate_filename>
                    <fhc:split_namespace>bsvc urn:com.workday/bsvc</fhc:split_namespace>
                    <fhc:split_tag>bsvc:Import_Accounting_Journal_Request</fhc:split_tag>
                </fhc:get_ws_attributes>
                <fhc:put_ws_attributes>
                    <fhc:application>Financial_Management</fhc:application>
                    <fhc:request_filename>lib/put_request/migration_to_region/createsubmitjournalentry.xsl</fhc:request_filename>
                    <fhc:request_endpoint>standard_import_process/put_workday_web_serivce_call</fhc:request_endpoint>
                    <fhc:update_attributes>
                        <fhc:update_data_attribute>Create New Transactions</fhc:update_data_attribute>
                        <fhc:multi_instance_updates>
                            <fhc:update_attribute></fhc:update_attribute>
                            <fhc:update_attribute></fhc:update_attribute>
                            <fhc:update_attribute></fhc:update_attribute>
                        </fhc:multi_instance_updates>
                        <fhc:single_instance_updates>
                            <fhc:update_attribute>Journal Source for Migration</fhc:update_attribute>
                            <fhc:update_attribute></fhc:update_attribute>
                        </fhc:single_instance_updates>
                    </fhc:update_attributes>
                </fhc:put_ws_attributes>
            </fhc:web_service_information>
        </fhc:process>
        <fhc:process fhc:process_name="Worker Organization Assignments">
            <fhc:web_service_information>
                <fhc:get_ws_attributes>
                    <fhc:application>Human_Resources</fhc:application>
                    <fhc:request_filename>lib/get_request/migration_to_region/creategetworkersrequest.xsl</fhc:request_filename>
                    <fhc:report_alias></fhc:report_alias>
                    <fhc:request_type>default</fhc:request_type>
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
                    <fhc:request_endpoint>standard_import_process/get_workday_paged_web_service_call</fhc:request_endpoint>
                    <fhc:response_endpoint fhc:group_rsp_data="true">migration_to_region/split_and_process_response</fhc:response_endpoint>
                    <fhc:response_consolidate_filename>lib/get_request/consolidate_workerdata.xsl</fhc:response_consolidate_filename>
                    <fhc:split_namespace>wd urn:com.workday/bsvc</fhc:split_namespace>
                    <fhc:split_tag>wd:Worker</fhc:split_tag>
                </fhc:get_ws_attributes>
                <fhc:put_ws_attributes>
                    <fhc:application>Staffing</fhc:application>
                    <fhc:request_filename>lib/put_request/migration_to_region/createassignorganizations.xsl</fhc:request_filename>
                    <fhc:request_endpoint>standard_import_process/put_workday_web_serivce_call</fhc:request_endpoint>
                    <fhc:update_attributes>
                        <fhc:update_data_attribute>Move Workers</fhc:update_data_attribute>
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
        <fhc:process fhc:process_name="Project Data">
            <fhc:web_service_information>
                <fhc:get_ws_attributes>
                    <fhc:application>Resource_Management</fhc:application>
                    <fhc:request_filename>lib/get_request/migration_to_region/creategetprojectrequest.xsl</fhc:request_filename>
                    <fhc:report_alias></fhc:report_alias>
                    <fhc:request_type>default</fhc:request_type>
                    <fhc:filter_attributes>
                        <fhc:multi_instance_filters>
                            <fhc:filter_attribute>Project Status</fhc:filter_attribute>
                            <fhc:filter_attribute></fhc:filter_attribute>
                            <fhc:filter_attribute></fhc:filter_attribute>
                        </fhc:multi_instance_filters>
                        <fhc:single_instance_filters>
                            <fhc:filter_attribute></fhc:filter_attribute>
                            <fhc:filter_attribute></fhc:filter_attribute>
                            <fhc:filter_attribute></fhc:filter_attribute>
                        </fhc:single_instance_filters>
                    </fhc:filter_attributes>
                    <fhc:request_endpoint>standard_import_process/get_workday_paged_web_service_call</fhc:request_endpoint>
                    <fhc:response_endpoint fhc:group_rsp_data="false">migration_to_region/split_and_process_response</fhc:response_endpoint>
                    <fhc:split_namespace>wd urn:com.workday/bsvc</fhc:split_namespace>
                    <fhc:split_tag>wd:Project</fhc:split_tag>
                </fhc:get_ws_attributes>
                <fhc:put_ws_attributes>
                    <fhc:application>Financial_Management</fhc:application>
                    <fhc:request_filename>lib/put_request/migration_to_region/createsubmitproject.xsl</fhc:request_filename>
                    <fhc:request_endpoint>standard_import_process/put_workday_web_serivce_call</fhc:request_endpoint>
                    <fhc:update_attributes>
                        <fhc:update_data_attribute>Update Projects</fhc:update_data_attribute>
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
        <fhc:process fhc:process_name="Statistic Definitions">
            <fhc:web_service_information>
                <fhc:get_ws_attributes>
                    <fhc:application>Financial_Management</fhc:application>
                    <fhc:request_filename>lib/get_request/migration_to_region/creategetstatisticdefintions.xsl</fhc:request_filename>
                    <fhc:report_alias></fhc:report_alias>
                    <fhc:request_type>default</fhc:request_type>
                    <fhc:filter_attributes>
                        <fhc:multi_instance_filters>
                            <fhc:filter_attribute>Statistic Definitions</fhc:filter_attribute>
                            <fhc:filter_attribute></fhc:filter_attribute>
                            <fhc:filter_attribute></fhc:filter_attribute>
                        </fhc:multi_instance_filters>
                        <fhc:single_instance_filters>
                            <fhc:filter_attribute></fhc:filter_attribute>
                            <fhc:filter_attribute></fhc:filter_attribute>
                            <fhc:filter_attribute></fhc:filter_attribute>
                        </fhc:single_instance_filters>
                    </fhc:filter_attributes>
                    <fhc:request_endpoint>standard_import_process/get_workday_paged_web_service_call</fhc:request_endpoint>
                    <fhc:response_endpoint fhc:group_rsp_data="false">migration_to_region/split_and_process_response</fhc:response_endpoint>
                    <fhc:split_namespace>wd urn:com.workday/bsvc</fhc:split_namespace>
                    <fhc:split_tag>wd:Statistic_Definition</fhc:split_tag>
                </fhc:get_ws_attributes>
                <fhc:put_ws_attributes>
                    <fhc:application>Financial_Management</fhc:application>
                    <fhc:request_filename>lib/put_request/migration_to_region/createputstatisticdefinition.xsl</fhc:request_filename>
                    <fhc:request_endpoint>standard_import_process/put_workday_web_serivce_call</fhc:request_endpoint>
                    <fhc:update_attributes>
                        <fhc:update_data_attribute>Update Statistics</fhc:update_data_attribute>
                        <fhc:multi_instance_updates>
                            <fhc:update_attribute></fhc:update_attribute>
                            <fhc:update_attribute></fhc:update_attribute>
                            <fhc:update_attribute></fhc:update_attribute>
                        </fhc:multi_instance_updates>
                        <fhc:single_instance_updates>
                            <fhc:update_attribute>Existing Worktag Type</fhc:update_attribute>
                            <fhc:update_attribute>New Worktag Type</fhc:update_attribute>
                        </fhc:single_instance_updates>
                    </fhc:update_attributes>
                </fhc:put_ws_attributes>
            </fhc:web_service_information>
        </fhc:process>
        <fhc:process fhc:process_name="Statistic Definitions For Budget">
            <fhc:web_service_information>
                <fhc:get_ws_attributes>
                    <fhc:application>Financial_Management</fhc:application>
                    <fhc:request_filename>lib/get_request/migration_to_region/creategetstatisticdefintions.xsl</fhc:request_filename>
                    <fhc:report_alias></fhc:report_alias>
                    <fhc:request_type>default</fhc:request_type>
                    <fhc:filter_attributes>
                        <fhc:multi_instance_filters>
                            <fhc:filter_attribute>Statistic Definitions</fhc:filter_attribute>
                            <fhc:filter_attribute></fhc:filter_attribute>
                            <fhc:filter_attribute></fhc:filter_attribute>
                        </fhc:multi_instance_filters>
                        <fhc:single_instance_filters>
                            <fhc:filter_attribute></fhc:filter_attribute>
                            <fhc:filter_attribute></fhc:filter_attribute>
                            <fhc:filter_attribute></fhc:filter_attribute>
                        </fhc:single_instance_filters>
                    </fhc:filter_attributes>
                    <fhc:request_endpoint>standard_import_process/get_workday_paged_web_service_call</fhc:request_endpoint>
                    <fhc:response_endpoint fhc:group_rsp_data="false">migration_to_region/split_and_process_response</fhc:response_endpoint>
                    <fhc:split_namespace>wd urn:com.workday/bsvc</fhc:split_namespace>
                    <fhc:split_tag>wd:Statistic_Definition</fhc:split_tag>
                </fhc:get_ws_attributes>
                <fhc:put_ws_attributes>
                    <fhc:application>Financial_Management</fhc:application>
                    <fhc:request_filename>lib/put_request/migration_to_region/createputstatisticdefinition.xsl</fhc:request_filename>
                    <fhc:request_endpoint>standard_import_process/put_workday_web_serivce_call</fhc:request_endpoint>
                    <fhc:update_attributes>
                        <fhc:update_data_attribute>Update Statistics</fhc:update_data_attribute>
                        <fhc:multi_instance_updates>
                            <fhc:update_attribute></fhc:update_attribute>
                            <fhc:update_attribute></fhc:update_attribute>
                            <fhc:update_attribute></fhc:update_attribute>
                        </fhc:multi_instance_updates>
                        <fhc:single_instance_updates>
                            <fhc:update_attribute>Existing Worktag Type</fhc:update_attribute>
                            <fhc:update_attribute>New Worktag Type</fhc:update_attribute>
                        </fhc:single_instance_updates>
                    </fhc:update_attributes>
                </fhc:put_ws_attributes>
            </fhc:web_service_information>
        </fhc:process>
        <fhc:process fhc:process_name="Statistic Details">
            <fhc:web_service_information>
                <fhc:get_ws_attributes>
                    <fhc:application>Financial_Management</fhc:application>
                    <fhc:request_filename>lib/get_request/migration_to_region/creategetstatistics.xsl</fhc:request_filename>
                    <fhc:report_alias></fhc:report_alias>
                    <fhc:request_type>default</fhc:request_type>
                    <fhc:filter_attributes>
                        <fhc:multi_instance_filters>
                            <fhc:filter_attribute>Statistic Definitions</fhc:filter_attribute>
                            <fhc:filter_attribute></fhc:filter_attribute>
                            <fhc:filter_attribute></fhc:filter_attribute>
                        </fhc:multi_instance_filters>
                        <fhc:single_instance_filters>
                            <fhc:filter_attribute></fhc:filter_attribute>
                            <fhc:filter_attribute></fhc:filter_attribute>
                            <fhc:filter_attribute></fhc:filter_attribute>
                        </fhc:single_instance_filters>
                    </fhc:filter_attributes>
                    <fhc:request_endpoint>standard_import_process/get_workday_paged_web_service_call</fhc:request_endpoint>
                    <fhc:response_endpoint fhc:group_rsp_data="true">migration_to_region/split_and_process_response</fhc:response_endpoint>
                    <fhc:response_consolidate_filename>lib/get_request/consolidate_webservicerspdata.xsl</fhc:response_consolidate_filename>
                    <fhc:split_namespace>wd urn:com.workday/bsvc</fhc:split_namespace>
                    <fhc:split_tag>wd:Statistic</fhc:split_tag>
                </fhc:get_ws_attributes>
                <fhc:put_ws_attributes>
                    <fhc:application>Financial_Management</fhc:application>
                    <fhc:request_filename>lib/put_request/migration_to_region/createputstatistic.xsl</fhc:request_filename>
                    <fhc:request_endpoint>standard_import_process/put_workday_web_serivce_call</fhc:request_endpoint>
                    <fhc:update_attributes>
                        <fhc:update_data_attribute>Update Statistics</fhc:update_data_attribute>
                        <fhc:multi_instance_updates>
                            <fhc:update_attribute></fhc:update_attribute>
                            <fhc:update_attribute></fhc:update_attribute>
                            <fhc:update_attribute></fhc:update_attribute>
                        </fhc:multi_instance_updates>
                        <fhc:single_instance_updates>
                            <fhc:update_attribute>New Worktag Type</fhc:update_attribute>
                            <fhc:update_attribute>Default Cost Center</fhc:update_attribute>
                        </fhc:single_instance_updates>
                    </fhc:update_attributes>
                </fhc:put_ws_attributes>
            </fhc:web_service_information>
        </fhc:process>
        <fhc:process fhc:process_name="Job Requisitions">
            <fhc:web_service_information>
                <fhc:get_ws_attributes>
                    <fhc:application>Recruiting</fhc:application>
                    <fhc:request_filename>lib/get_request/migration_to_region/creategetjobrequisitionrequest.xsl</fhc:request_filename>
                    <fhc:report_alias></fhc:report_alias>
                    <fhc:request_type>default</fhc:request_type>
                    <fhc:filter_attributes>
                        <fhc:multi_instance_filters>
                            <fhc:filter_attribute>Requisition Status</fhc:filter_attribute>
                            <fhc:filter_attribute></fhc:filter_attribute>
                            <fhc:filter_attribute></fhc:filter_attribute>
                        </fhc:multi_instance_filters>
                        <fhc:single_instance_filters>
                            <fhc:filter_attribute></fhc:filter_attribute>
                            <fhc:filter_attribute></fhc:filter_attribute>
                            <fhc:filter_attribute></fhc:filter_attribute>
                        </fhc:single_instance_filters>
                    </fhc:filter_attributes>
                    <fhc:request_endpoint>standard_import_process/get_workday_paged_web_service_call</fhc:request_endpoint>
                    <fhc:response_endpoint fhc:group_rsp_data="true">migration_to_region/split_and_process_response</fhc:response_endpoint>
                    <fhc:response_consolidate_filename>lib/get_request/consolidate_jobrequisitiondata.xsl</fhc:response_consolidate_filename>
                    <fhc:split_namespace>wd urn:com.workday/bsvc</fhc:split_namespace>
                    <fhc:split_tag>wd:Job_Requisition</fhc:split_tag>
                </fhc:get_ws_attributes>
                <fhc:put_ws_attributes>
                    <fhc:application>Recruiting</fhc:application>
                    <fhc:request_filename>lib/put_request/migration_to_region/createputjobrequisitiondata.xsl</fhc:request_filename>
                    <fhc:request_endpoint>standard_import_process/put_workday_web_serivce_call</fhc:request_endpoint>
                    <fhc:update_attributes>
                        <fhc:update_data_attribute>Update Job Requisitions</fhc:update_data_attribute>
                        <fhc:multi_instance_updates>
                            <fhc:update_attribute></fhc:update_attribute>
                            <fhc:update_attribute></fhc:update_attribute>
                            <fhc:update_attribute></fhc:update_attribute>
                        </fhc:multi_instance_updates>
                        <fhc:single_instance_updates>
                            <fhc:update_attribute>Job Requisition Change Reason</fhc:update_attribute>
                            <fhc:update_attribute></fhc:update_attribute>
                        </fhc:single_instance_updates>
                    </fhc:update_attributes>
                </fhc:put_ws_attributes>
            </fhc:web_service_information>
        </fhc:process>
        <fhc:process fhc:process_name="Asset Data">
            <fhc:web_service_information>
                <fhc:get_ws_attributes>
                    <fhc:application>Resource_Management</fhc:application>
                    <fhc:request_filename>lib/get_request/migration_to_region/creategetassets.xsl</fhc:request_filename>
                    <fhc:report_alias></fhc:report_alias>
                    <fhc:request_type>default</fhc:request_type>
                    <fhc:filter_attributes>
                        <fhc:multi_instance_filters>
                            <fhc:filter_attribute>Asset Status</fhc:filter_attribute>
                            <fhc:filter_attribute></fhc:filter_attribute>
                            <fhc:filter_attribute></fhc:filter_attribute>
                        </fhc:multi_instance_filters>
                        <fhc:single_instance_filters>
                            <fhc:filter_attribute></fhc:filter_attribute>
                            <fhc:filter_attribute></fhc:filter_attribute>
                            <fhc:filter_attribute></fhc:filter_attribute>
                        </fhc:single_instance_filters>
                    </fhc:filter_attributes>
                    <fhc:request_endpoint>standard_import_process/get_workday_paged_web_service_call</fhc:request_endpoint>
                    <fhc:response_endpoint fhc:group_rsp_data="true">migration_to_region/split_and_process_response</fhc:response_endpoint>
                    <fhc:response_consolidate_filename>lib/get_request/consolidate_webservicerspdata.xsl</fhc:response_consolidate_filename>
                    <fhc:split_namespace>wd urn:com.workday/bsvc</fhc:split_namespace>
                    <fhc:split_tag>wd:Asset</fhc:split_tag>
                </fhc:get_ws_attributes>
                <fhc:put_ws_attributes>
                    <fhc:application>Resource_Management</fhc:application>
                    <fhc:request_filename>lib/put_request/migration_to_region/createtransferasset.xsl</fhc:request_filename>
                    <fhc:request_endpoint>standard_import_process/put_workday_web_serivce_call</fhc:request_endpoint>
                    <fhc:update_attributes>
                        <fhc:update_data_attribute>Transfer Assets</fhc:update_data_attribute>
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
        <fhc:process fhc:process_name="Missing BU and Region Data">
            <fhc:web_service_information>
                <fhc:get_ws_attributes>
                    <fhc:application>RAAS</fhc:application>
                    <fhc:request_filename></fhc:request_filename>
                    <fhc:report_alias>Journal_Migration_Data_Missing_BU</fhc:report_alias>
                    <fhc:request_type>default</fhc:request_type>
                    <fhc:filter_attributes>
                        <fhc:report_filters>
                            <fhc:report_filter fhc:filtername="start_date">Start_Date=</fhc:report_filter>
                            <fhc:report_filter fhc:filtername="end_date">End_Date=</fhc:report_filter>
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
                    <fhc:response_endpoint fhc:group_rsp_data="true">migration_to_region/store_as_lkp</fhc:response_endpoint>
                    <fhc:response_consolidate_filename>lib/get_request/data_audits/consolidate_journaldata_comparison.xsl</fhc:response_consolidate_filename>
                    <fhc:split_namespace>wd urn:com.workday/bsvc</fhc:split_namespace>
                    <fhc:split_tag>wd:Report_Data</fhc:split_tag>
                </fhc:get_ws_attributes>
                <fhc:put_ws_attributes>
                    <fhc:application>Financial_Management</fhc:application>
                    <fhc:request_filename>lib/put_request/move_budget/importbudgettransform.xsl</fhc:request_filename>
                    <fhc:request_endpoint>standard_import_process/put_workday_web_serivce_call</fhc:request_endpoint>
                    <fhc:update_attributes>
                        <fhc:update_data_attribute>Transfer Assets</fhc:update_data_attribute>
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
        <fhc:process fhc:process_name="Missing BU and Region Payroll Data">
            <fhc:web_service_information>
                <fhc:get_ws_attributes>
                    <fhc:application>RAAS</fhc:application>
                    <fhc:request_filename></fhc:request_filename>
                    <fhc:report_alias>Journal_Migration_Data_Missing_BU</fhc:report_alias>
                    <fhc:request_type>default</fhc:request_type>
                    <fhc:filter_attributes>
                        <fhc:report_filters>
                            <fhc:report_filter fhc:filtername="start_date">Start_Date=</fhc:report_filter>
                            <fhc:report_filter fhc:filtername="end_date">End_Date=</fhc:report_filter>
                            <fhc:report_filter fhc:filtername="additional_options">Additional_Options!WID=</fhc:report_filter>
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
                    <fhc:response_consolidate_filename>lib/get_request/data_audits/consolidate_journaldata_details.xsl</fhc:response_consolidate_filename>
                    <fhc:split_namespace>wd urn:com.workday/bsvc</fhc:split_namespace>
                    <fhc:split_tag>wd:Import_Accounting_Journal_Request</fhc:split_tag>
                </fhc:get_ws_attributes>
                <fhc:put_ws_attributes>
                    <fhc:application>Financial_Management</fhc:application>
                    <fhc:request_filename>lib/put_request/migration_to_region/createsubmitjournalentry.xsl</fhc:request_filename>
                    <fhc:request_endpoint>standard_import_process/put_workday_web_serivce_call</fhc:request_endpoint>
                    <fhc:update_attributes>
                        <fhc:update_data_attribute>Create Journals</fhc:update_data_attribute>
                        <fhc:multi_instance_updates>
                            <fhc:update_attribute></fhc:update_attribute>
                            <fhc:update_attribute></fhc:update_attribute>
                            <fhc:update_attribute></fhc:update_attribute>
                        </fhc:multi_instance_updates>
                        <fhc:single_instance_updates>
                            <fhc:update_attribute>Journal Source for Migration</fhc:update_attribute>
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
