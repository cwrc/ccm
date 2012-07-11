
class CwrcEntity < ActiveFedora::Base
  
  
  has_metadata :name => "cwrcMetadata", :type=> CwrcDatastream
  
  

#
#  def self.list_ids(pageNumber, itemsPerPage)
#    entities = CwrcEntity.find(:all).paginate(:page => pageNumber, :per_page => params[:perpage])
#    
#    builder = Nokogiri::XML::Builder.new do |xml|
#      xml.pidList(:pageNumber=>"#{pageNumber}", :itemsPerPage=>"#{itemsPerPage}")
#      
#      if partType == nil
#        xml.namePart
#      else
#        xml.namePart(:partType=>"#{partType}")
#      end
#      
#    end
#    return builder.doc.root
#    
#  end
#
  
  def get_xml_description
    return datastreams["cwrcMetadata"].get_xml_description
  end

  def replace_xml_description(xmlString)
    return datastreams["cwrcMetadata"].replace_xml_description(xmlString)
  end

  def to_solr(solr_doc=Hash.new)
    super
    solr_doc["object_type_facet"] = "CwrcEntity"
    return solr_doc
  end
  
  def self.delete_all
    CwrcEntity.find(:all).each do |x|
      begin
        x.delete
      rescue
      end
    end
  end
  
  def self.get_latest_pids
    CwrcEntity.find(:all)
  end

end

