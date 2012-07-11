
# a Fedora Datastream object containing information about a Person entity 

class CcmContentDatastream < ActiveFedora::NokogiriDatastream

  set_terminology do |t|
    ##t.root(:path=>"entity", :xmlns=>"http://www.cwrc.ca/schema/entities", :schema=>"http://www.cwrc.ca/schema/entities")
    t.root(:path=>"ccm-content")
    t.xml_description(:path=>"ccm-content")
  end # set_terminology

  def get_xml_string
    ## Returns the XML description of the record as a string
    
    envelope = self.find_by_terms(:xml_description).first
    ver = envelope.get_attribute('version')
    enc = envelope.get_attribute('encoding')
    version_string = "<?xml version=\"#{ver}\" encoding=\"#{enc}\"?>"
    
    return version_string + envelope.elements.first.to_s
  end

  def get_xml_element
    ## Returns the XML description of the record as an XML element
    
    envelope = self.find_by_terms(:xml_description).first
    return envelope.elements.first
  end

  def replace_xml_string(xmlString)
    ## Updates the XML description of the record using the given xmlString
    
    new_desc_doc = Nokogiri::XML::Document.parse(xmlString)

    ##Updating the version and encoding attributes of the envelope     
    envelope = self.find_by_terms(:xml_description).first
    envelope.set_attribute('version', new_desc_doc.version) unless new_desc_doc.version.nil?
    envelope.set_attribute('encoding', new_desc_doc.encoding) unless new_desc_doc.encoding.nil?
    
    ##Removing all child elements of the envelope. Actually, we should have only one
    while envelope.elements.count > 0
      envelope.elements.first.remove
    end
    
    ##Inserting the new element to the envelope
    envelope.add_child(new_desc_doc.root)

    ##Indicating that the XML description was updated, so that item must be saved to the repository.     
    self.dirty = true
  end

  def replace_xml_element(xmlElement)
    ## Updates the XML description of the record using the given xmlElement
    
    ##Updating the version and encoding attributes of the envelope     
    envelope = self.find_by_terms(:xml_description).first
    
    ##Removing all child elements of the envelope. Actually, we should have only one
    while envelope.elements.count > 0
      envelope.elements.first.remove
    end
    
    ##Inserting the new element to the envelope
    envelope.add_child(xmlElement)

    ##Indicating that the XML description was updated, so that item must be saved to the repository.     
    self.dirty = true
  end

  def self.xml_template
    Nokogiri::XML::Document.parse(
       '<?xml version="1.0" encoding="UTF-8"?>
        <ccm-content version="1.0" encoding="UTF-8">
        </ccm-content>
        '
        ) 
  end # xml_template
  
end # class
