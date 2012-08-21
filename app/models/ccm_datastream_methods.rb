# This module defines common methods for data streams used in CCM models

module CcmDatastreamMethods
  
  
  def get_xml_description
    ## Returns the XML description of the record
    
    return self.find_by_terms(:xml_description).first
  end
  
  def replace_xml_description(xmlString)
    ## Updates the XML description of the record using the given xmlString
    
    parent = self.find_by_terms(:xml_description).first.parent
    self.find_by_terms(:xml_description).first.remove

    new_desc = Nokogiri::XML::Document.parse(xmlString).root
    parent.add_child(new_desc)
    
    self.dirty = true
  end
   
end

