class CcmEntityDatastream < ActiveFedora::NokogiriDatastream
  
  include CcmDatastreamMethods

  set_terminology do |t|
    ##t.root(:path=>"entity", :xmlns=>"http://www.cwrc.ca/schema/entities", :schema=>"http://www.cwrc.ca/schema/entities")
    t.root(:path=>"entity")
    t.xml_description(:path=>"entity")
  end # set_terminology

  def self.xml_template
    Nokogiri::XML::Document.parse(
       '<?xml version="1.0" encoding="UTF-8"?>
        <entity>
          <person>
             <identity>
              <preferredForm>
                <displayForm>Display Name</displayForm>
                <namePart partType="forename">Forename</namePart>
                <namePart partType="surname">Surname</namePart>
              </preferredForm>
             </identity>
          </person>
        </entity>
        '
        ) 
  end # xml_template
  
  
  def display_name
    get_text('/entity/*/identity/preferredForm/displayForm')
  end
  
  def forename
    get_text('/entity/*/identity/preferredForm/namePart[@partType="forename"]')
  end

  def surname
    get_text('/entity/*/identity/preferredForm/namePart[@partType="surname"]')
  end

#  
#  def create_xml_description(xmlString)
#    ## Updates the XML description of the record using the given xmlString
#    
#    old_desc = self.find_by_terms(:xml_description).first
#    doc = old_desc.parent
#    old_desc.remove
#   new_doc = Nokogiri::XML::Document.parse(xmlString)
#    new_desc = new_doc.root
#    
#    doc.add_child(new_desc)
#  end
#
  
  

end # class
