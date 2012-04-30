
class CwrcItem < ActiveFedora::Base
  
  
  has_metadata :name => "ccmContentMetadata", :type=> CcmContentDatastream
  
  
  def get_xml_description
    return datastreams["ccmContentMetadata"].get_xml_description
  end

  def replace_xml_description(xmlString)
    return datastreams["ccmContentMetadata"].replace_xml_description(xmlString)
  end

#  def to_solr(solr_doc=Hash.new)
#    super
#    solr_doc["object_type_facet"] = "CwrcContent"
#    return solr_doc
#  end
  
  def self.delete_all
    CwrcItem.find(:all).each do |x|
      begin
        x.delete
      rescue
      end
    end
  end
  
  def self.get_latest_pids
    CwrcItem.find(:all)
  end
  
end
