<?xml version="1.0" encoding="UTF-8"?>

<!-- convert a CWRC person (<identity>) item into JSON Formate ref. 2012-05-04 email Mariana -->

<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:json="http://json.org/"
    version="2.0"
    >

    <xsl:import href="xml-to-json.xsl"/>
    <xsl:param name="use-badgerfish" as="xs:boolean" select="true()"/>
    
    <xsl:template match="entity">
        <xsl:value-of select="json:generate(.)"/>
    </xsl:template>
 
    
</xsl:stylesheet>