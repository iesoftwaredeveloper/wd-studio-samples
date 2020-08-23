<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:bsvc="urn:com.workday/bsvc"
    xmlns:wd="urn:com.workday/bsvc"
    xmlns:crd="urn:com.workday.report/Check_Applicant_Hire_Status"
    xmlns:intsys="java:com.workday.esb.intsys.xpath.ParsedIntegrationSystemFunctions"
    exclude-result-prefixes="#all" version="2.0">
    <xsl:output method="xml" version="1.0" indent="yes" omit-xml-declaration="yes"/>
    
    <!-- Filter Parameters -->
    <xsl:param name="multi.instance.filter.1.wids"/>
    <xsl:param name="multi.instance.filter.2.wids"/>
    <xsl:param name="multi.instance.filter.3.wids"/>
    <xsl:param name="single.instance.filter.1.wids"/>
    <xsl:param name="single.instance.filter.2.wids"/>
    <xsl:param name="single.instance.filter.3.wids"/>
    <xsl:param name="worker.id"/>
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
    
        <xsl:variable name="applicant.event.check" select="document('mctx:vars/applicant.check.xml')"/>

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
                    <bsvc:Request_References>
                        <xsl:attribute name="bsvc:Skip_Non_Existing_Instances" select="1"/>
                        <xsl:attribute name="bsvc:Ignore_Invalid_References" select="1"/>
                        <bsvc:Worker_Reference>
                            <bsvc:ID bsvc:type="Employee_ID">
                                <xsl:value-of select="normalize-space($worker.id)"/>
                            </bsvc:ID>
                        </bsvc:Worker_Reference>
                        <bsvc:Worker_Reference>
                            <bsvc:ID bsvc:type="Contingent_Worker_ID">
                                <xsl:value-of select="normalize-space($worker.id)"/>
                            </bsvc:ID>
                        </bsvc:Worker_Reference>
                        <xsl:if test="exists($applicant.event.check//crd:About_Worker)">
                            <bsvc:Worker_Reference>
                                <bsvc:ID>
                                    <xsl:attribute name="bsvc:type" select="$applicant.event.check//crd:About_Worker/crd:ID[@crd:type != 'WID']/@crd:type"/>
                                    <xsl:value-of select="$applicant.event.check//crd:About_Worker/crd:ID[@crd:type != 'WID']"/>
                                </bsvc:ID>
                            </bsvc:Worker_Reference>
                        </xsl:if>
                    </bsvc:Request_References>
                    <bsvc:Request_Criteria>
                        <bsvc:Transaction_Log_Criteria_Data>
                            <bsvc:Transaction_Date_Range_Data>
                                <bsvc:Updated_From>
                                    <xsl:value-of select="$web.service.start.date"/>
                                </bsvc:Updated_From>
                                <bsvc:Updated_Through>
                                    <xsl:value-of select="$web.service.end.date"/>
                                </bsvc:Updated_Through>
                            </bsvc:Transaction_Date_Range_Data>
                            <xsl:if test="$multi.instance.filter.2.wids != 'no'">
                                <bsvc:Transaction_Type_References>
                                    <xsl:for-each select="tokenize($multi.instance.filter.2.wids,';')">
                                        <bsvc:Transaction_Type_Reference>
                                            <bsvc:ID bsvc:type="WID">
                                                <xsl:value-of select="normalize-space(.)"/>
                                            </bsvc:ID>
                                        </bsvc:Transaction_Type_Reference>
                                    </xsl:for-each>
                                </bsvc:Transaction_Type_References>
                            </xsl:if>
                        </bsvc:Transaction_Log_Criteria_Data>
                        <bsvc:Exclude_Inactive_Workers>
                            <xsl:value-of select="false()"/>
                        </bsvc:Exclude_Inactive_Workers>
                        <bsvc:Exclude_Employees>
                                <xsl:value-of select="false()"/>
                        </bsvc:Exclude_Employees>
                        <bsvc:Exclude_Contingent_Workers>
                                <xsl:value-of select="false()"/>
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
                            <xsl:call-template name="response_group_empty"/>
                    </bsvc:Response_Group>
                </bsvc:Get_Workers_Request>
            </soapenv:Body>
        </soapenv:Envelope>
    </xsl:template>

    <xsl:template name="response_group_empty">
        <bsvc:Include_Reference>
            <xsl:value-of select="$web.service.include.reference"/>
        </bsvc:Include_Reference>
        <bsvc:Include_Personal_Information>
            <xsl:value-of select="false()"/>
        </bsvc:Include_Personal_Information>
        <bsvc:Include_Employment_Information>
            <xsl:value-of select="true()"/>
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
            <xsl:value-of select="true()"/>
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
