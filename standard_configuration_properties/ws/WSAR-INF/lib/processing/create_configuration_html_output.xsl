<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fhc="https://github.com/firehawk-consulting/firehawk" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:cc="http://www.capeclear.com/assembly/10" xmlns:tl="https://github.com/firehawk-consulting/firehawk/schemas/transaction_log.xsd" exclude-result-prefixes="xsl fhc xs tl cc">

    <xsl:output method="html" indent="yes"/>
    <!--xsl:output method="text"/-->
    <xsl:variable name="linefeed">
        <xsl:text>&#xA;</xsl:text>
    </xsl:variable>
    <xsl:variable name="carriagereturn">
        <xsl:text>&#13;</xsl:text>
    </xsl:variable>
    <xsl:variable name="space" select="' '"/>
    <xsl:variable name="delimiter">
        <xsl:text>&#x09;</xsl:text>
    </xsl:variable>

    <!-- GET Properties -->
    <xsl:param name="web.service.get.application"/>
    <xsl:param name="web.service.get.request.filename"/>
    <xsl:param name="web.service.get.request.type"/>
    <xsl:param name="web.service.get.request.endpoint"/>
    <xsl:param name="web.service.get.create.ws.xml.filename"/>
    <xsl:param name="web.service.get.create.ws.xml.endpoint"/>
    <xsl:param name="web.service.get.convert.to.xml"/>
    <xsl:param name="web.service.get.convert.to.xml.delimiter"/>
    <xsl:param name="web.service.get.convert.to.xml.filename"/>
    <xsl:param name="web.service.get.conform.xml"/>
    <xsl:param name="web.service.get.conform.xml.filename"/>
    <xsl:param name="web.service.get.conform.xml.endpoint"/>
    <xsl:param name="web.service.get.filter.multi.instance.1"/>
    <xsl:param name="web.service.get.filter.multi.instance.2"/>
    <xsl:param name="web.service.get.filter.multi.instance.3"/>
    <xsl:param name="web.service.get.filter.single.instance.1"/>
    <xsl:param name="web.service.get.filter.single.instance.2"/>
    <xsl:param name="web.service.get.filter.single.instance.3"/>
    <xsl:param name="web.service.get.response.endpoint"/>
    <xsl:param name="xml.split.namespace"/>
    <xsl:param name="xml.split.tag"/>
    <xsl:param name="report.alias"/>
    <xsl:param name="retrieval.file.labels"/>
    <!-- PUT Properties -->
    <xsl:param name="web.service.put.application"/>
    <xsl:param name="web.service.put.request.filename"/>
    <xsl:param name="web.service.put.request.endpoint"/>
    <xsl:param name="web.service.put.create.ws.xml.filename"/>
    <xsl:param name="web.service.put.create.ws.xml.endpoint"/>
    <xsl:param name="web.service.put.lookup.wd.data"/>
    <xsl:param name="web.service.put.lookup.wd.data.application"/>
    <xsl:param name="web.service.put.lookup.wd.data.request.type"/>
    <xsl:param name="web.service.put.lookup.wd.data.filename"/>
    <xsl:param name="web.service.put.lookup.wd.data.endpoint"/>
    <xsl:param name="web.service.put.update.multi.instance.1"/>
    <xsl:param name="web.service.put.update.multi.instance.2"/>
    <xsl:param name="web.service.put.update.multi.instance.3"/>
    <xsl:param name="web.service.put.update.single.instance.1"/>
    <xsl:param name="web.service.put.update.single.instance.2"/>
    <xsl:param name="web.service.put.update.single.instance.3"/>
    <xsl:param name="web.service.put.update.data.attribute"/>
    <xsl:param name="web.service.put.xml.split.namespace"/>
    <xsl:param name="web.service.put.xml.split.tag"/>
    <xsl:param name="web.service.put.workday.id.tag"/>
    <xsl:param name="web.service.put.workday.id.namespace"/>
    <!-- OUTPUT Properties -->
    <xsl:param name="output.transform.xml.filename"/>
    <xsl:param name="output.aggregation.data.type"/>
    <xsl:param name="output.file.delivery.service"/>
    <xsl:param name="output.file.sequencer"/>
    <xsl:param name="output.file.deliver.documents.attribute"/>
    <!-- Filter Attributes -->
    <xsl:param name="multi.instance.filter.1.wids"/>
    <xsl:param name="multi.instance.filter.2.wids"/>
    <xsl:param name="multi.instance.filter.3.wids"/>
    <xsl:param name="single.instance.filter.1.wids"/>
    <xsl:param name="single.instance.filter.2.wids"/>
    <xsl:param name="single.instance.filter.3.wids"/>
    <!-- Update Attributes -->
    <xsl:param name="multi.instance.update.1.wids"/>
    <xsl:param name="multi.instance.update.2.wids"/>
    <xsl:param name="multi.instance.update.3.wids"/>
    <xsl:param name="single.instance.update.1.wids"/>
    <xsl:param name="single.instance.update.2.wids"/>
    <xsl:param name="single.instance.update.3.wids"/>
    <xsl:param name="single.instance.update.1.name"/>
    <xsl:param name="single.instance.update.2.name"/>
    <xsl:param name="single.instance.update.3.name"/>
    <xsl:param name="update.data"/>
    <xsl:param name="deliver.documents"/>
    <!-- Report Properties -->
    <xsl:param name="report.extra.path"/>
    <xsl:param name="report.filter"/>


    <xsl:function name="fhc:forceValue" as="xs:decimal">
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
        <html>
            <head>
                <style>
                    table,
                    th,
                    td {
                        border: 1px solid black;
                        border-collapse: collapse;
                        font-family: 'Courier New';
                        text-align: left;
                    }
                    table {
                        width: 1000px;
                    }
                    th {
                        background-color: orange;
                        text-align: center;
                    }
                    th,
                    td {
                        padding: 3px;
                        font-size: 10px;
                        word-wrap: break-word;
                    }
                    th#primary_header {
                        font-size: 14px;
                        text-align: left;
                        background-color: white;
                    }
                    tr:nth-child(even) {
                        background-color: lightgray;
                    }</style>
            </head>
            <body>
                <table>
                    <tr>
                        <th colspan="3" id="primary_header">set-process-props-get information</th>
                    </tr>
                    <tr>
                        <th>Property Set</th>
                        <th>Property Name</th>
                        <th>Property Value</th>
                    </tr>
                    <tr>
                        <td>set-process-props-get</td>
                        <td>web.service.get.application</td>
                        <td>
                            <xsl:value-of select="$web.service.get.application"/>
                        </td>
                    </tr>
                    <tr>
                        <td>set-process-props-get</td>
                        <td>web.service.get.request.filename</td>
                        <td>
                            <xsl:value-of select="$web.service.get.request.filename"/>
                        </td>
                    </tr>
                    <tr>
                        <td>set-process-props-get</td>
                        <td>web.service.get.request.type</td>
                        <td>
                            <xsl:value-of select="$web.service.get.request.type"/>
                        </td>
                    </tr>
                    <tr>
                        <td>set-process-props-get</td>
                        <td>web.service.get.request.endpoint</td>
                        <td>
                            <xsl:value-of select="$web.service.get.request.endpoint"/>
                        </td>
                    </tr>
                    <tr>
                        <td>set-process-props-get</td>
                        <td>web.service.get.create.ws.xml.filename</td>
                        <td>
                            <xsl:value-of select="$web.service.get.create.ws.xml.filename"/>
                        </td>
                    </tr>
                    <tr>
                        <td>set-process-props-get</td>
                        <td>web.service.get.create.ws.xml.endpoint</td>
                        <td>
                            <xsl:value-of select="$web.service.get.create.ws.xml.endpoint"/>
                        </td>
                    </tr>
                    <tr>
                        <td>set-process-props-get</td>
                        <td>web.service.get.convert.to.xml</td>
                        <td>
                            <xsl:value-of select="$web.service.get.convert.to.xml"/>
                        </td>
                    </tr>
                    <tr>
                        <td>set-process-props-get</td>
                        <td>web.service.get.convert.to.xml.delimiter</td>
                        <td>
                            <xsl:value-of select="$web.service.get.convert.to.xml.delimiter"/>
                        </td>
                    </tr>
                    <tr>
                        <td>set-process-props-get</td>
                        <td>web.service.get.convert.to.xml.filename</td>
                        <td>
                            <xsl:value-of select="$web.service.get.convert.to.xml.filename"/>
                        </td>
                    </tr>
                    <tr>
                        <td>set-process-props-get</td>
                        <td>web.service.get.conform.xml</td>
                        <td>
                            <xsl:value-of select="$web.service.get.conform.xml"/>
                        </td>
                    </tr>
                    <tr>
                        <td>set-process-props-get</td>
                        <td>web.service.get.conform.xml.filename</td>
                        <td>
                            <xsl:value-of select="$web.service.get.conform.xml.filename"/>
                        </td>
                    </tr>
                    <tr>
                        <td>set-process-props-get</td>
                        <td>web.service.get.conform.xml.endpoint</td>
                        <td>
                            <xsl:value-of select="$web.service.get.conform.xml.endpoint"/>
                        </td>
                    </tr>
                    <tr>
                        <td>set-process-props-get</td>
                        <td>web.service.get.filter.multi.instance.1</td>
                        <td>
                            <xsl:value-of select="$web.service.get.filter.multi.instance.1"/>
                        </td>
                    </tr>
                    <tr>
                        <td>set-process-props-get</td>
                        <td>web.service.get.filter.multi.instance.2</td>
                        <td>
                            <xsl:value-of select="$web.service.get.filter.multi.instance.2"/>
                        </td>
                    </tr>
                    <tr>
                        <td>set-process-props-get</td>
                        <td>web.service.get.filter.multi.instance.3</td>
                        <td>
                            <xsl:value-of select="$web.service.get.filter.multi.instance.3"/>
                        </td>
                    </tr>
                    <tr>
                        <td>set-process-props-get</td>
                        <td>web.service.get.filter.single.instance.1</td>
                        <td>
                            <xsl:value-of select="$web.service.get.filter.single.instance.1"/>
                        </td>
                    </tr>
                    <tr>
                        <td>set-process-props-get</td>
                        <td>web.service.get.filter.single.instance.2</td>
                        <td>
                            <xsl:value-of select="$web.service.get.filter.single.instance.2"/>
                        </td>
                    </tr>
                    <tr>
                        <td>set-process-props-get</td>
                        <td>web.service.get.filter.single.instance.3</td>
                        <td>
                            <xsl:value-of select="$web.service.get.filter.single.instance.3"/>
                        </td>
                    </tr>
                    <tr>
                        <td>set-process-props-get</td>
                        <td>web.service.get.response.endpoint</td>
                        <td>
                            <xsl:value-of select="$web.service.get.response.endpoint"/>
                        </td>
                    </tr>
                    <tr>
                        <td>set-process-props-get</td>
                        <td>xml.split.namespace</td>
                        <td>
                            <xsl:value-of select="$xml.split.namespace"/>
                        </td>
                    </tr>
                    <tr>
                        <td>set-process-props-get</td>
                        <td>xml.split.tag</td>
                        <td>
                            <xsl:value-of select="$xml.split.tag"/>
                        </td>
                    </tr>
                    <tr>
                        <td>set-process-props-get</td>
                        <td>report.alias</td>
                        <td>
                            <xsl:value-of select="$report.alias"/>
                        </td>
                    </tr>
                    <tr>
                        <td>set-process-props-get</td>
                        <td>report.filter</td>
                        <td>
                            <xsl:value-of select="$report.filter"/>
                        </td>
                    </tr>
                    <tr>
                        <td>set-process-props-get</td>
                        <td>retrieval.file.labels</td>
                        <td>
                            <xsl:value-of select="$retrieval.file.labels"/>
                        </td>
                    </tr>
                </table>
                <br/>
                <table>
                    <tr>
                        <th colspan="3" id="primary_header">set-process-props-put information</th>
                    </tr>
                    <tr>
                        <th>Property Set</th>
                        <th>Property Name</th>
                        <th>Property Value</th>
                    </tr>
                    <tr>
                        <td>set-process-props-put</td>
                        <td>web.service.put.application</td>
                        <td>
                            <xsl:value-of select="$web.service.put.application"/>
                        </td>
                    </tr>
                    <tr>
                        <td>set-process-props-put</td>
                        <td>web.service.put.request.filename</td>
                        <td>
                            <xsl:value-of select="$web.service.put.request.filename"/>
                        </td>
                    </tr>
                    <tr>
                        <td>set-process-props-put</td>
                        <td>web.service.put.request.endpoint</td>
                        <td>
                            <xsl:value-of select="$web.service.put.request.endpoint"/>
                        </td>
                    </tr>
                    <tr>
                        <td>set-process-props-put</td>
                        <td>web.service.put.create.ws.xml.filename</td>
                        <td>
                            <xsl:value-of select="$web.service.put.create.ws.xml.filename"/>
                        </td>
                    </tr>
                    <tr>
                        <td>set-process-props-put</td>
                        <td>web.service.put.create.ws.xml.endpoint</td>
                        <td>
                            <xsl:value-of select="$web.service.put.create.ws.xml.endpoint"/>
                        </td>
                    </tr>
                    <tr>
                        <td>set-process-props-put</td>
                        <td>web.service.put.lookup.wd.data</td>
                        <td>
                            <xsl:value-of select="$web.service.put.lookup.wd.data"/>
                        </td>
                    </tr>
                    <tr>
                        <td>set-process-props-put</td>
                        <td>web.service.put.lookup.wd.data.application</td>
                        <td>
                            <xsl:value-of select="$web.service.put.lookup.wd.data.application"/>
                        </td>
                    </tr>
                    <tr>
                        <td>set-process-props-put</td>
                        <td>web.service.put.lookup.wd.data.request.type</td>
                        <td>
                            <xsl:value-of select="$web.service.put.lookup.wd.data.request.type"/>
                        </td>
                    </tr>
                    <tr>
                        <td>set-process-props-put</td>
                        <td>web.service.put.lookup.wd.data.filename</td>
                        <td>
                            <xsl:value-of select="$web.service.put.lookup.wd.data.filename"/>
                        </td>
                    </tr>
                    <tr>
                        <td>set-process-props-put</td>
                        <td>web.service.put.lookup.wd.data.endpoint</td>
                        <td>
                            <xsl:value-of select="$web.service.put.lookup.wd.data.endpoint"/>
                        </td>
                    </tr>
                    <tr>
                        <td>set-process-props-put</td>
                        <td>web.service.put.update.multi.instance.1</td>
                        <td>
                            <xsl:value-of select="$web.service.put.update.multi.instance.1"/>
                        </td>
                    </tr>
                    <tr>
                        <td>set-process-props-put</td>
                        <td>web.service.put.update.multi.instance.2</td>
                        <td>
                            <xsl:value-of select="$web.service.put.update.multi.instance.2"/>
                        </td>
                    </tr>
                    <tr>
                        <td>set-process-props-put</td>
                        <td>web.service.put.update.multi.instance.3</td>
                        <td>
                            <xsl:value-of select="$web.service.put.update.multi.instance.3"/>
                        </td>
                    </tr>
                    <tr>
                        <td>set-process-props-put</td>
                        <td>web.service.put.update.single.instance.1</td>
                        <td>
                            <xsl:value-of select="$web.service.put.update.single.instance.1"/>
                        </td>
                    </tr>
                    <tr>
                        <td>set-process-props-put</td>
                        <td>web.service.put.update.single.instance.2</td>
                        <td>
                            <xsl:value-of select="$web.service.put.update.single.instance.2"/>
                        </td>
                    </tr>
                    <tr>
                        <td>set-process-props-put</td>
                        <td>web.service.put.update.single.instance.3</td>
                        <td>
                            <xsl:value-of select="$web.service.put.update.single.instance.3"/>
                        </td>
                    </tr>
                    <tr>
                        <td>set-process-props-put</td>
                        <td>web.service.put.update.data.attribute</td>
                        <td>
                            <xsl:value-of select="$web.service.put.update.data.attribute"/>
                        </td>
                    </tr>
                    <tr>
                        <td>set-process-props-get</td>
                        <td>web.service.put.xml.split.namespace</td>
                        <td>
                            <xsl:value-of select="$web.service.put.xml.split.namespace"/>
                        </td>
                    </tr>
                    <tr>
                        <td>set-process-props-get</td>
                        <td>web.service.put.xml.split.tag</td>
                        <td>
                            <xsl:value-of select="$web.service.put.xml.split.tag"/>
                        </td>
                    </tr>
                    <tr>
                        <td>set-process-props-put</td>
                        <td>web.service.put.workday.id.tag</td>
                        <td>
                            <xsl:value-of select="$web.service.put.workday.id.tag"/>
                        </td>
                    </tr>
                    <tr>
                        <td>set-process-props-put</td>
                        <td>web.service.put.workday.id.namespace</td>
                        <td>
                            <xsl:value-of select="$web.service.put.workday.id.namespace"/>
                        </td>
                    </tr>
                </table>
                <br/>
                <table>
                    <tr>
                        <th colspan="3" id="primary_header">set-output-props information</th>
                    </tr>
                    <tr>
                        <th>Property Set</th>
                        <th>Property Name</th>
                        <th>Property Value</th>
                    </tr>
                    <tr>
                        <td>set-output-props</td>
                        <td>output.transform.xml.filename</td>
                        <td>
                            <xsl:value-of select="$output.transform.xml.filename"/>
                        </td>
                    </tr>
                    <tr>
                        <td>set-output-props</td>
                        <td>output.aggregation.data.type</td>
                        <td>
                            <xsl:value-of select="$output.aggregation.data.type"/>
                        </td>
                    </tr>
                    <tr>
                        <td>set-output-props</td>
                        <td>output.file.delivery.service</td>
                        <td>
                            <xsl:value-of select="$output.file.delivery.service"/>
                        </td>
                    </tr>
                    <tr>
                        <td>set-output-props</td>
                        <td>output.file.sequencer</td>
                        <td>
                            <xsl:value-of select="$output.file.sequencer"/>
                        </td>
                    </tr>
                    <tr>
                        <td>set-output-props</td>
                        <td>output.file.deliver.documents.attribute</td>
                        <td>
                            <xsl:value-of select="$output.file.deliver.documents.attribute"/>
                        </td>
                    </tr>
                </table>
                <br/>
                <table>
                    <tr>
                        <th colspan="3" id="primary_header">set-attribute-values information</th>
                    </tr>
                    <tr>
                        <th>Property Set</th>
                        <th>Property Name</th>
                        <th>Property Value</th>
                    </tr>
                    <tr>
                        <td>set-attribute-values</td>
                        <td>multi.instance.filter.1.wids</td>
                        <td>
                            <xsl:value-of select="$multi.instance.filter.1.wids"/>
                        </td>
                    </tr>
                    <tr>
                        <td>set-attribute-values</td>
                        <td>multi.instance.filter.2.wids</td>
                        <td>
                            <xsl:value-of select="$multi.instance.filter.2.wids"/>
                        </td>
                    </tr>
                    <tr>
                        <td>set-attribute-values</td>
                        <td>multi.instance.filter.3.wids</td>
                        <td>
                            <xsl:value-of select="$multi.instance.filter.3.wids"/>
                        </td>
                    </tr>
                    <tr>
                        <td>set-attribute-values</td>
                        <td>single.instance.filter.1.wids</td>
                        <td>
                            <xsl:value-of select="$single.instance.filter.1.wids"/>
                        </td>
                    </tr>
                    <tr>
                        <td>set-attribute-values</td>
                        <td>single.instance.filter.2.wids</td>
                        <td>
                            <xsl:value-of select="$single.instance.filter.2.wids"/>
                        </td>
                    </tr>
                    <tr>
                        <td>set-attribute-values</td>
                        <td>single.instance.filter.3.wids</td>
                        <td>
                            <xsl:value-of select="$single.instance.filter.3.wids"/>
                        </td>
                    </tr>
                    <tr>
                        <td>set-attribute-values</td>
                        <td>multi.instance.update.1.wids</td>
                        <td>
                            <xsl:value-of select="$multi.instance.update.1.wids"/>
                        </td>
                    </tr>
                    <tr>
                        <td>set-attribute-values</td>
                        <td>multi.instance.update.2.wids</td>
                        <td>
                            <xsl:value-of select="$multi.instance.update.2.wids"/>
                        </td>
                    </tr>
                    <tr>
                        <td>set-attribute-values</td>
                        <td>multi.instance.update.3.wids</td>
                        <td>
                            <xsl:value-of select="$multi.instance.update.3.wids"/>
                        </td>
                    </tr>
                    <tr>
                        <td>set-attribute-values</td>
                        <td>single.instance.update.1.wids</td>
                        <td>
                            <xsl:value-of select="$single.instance.update.1.wids"/>
                        </td>
                    </tr>
                    <tr>
                        <td>set-attribute-values</td>
                        <td>single.instance.update.2.wids</td>
                        <td>
                            <xsl:value-of select="$single.instance.update.2.wids"/>
                        </td>
                    </tr>
                    <tr>
                        <td>set-attribute-values</td>
                        <td>single.instance.update.3.wids</td>
                        <td>
                            <xsl:value-of select="$single.instance.update.3.wids"/>
                        </td>
                    </tr>
                    <tr>
                        <td>set-attribute-values</td>
                        <td>single.instance.update.1.name</td>
                        <td>
                            <xsl:value-of select="$single.instance.update.1.name"/>
                        </td>
                    </tr>
                    <tr>
                        <td>set-attribute-values</td>
                        <td>single.instance.update.2.name</td>
                        <td>
                            <xsl:value-of select="$single.instance.update.2.name"/>
                        </td>
                    </tr>
                    <tr>
                        <td>set-attribute-values</td>
                        <td>single.instance.update.3.name</td>
                        <td>
                            <xsl:value-of select="$single.instance.update.3.name"/>
                        </td>
                    </tr>
                    <tr>
                        <td>set-attribute-values</td>
                        <td>update.data</td>
                        <td>
                            <xsl:value-of select="$update.data"/>
                        </td>
                    </tr>
                    <tr>
                        <td>set-attribute-values</td>
                        <td>deliver.documents</td>
                        <td>
                            <xsl:value-of select="$deliver.documents"/>
                        </td>
                    </tr>
                </table>
                <br/>
                <table>
                    <tr>
                        <th colspan="3" id="primary_header">set-report-props information</th>
                    </tr>
                    <tr>
                        <th>Property Set</th>
                        <th>Property Name</th>
                        <th>Property Value</th>
                    </tr>
                    <tr>
                        <td>set-report-props</td>
                        <td>report.extra.path</td>
                        <td>
                            <xsl:value-of select="$report.extra.path"/>
                        </td>
                    </tr>
                    <tr>
                        <td>set-report-props</td>
                        <td>report.filter</td>
                        <td>
                            <xsl:value-of select="$report.filter"/>
                        </td>
                    </tr>
                </table>
                <br/>
            </body>
        </html>
    </xsl:template>

</xsl:stylesheet>
