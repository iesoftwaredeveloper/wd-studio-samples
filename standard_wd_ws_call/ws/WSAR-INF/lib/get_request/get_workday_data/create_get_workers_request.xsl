<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:bsvc="urn:com.workday/bsvc"
    xmlns:wd="urn:com.workday/bsvc"
    xmlns:intsys="java:com.workday.esb.intsys.xpath.ParsedIntegrationSystemFunctions"
    exclude-result-prefixes="xs intsys wd" version="2.0">
    <xsl:output method="xml" version="1.0" indent="yes" omit-xml-declaration="yes"/>
    
    <!-- Filter Parameters -->
    <xsl:param name="multi.instance.filter.1.wids"/>
    <xsl:param name="multi.instance.filter.2.wids"/>
    <xsl:param name="multi.instance.filter.3.wids"/>
    <xsl:param name="single.instance.filter.1.wids"/>
    <xsl:param name="single.instance.filter.2.wids"/>
    <xsl:param name="single.instance.filter.3.wids"/>
    <xsl:param name="worker.wid"/>
    <!-- Standard Web Service Parameters -->
    <xsl:param name="web.service.lookup.request.type"/>
    <xsl:param name="web.service.get.request.type"/>
    <xsl:param name="web.service.version"/>
    <xsl:param name="web.service.count"/>
    <xsl:param name="web.service.include.descriptors"/>
    <xsl:param name="web.service.include.reference"/>
    <xsl:param name="web.service.start.date"/>
    <xsl:param name="web.service.end.date"/>
    <xsl:param name="web.service.effective.date"/>
    <xsl:param name="is.system.wid"/>
    <xsl:param name="transaction.log.service.name"/>
    <xsl:param name="transaction.log.date.range.type"/>
    <!-- Get Workers Standard Parameters -->
    <xsl:param name="exclude.companies"/>
    <xsl:param name="exclude.company.hierarchies"/>
    <xsl:param name="exclude.contingent.workers"/>
    <xsl:param name="exclude.cost.center.hierarchies"/>
    <xsl:param name="exclude.cost.centers"/>
    <xsl:param name="exclude.custom.organizations"/>
    <xsl:param name="exclude.employees"/>
    <xsl:param name="exclude.inactive.workers"/>
    <xsl:param name="exclude.location.hierarchies"/>
    <xsl:param name="exclude.matrix.organizations"/>
    <xsl:param name="exclude.organization.support.role.data"/>
    <xsl:param name="exclude.pay.groups"/>
    <xsl:param name="exclude.region.hierarchies"/>
    <xsl:param name="exclude.regions"/>
    <xsl:param name="exclude.supervisory.organizations"/>
    <xsl:param name="exclude.teams"/>
    <xsl:param name="include.account.provisioning"/>
    <xsl:param name="include.benefit.eligibility"/>
    <xsl:param name="include.benefit.enrollments"/>
    <xsl:param name="include.career"/>
    <xsl:param name="include.compensation"/>
    <xsl:param name="include.employee.contract.data"/>
    <xsl:param name="include.employee.review"/>
    <xsl:param name="include.employment.information"/>
    <xsl:param name="include.feedback.received"/>
    <xsl:param name="include.goals"/>
    <xsl:param name="include.management.chain.data"/>
    <xsl:param name="include.organizations"/>
    <xsl:param name="include.personal.information"/>
    <xsl:param name="include.photo"/>
    <xsl:param name="include.qualifications"/>
    <xsl:param name="include.related.persons"/>
    <xsl:param name="include.roles"/>
    <xsl:param name="include.succession.profile"/>
    <xsl:param name="include.talent.assessment"/>
    <xsl:param name="include.transaction.log.data"/>
    <xsl:param name="include.user.account"/>
    <xsl:param name="include.worker.documents"/>

    <xsl:template match="/">
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:bsvc="urn:com.workday/bsvc">
            <soapenv:Header>
                <bsvc:Workday_Common_Header>
                    <bsvc:Include_Reference_Descriptors_In_Response>
                        <xsl:value-of select="$web.service.include.descriptors"/>
                    </bsvc:Include_Reference_Descriptors_In_Response>
                </bsvc:Workday_Common_Header>
            </soapenv:Header>
            <soapenv:Body>
                <bsvc:Get_Workers_Request>
                    <xsl:attribute name="bsvc:version" select="$web.service.version"/>
                    <xsl:choose>
                        <xsl:when test="$web.service.lookup.request.type = 'manager_list_username_only'">
                            <xsl:variable name="ee_list" select="distinct-values(//wd:Manager_as_of_last_detected_manager_change_Reference)"/>
                            <xsl:for-each-group select="//wd:Manager_as_of_last_detected_manager_change_Reference" group-by="wd:ID[@wd:type='Employee_ID']">
                                <bsvc:Request_References>
                                    <xsl:attribute name="bsvc:Skip_Non_Existing_Instances" select="1"/>
                                    <bsvc:Worker_Reference>
                                        <bsvc:ID bsvc:type="Employee_ID">
                                            <xsl:value-of select="normalize-space(current-grouping-key())"/>
                                        </bsvc:ID>
                                    </bsvc:Worker_Reference>
                                </bsvc:Request_References>
                            </xsl:for-each-group>
                        </xsl:when>
                        <xsl:when test="$web.service.get.request.type = 'employee_id_list'">
                            <bsvc:Request_References>
                                <xsl:attribute name="bsvc:Skip_Non_Existing_Instances" select="1"/>
                                <xsl:if test="$multi.instance.filter.1.wids != 'no'">
                                    <xsl:for-each select="tokenize($multi.instance.filter.1.wids,',')">
                                        <bsvc:Worker_Reference>
                                            <bsvc:ID bsvc:type="WID">
                                                <xsl:value-of select="normalize-space(.)"/>
                                            </bsvc:ID>
                                        </bsvc:Worker_Reference>
                                    </xsl:for-each>
                                </xsl:if>
                            </bsvc:Request_References>
                        </xsl:when>
                        <xsl:when test="$web.service.get.request.type = 'single_worker'">
                            <bsvc:Request_References>
                                <xsl:attribute name="bsvc:Skip_Non_Existing_Instances" select="1"/>
                                <bsvc:Worker_Reference>
                                    <bsvc:ID bsvc:type="WID">
                                        <xsl:value-of select="normalize-space($worker.wid)"/>
                                    </bsvc:ID>
                                </bsvc:Worker_Reference>
                            </bsvc:Request_References>
                        </xsl:when>
                    </xsl:choose>
                    <bsvc:Request_Criteria>
                        <xsl:if test="$web.service.get.request.type = 'transaction_log'
                            or $web.service.get.request.type = 'transaction_log_termination'
                            or $web.service.get.request.type = 'transaction_log_retro'
                            or $web.service.get.request.type = 'single_worker'">
                            <bsvc:Transaction_Log_Criteria_Data>
                                <bsvc:Transaction_Date_Range_Data>
                                    <xsl:choose>
                                        <xsl:when test="$web.service.get.request.type = 'transaction_log_retro'">
                                            <bsvc:Effective_From>
                                                <xsl:value-of select="xs:dateTime($web.service.effective.date) - xs:dayTimeDuration('P30D')"/>
                                            </bsvc:Effective_From>
                                            <bsvc:Effective_Through>
                                                <xsl:value-of select="$web.service.start.date"/>
                                            </bsvc:Effective_Through>
                                            <bsvc:Updated_From>
                                                <xsl:value-of select="$web.service.start.date"/>
                                            </bsvc:Updated_From>
                                            <bsvc:Updated_Through>
                                                <xsl:value-of select="$web.service.end.date"/>
                                            </bsvc:Updated_Through>
                                        </xsl:when>
                                        <xsl:when test="$transaction.log.date.range.type = 'Effective Dates'">
                                            <bsvc:Effective_From>
                                                <xsl:value-of select="$web.service.start.date"/>
                                            </bsvc:Effective_From>
                                            <bsvc:Effective_Through>
                                                <xsl:value-of select="$web.service.end.date"/>
                                            </bsvc:Effective_Through>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <bsvc:Updated_From>
                                                <xsl:value-of select="$web.service.start.date"/>
                                            </bsvc:Updated_From>
                                            <bsvc:Updated_Through>
                                                <xsl:value-of select="$web.service.end.date"/>
                                            </bsvc:Updated_Through>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </bsvc:Transaction_Date_Range_Data>
                                <xsl:choose>
                                    <xsl:when test="$multi.instance.filter.2.wids != 'no'">
                                        <bsvc:Transaction_Type_References>
                                            <xsl:for-each select="tokenize($multi.instance.filter.2.wids,',')">
                                                <bsvc:Transaction_Type_Reference>
                                                    <bsvc:ID bsvc:type="WID">
                                                        <xsl:value-of select="normalize-space(.)"/>
                                                    </bsvc:ID>
                                                </bsvc:Transaction_Type_Reference>
                                            </xsl:for-each>
                                        </bsvc:Transaction_Type_References>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <bsvc:Subscriber_Reference>
                                            <bsvc:ID bsvc:type="WID">
                                                <xsl:value-of select="$is.system.wid"/>
                                            </bsvc:ID>
                                        </bsvc:Subscriber_Reference>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </bsvc:Transaction_Log_Criteria_Data>
                        </xsl:if>
                        <xsl:if test="$web.service.get.request.type = 'organization'
                            or $web.service.get.request.type = 'transaction_log'
                            or $web.service.get.request.type = 'active_only'">
                            <xsl:if test="$multi.instance.filter.1.wids != 'no'">
                                <xsl:for-each select="tokenize($multi.instance.filter.1.wids,',')">
                                    <bsvc:Organization_Reference>
                                        <bsvc:ID bsvc:type="WID">
                                            <xsl:value-of select="normalize-space(.)"/>
                                        </bsvc:ID>
                                    </bsvc:Organization_Reference>
                                </xsl:for-each>
                            </xsl:if>
                        </xsl:if>
                        <bsvc:Field_And_Parameter_Criteria_Data>
                            <bsvc:Provider_Reference>
                                <bsvc:ID bsvc:type="WID">
                                    <xsl:value-of select="$is.system.wid"/>
                                </bsvc:ID>
                            </bsvc:Provider_Reference>
                        </bsvc:Field_And_Parameter_Criteria_Data>
                        <bsvc:Exclude_Inactive_Workers>
                            <xsl:choose>
                                <xsl:when test="$web.service.get.request.type = 'transaction_log'">
                                    <xsl:value-of select="false()"/>
                                </xsl:when>
                                <xsl:when test="$web.service.get.request.type = 'active_only'">
                                    <xsl:value-of select="true()"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$exclude.inactive.workers"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </bsvc:Exclude_Inactive_Workers>
                        <bsvc:Exclude_Employees>
                                <xsl:value-of select="$exclude.employees"/>
                        </bsvc:Exclude_Employees>
                        <bsvc:Exclude_Contingent_Workers>
                                <xsl:value-of select="$exclude.contingent.workers"/>
                        </bsvc:Exclude_Contingent_Workers>
                    </bsvc:Request_Criteria>
                    <bsvc:Response_Filter>
                        <bsvc:As_Of_Effective_Date>
                            <xsl:value-of select="$web.service.effective.date"/>
                        </bsvc:As_Of_Effective_Date>
                        <bsvc:Count>
                            <xsl:value-of select="$web.service.count"/>
                        </bsvc:Count>
                    </bsvc:Response_Filter>
                    <bsvc:Response_Group>
                        <xsl:choose>
                            <xsl:when test="contains($web.service.lookup.request.type, 'username_only')">
                                <xsl:call-template name="response_group_username_only"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="response_group"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </bsvc:Response_Group>
                </bsvc:Get_Workers_Request>
            </soapenv:Body>
        </soapenv:Envelope>
    </xsl:template>
    
    <xsl:template name="response_group">
        <bsvc:Include_Reference>
            <xsl:value-of select="$web.service.include.reference"/>
        </bsvc:Include_Reference>
        <bsvc:Include_Personal_Information>
            <xsl:value-of select="$include.personal.information"/>
        </bsvc:Include_Personal_Information>
        <bsvc:Include_Employment_Information>
            <xsl:value-of select="$include.employment.information"/>
        </bsvc:Include_Employment_Information>
        <bsvc:Include_Compensation>
            <xsl:value-of select="$include.compensation"/>
        </bsvc:Include_Compensation>
        <bsvc:Include_Organizations>
            <xsl:value-of select="$include.organizations"/>
        </bsvc:Include_Organizations>
        <bsvc:Exclude_Organization_Support_Role_Data>
            <xsl:value-of select="$exclude.organization.support.role.data"/>
        </bsvc:Exclude_Organization_Support_Role_Data>
        <bsvc:Exclude_Location_Hierarchies>
            <xsl:value-of select="$exclude.location.hierarchies"/>
        </bsvc:Exclude_Location_Hierarchies>
        <bsvc:Exclude_Cost_Centers>
            <xsl:value-of select="$exclude.cost.centers"/>
        </bsvc:Exclude_Cost_Centers>
        <bsvc:Exclude_Cost_Center_Hierarchies>
            <xsl:value-of select="$exclude.cost.center.hierarchies"/>
        </bsvc:Exclude_Cost_Center_Hierarchies>
        <bsvc:Exclude_Companies>
            <xsl:value-of select="$exclude.companies"/>
        </bsvc:Exclude_Companies>
        <bsvc:Exclude_Company_Hierarchies>
            <xsl:value-of select="$exclude.company.hierarchies"/>
        </bsvc:Exclude_Company_Hierarchies>
        <bsvc:Exclude_Matrix_Organizations>
            <xsl:value-of select="$exclude.matrix.organizations"/>
        </bsvc:Exclude_Matrix_Organizations>
        <bsvc:Exclude_Pay_Groups>
            <xsl:value-of select="$exclude.pay.groups"/>
        </bsvc:Exclude_Pay_Groups>
        <bsvc:Exclude_Regions>
            <xsl:value-of select="$exclude.regions"/>
        </bsvc:Exclude_Regions>
        <bsvc:Exclude_Region_Hierarchies>
            <xsl:value-of select="$exclude.region.hierarchies"/>
        </bsvc:Exclude_Region_Hierarchies>
        <bsvc:Exclude_Supervisory_Organizations>
            <xsl:value-of select="$exclude.supervisory.organizations"/>
        </bsvc:Exclude_Supervisory_Organizations>
        <bsvc:Exclude_Teams>
            <xsl:value-of select="$exclude.teams"/>
        </bsvc:Exclude_Teams>
        <bsvc:Exclude_Custom_Organizations>
            <xsl:value-of select="$exclude.custom.organizations"/>
        </bsvc:Exclude_Custom_Organizations>
        <bsvc:Include_Roles>
            <xsl:value-of select="$include.roles"/>
        </bsvc:Include_Roles>
        <bsvc:Include_Management_Chain_Data>
            <xsl:value-of select="$include.management.chain.data"/>
        </bsvc:Include_Management_Chain_Data>
        <bsvc:Include_Benefit_Enrollments>
            <xsl:value-of select="$include.benefit.enrollments"/>
        </bsvc:Include_Benefit_Enrollments>
        <bsvc:Include_Benefit_Eligibility>
            <xsl:value-of select="$include.benefit.eligibility"/>
        </bsvc:Include_Benefit_Eligibility>
        <bsvc:Include_Related_Persons>
            <xsl:value-of select="$include.related.persons"/>
        </bsvc:Include_Related_Persons>
        <bsvc:Include_Qualifications>
            <xsl:value-of select="$include.qualifications"/>
        </bsvc:Include_Qualifications>
        <bsvc:Include_Employee_Review>
            <xsl:value-of select="$include.employee.review"/>
        </bsvc:Include_Employee_Review>
        <bsvc:Include_Goals>
            <xsl:value-of select="$include.goals"/>
        </bsvc:Include_Goals>
        <bsvc:Include_Photo>
            <xsl:value-of select="$include.photo"/>
        </bsvc:Include_Photo>
        <bsvc:Include_Worker_Documents>
            <xsl:value-of select="$include.worker.documents"/>
        </bsvc:Include_Worker_Documents>
        <bsvc:Include_Transaction_Log_Data>
            <xsl:value-of select="$include.transaction.log.data"/>
        </bsvc:Include_Transaction_Log_Data>
        <bsvc:Include_Succession_Profile>
            <xsl:value-of select="$include.succession.profile"/>
        </bsvc:Include_Succession_Profile>
        <bsvc:Include_Talent_Assessment>
            <xsl:value-of select="$include.talent.assessment"/>
        </bsvc:Include_Talent_Assessment>
        <bsvc:Include_Employee_Contract_Data>
            <xsl:value-of select="$include.employee.contract.data"/>
        </bsvc:Include_Employee_Contract_Data>
        <bsvc:Include_Feedback_Received>
            <xsl:value-of select="$include.feedback.received"/>
        </bsvc:Include_Feedback_Received>
        <bsvc:Include_User_Account>
            <xsl:value-of select="$include.user.account"/>
        </bsvc:Include_User_Account>
        <bsvc:Include_Career>
            <xsl:value-of select="$include.career"/>
        </bsvc:Include_Career>
        <bsvc:Include_Account_Provisioning>
            <xsl:value-of select="$include.account.provisioning"/>
        </bsvc:Include_Account_Provisioning>
    </xsl:template>
    
    <xsl:template name="response_group_username_only">
        <bsvc:Include_Reference>
            <xsl:value-of select="$web.service.include.reference"/>
        </bsvc:Include_Reference>
        <bsvc:Include_Personal_Information>
            <xsl:value-of select="false()"/>
        </bsvc:Include_Personal_Information>
        <bsvc:Include_Employment_Information>
            <xsl:value-of select="false()"/>
        </bsvc:Include_Employment_Information>
        <bsvc:Include_Compensation>
            <xsl:value-of select="false()"/>
        </bsvc:Include_Compensation>
        <bsvc:Include_Organizations>
            <xsl:value-of select="false()"/>
        </bsvc:Include_Organizations>
        <bsvc:Exclude_Organization_Support_Role_Data>
            <xsl:value-of select="true()"/>
        </bsvc:Exclude_Organization_Support_Role_Data>
        <bsvc:Exclude_Location_Hierarchies>
            <xsl:value-of select="true()"/>
        </bsvc:Exclude_Location_Hierarchies>
        <bsvc:Exclude_Cost_Centers>
            <xsl:value-of select="true()"/>
        </bsvc:Exclude_Cost_Centers>
        <bsvc:Exclude_Cost_Center_Hierarchies>
            <xsl:value-of select="true()"/>
        </bsvc:Exclude_Cost_Center_Hierarchies>
        <bsvc:Exclude_Companies>
            <xsl:value-of select="true()"/>
        </bsvc:Exclude_Companies>
        <bsvc:Exclude_Company_Hierarchies>
            <xsl:value-of select="true()"/>
        </bsvc:Exclude_Company_Hierarchies>
        <bsvc:Exclude_Matrix_Organizations>
            <xsl:value-of select="true()"/>
        </bsvc:Exclude_Matrix_Organizations>
        <bsvc:Exclude_Pay_Groups>
            <xsl:value-of select="true()"/>
        </bsvc:Exclude_Pay_Groups>
        <bsvc:Exclude_Regions>
            <xsl:value-of select="true()"/>
        </bsvc:Exclude_Regions>
        <bsvc:Exclude_Region_Hierarchies>
            <xsl:value-of select="true()"/>
        </bsvc:Exclude_Region_Hierarchies>
        <bsvc:Exclude_Supervisory_Organizations>
            <xsl:value-of select="true()"/>
        </bsvc:Exclude_Supervisory_Organizations>
        <bsvc:Exclude_Teams>
            <xsl:value-of select="true()"/>
        </bsvc:Exclude_Teams>
        <bsvc:Exclude_Custom_Organizations>
            <xsl:value-of select="true()"/>
        </bsvc:Exclude_Custom_Organizations>
        <bsvc:Include_Roles>
            <xsl:value-of select="false()"/>
        </bsvc:Include_Roles>
        <bsvc:Include_Management_Chain_Data>
            <xsl:value-of select="false()"/>
        </bsvc:Include_Management_Chain_Data>
        <bsvc:Include_Benefit_Enrollments>
            <xsl:value-of select="false()"/>
        </bsvc:Include_Benefit_Enrollments>
        <bsvc:Include_Benefit_Eligibility>
            <xsl:value-of select="false()"/>
        </bsvc:Include_Benefit_Eligibility>
        <bsvc:Include_Related_Persons>
            <xsl:value-of select="false()"/>
        </bsvc:Include_Related_Persons>
        <bsvc:Include_Qualifications>
            <xsl:value-of select="false()"/>
        </bsvc:Include_Qualifications>
        <bsvc:Include_Employee_Review>
            <xsl:value-of select="false()"/>
        </bsvc:Include_Employee_Review>
        <bsvc:Include_Goals>
            <xsl:value-of select="false()"/>
        </bsvc:Include_Goals>
        <bsvc:Include_Photo>
            <xsl:value-of select="false()"/>
        </bsvc:Include_Photo>
        <bsvc:Include_Worker_Documents>
            <xsl:value-of select="false()"/>
        </bsvc:Include_Worker_Documents>
        <bsvc:Include_Transaction_Log_Data>
            <xsl:value-of select="false()"/>
        </bsvc:Include_Transaction_Log_Data>
        <bsvc:Include_Succession_Profile>
            <xsl:value-of select="false()"/>
        </bsvc:Include_Succession_Profile>
        <bsvc:Include_Talent_Assessment>
            <xsl:value-of select="false()"/>
        </bsvc:Include_Talent_Assessment>
        <bsvc:Include_Employee_Contract_Data>
            <xsl:value-of select="false()"/>
        </bsvc:Include_Employee_Contract_Data>
        <bsvc:Include_Feedback_Received>
            <xsl:value-of select="false()"/>
        </bsvc:Include_Feedback_Received>
        <bsvc:Include_User_Account>
            <xsl:value-of select="true()"/>
        </bsvc:Include_User_Account>
        <bsvc:Include_Career>
            <xsl:value-of select="false()"/>
        </bsvc:Include_Career>
        <bsvc:Include_Account_Provisioning>
            <xsl:value-of select="false()"/>
        </bsvc:Include_Account_Provisioning>
    </xsl:template>

</xsl:stylesheet>
