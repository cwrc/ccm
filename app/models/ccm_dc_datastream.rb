class CcmDcDatastream < ActiveFedora::NokogiriDatastream

  include CcmDatastreamMethods
  
  set_terminology do |t|
    ##t.root(:path=>"entity", :xmlns=>"http://www.cwrc.ca/schema/entities", :schema=>"http://www.cwrc.ca/schema/entities")
    t.root(:path=>"dc", "xmlns:oai_dc"=>"http://www.openarchives.org/OAI/2.0/oai_dc/", "xmlns:dc"=>"http://purl.org/dc/elements/1.1/", :schema=>"http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd")
    t.xml_description(:path=>"oai_dc:dc")
  end # set_terminology


  def self.xml_template
    Nokogiri::XML::Document.parse(
      '<oai_dc:dc xmlns:dc="http://purl.org/dc/elements/1.1/"
          xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd">
          <dc:title></dc:title>
          <dc:creator></dc:creator>
          <dc:subject></dc:subject>
          <dc:description></dc:description>
          <dc:publisher></dc:publisher>
          <dc:contributor></dc:contributor>
          <dc:date></dc:date>
          <dc:type></dc:type>
          <dc:format></dc:format>
          <dc:identifier></dc:identifier>
          <dc:source></dc:source>
          <dc:language></dc:language>
          <dc:relation></dc:relation>
          <dc:coverage></dc:coverage>
          <dc:rights></dc:rights>
      </oai_dc:dc>
      '
       ) 
  end # xml_template
  
  def set_field(field_name, value)
    root = get_xml_description
  end
  

end
