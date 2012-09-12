class CcmWorkflowDatastream < ActiveFedora::NokogiriDatastream

  include CcmDatastreamMethods
  
  set_terminology do |t|
    t.root(:path=>"ccm-workflow")
    t.xml_description(:path=>"ccm-workflow")
  end # set_terminology

  def self.xml_template
    Nokogiri::XML::Document.parse(
       '<?xml version="1.0" encoding="UTF-8"?>
        <ccm-workflow version="1.0" encoding="UTF-8">
        </ccm-workflow>
        '
        ) 
  end # xml_template
  
  def add_stamp(xmlstring)
    ds_root = self.find_by_terms(:xml_description).first
    stamp_wrapper = Nokogiri::XML::Document.parse("<Stamp-Container version='#{ds_root.elements.count + 1}'/>").root
    
    new_stamp_doc = Nokogiri::XML::Document.parse(xmlstring)
    stamp_wrapper.add_child(new_stamp_doc.root)
    ds_root.add_child(stamp_wrapper)
    
    self.dirty = true
  end  
  
  def get_stamps()
    ds_root = self.find_by_terms(:xml_description).first
    stamp_array = Array.new
    
    unless ds_root.nil?
      ds_root.elements.each do |wrapper|
        stamp_array[wrapper.get_attribute('version').to_i - 1] = wrapper.elements
      end
    end
    
    return stamp_array
  end
end