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
          <dc:created></dc:created>
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
  

  def title=(val)
    begin
      set_text("//dc:title", val)
    rescue
      add_element("//oai_dc:dc", "<dc:title>#{val}</dc:title>")
    end
  end
  
  def title
    get_text("//dc:title")
  end
  
  def identifier=(val)
    begin
      set_text("//dc:identifier", val)
    rescue
      add_element("//oai_dc:dc", "<dc:identifier>#{val}</dc:identifier>")
    end
  end
  
  def identifier
    get_text("//dc:identifier")
  end  

  def creator=(val)
    begin
      set_text("//dc:creator", val)
    rescue
      add_element("//oai_dc:dc", "<dc:creator>#{val}</dc:creator>")
    end
  end
  
  def creator
    get_text("//dc:creator")
  end  

  def created=(val)
    begin
      set_text("//dc:created", val)
    rescue
      add_element("//oai_dc:dc", "<dc:created>#{val}</dc:created>")
    end
  end
  
  def created
    get_text("//dc:created")
  end  

  def date=(val)
    begin
      set_text("//dc:date", val)
    rescue
      add_element("//oai_dc:dc", "<dc:date>#{val}</dc:date>")
    end
  end
  
  def date
    get_text("//dc:date")
  end  

  def type=(val)
    begin
      set_text("//dc:type", val)
    rescue
      add_element("//oai_dc:dc", "<dc:type>#{val}</dc:type>")
    end
  end
  
  def type
    get_text("//dc:type")
  end  

  def rights=(val)
    begin
      set_text("//dc:rights", val)
    rescue
      add_element("//oai_dc:dc", "<dc:rights>#{val}</dc:rights>")
    end
  end
  
  def rights
    get_text("//dc:rights")
  end
  
  def add_contributor(val)
    val.each do |v|
      add_element("//oai_dc:dc", "<dc:contributor>#{v}</dc:contributor>")
    end
  end 

  def remove_contributor(val)
    remove_element("//dc:contributor", val)
  end
  
  def contributors
    get_text("//dc:contributor", true)
  end 

  def add_language(val)
    val.each do |v|
      add_element("//oai_dc:dc", "<dc:language>#{v}</dc:language>")
    end
  end 

  def remove_language(val)
    remove_element("//dc:language", val)
  end
  
  def languages
    get_text("//dc:language", true)
  end 

  def add_publisher(val)
    val.each do |v|
      add_element("//oai_dc:dc", "<dc:publisher>#{v}</dc:publisher>")
    end
  end 

  def remove_publisher(val)
    remove_element("//dc:publisher", val)
  end
  
  def publishers
    get_text("//dc:publisher", true)
  end 

end
