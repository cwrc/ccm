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
            <recordInfo>
                <projectId>orlando</projectId>
                <projectId>otherProjectId</projectId>
                <!-- <entityId>
                </entityId> -->
                <!-- entityId can hold FOXML\'s PID -->
            </recordInfo>
            <identity>
                <entityType>person</entityType>
                <preferredForm>
                    <namePart partType="forename">Victoria</namePart>
                    <namePart>Queen</namePart>
                </preferredForm>
                <displayLabel>Queen Victoria</displayLabel>
                <personTypes>
                    <personType>orl:BWW</personType>
                    <personType>canwwr:creator</personType>
                </personTypes>
                <sameAs>http://sw.opencyc.org/concept/Mx4rwMSm5JwpEbGdrcN5Y29ycA</sameAs>
                <sameAs certaininty="reasonable">http://dbpedia.org/resource/Victoria_of_the_United_Kingdom</sameAs>
            </identity>
            <description>
                <variantForms>
                    <variant>
                        <namePart>Alexandrina Victoria</namePart>
                        <!-- can occur one or more -->
                            <variantType>birthName</variantType>
                        </variant>
                        <variant>
                        <namePart>Queen Victoria</namePart>
                        <variantType>royalName</variantType>
                    </variant>
                    <variant>
                        <namePart>Queen Victoria, Empress of India</namePart>
                        <variantType>titledName</variantType>
                    </variant>
                    <variant>
                        <namePart>Princess Victoria</namePart>
                        <variantType>usedForm</variantType>
                    </variant>
                </variantForms>
                <existDates>
                    <dateRange cert="certain">
                        <fromDate>
                            <standardDate>1819-05-24</standardDate>
                            <textDate>24 May 1819</textDate>
                            <dateType>birth</dateType>
                        </fromDate>
                        <toDate>
                            <standardDate>1901-01-22</standardDate>
                            <textDate>22 January 1901</textDate>
                            <dateType>death</dateType>
                        </toDate>
                    </dateRange>
                    <dateSingle>
                        <standardDate>1838-06-28</standardDate>
                        <textDate>28 June 1838</textDate>
                        <dateType>other</dateType>
                        <note>
                            <p>Coronation date. Sample note providing information on date type "other."</p>
                            <p>Sample optional second paragraph.</p>
                            <projectId>orlando</projectId>
                            <access>public</access>
                        </note>
                    </dateSingle>
                </existDates>
                <descriptiveNote>
                    <p>Sample text in a descriptive note about Queen Victoria.</p>
                    <p>Sample optional second paragraph in note.</p>
                    <access>project</access>
                    <projectId>orlando</projectId>
                </descriptiveNote>
            </description>
        </entity>
        '
        ) 
  end # xml_template
  
  
  def display_name
    
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
